import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/check_out_bloc.dart';
import '../bloc/check_out_event.dart';
import '../bloc/check_out_state.dart';
import '../widgets/post_class_form.dart';
import '../../../qr_scanner/presentation/pages/qr_scanner_page.dart';

// ── Temporary student ID constant (replace with Auth when available) ──────────
const _kStudentId = 'STU001';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CheckOutBloc>()
        ..add(const CheckOutStarted(studentId: _kStudentId)),
      child: const _CheckOutView(),
    );
  }
}

class _CheckOutView extends StatelessWidget {
  const _CheckOutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.checkOutTitle)),
      body: BlocConsumer<CheckOutBloc, CheckOutState>(
        listener: (context, state) {
          if (state is CheckOutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.checkOutSuccess),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          }
          if (state is CheckOutFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                action: SnackBarAction(
                  label: 'ลองใหม่',
                  textColor: Colors.white,
                  onPressed: () =>
                      context.read<CheckOutBloc>().add(const CheckOutReset()),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CheckOutLocationLoading) {
            return const _StatusView(
              icon: Icons.location_searching_rounded,
              message: AppStrings.gpsRequesting,
              showSpinner: true,
            );
          }
          if (state is CheckOutAwaitingQr) {
            return _QrPromptView(state: state);
          }
          if (state is CheckOutFormReady) {
            return _FormView(state: state);
          }
          if (state is CheckOutSaving) {
            return const _StatusView(
              icon: Icons.save_rounded,
              message: 'กำลังบันทึกข้อมูล...',
              showSpinner: true,
            );
          }
          return const _StatusView(
            icon: Icons.logout_rounded,
            message: 'กำลังเริ่มต้น...',
          );
        },
      ),
    );
  }
}

// ── Sub-views ─────────────────────────────────────────────────────────────────

class _StatusView extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool showSpinner;

  const _StatusView({
    required this.icon,
    required this.message,
    this.showSpinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showSpinner)
              const CircularProgressIndicator()
            else
              Icon(icon, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _QrPromptView extends StatelessWidget {
  final CheckOutAwaitingQr state;

  const _QrPromptView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // GPS badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    '${state.latitude.toStringAsFixed(5)}, '
                    '${state.longitude.toStringAsFixed(5)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Icon(Icons.qr_code_scanner_rounded,
                size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              AppStrings.qrScanInstruction,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text(AppStrings.qrScanTitle),
              onPressed: () => _openScanner(context),
            ),
          ],
        ),
      ),
    );
  }

  void _openScanner(BuildContext context) async {
    final qrValue = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const QrScannerPage()),
    );
    if (qrValue != null && context.mounted) {
      context.read<CheckOutBloc>().add(CheckOutQrScanned(qrValue));
    }
  }
}

class _FormView extends StatelessWidget {
  final CheckOutFormReady state;

  const _FormView({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: Icons.location_on,
                    label: 'GPS',
                    value:
                        '${state.latitude.toStringAsFixed(5)}, ${state.longitude.toStringAsFixed(5)}',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.qr_code,
                    label: 'QR',
                    value: state.qrCode,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Post-class form
          PostClassForm(
            onSubmit: ({required learnedToday, required feedback, required postClassMood}) {
              context.read<CheckOutBloc>().add(
                    CheckOutFormSubmitted(
                      studentId: _kStudentId,
                      learnedToday: learnedToday,
                      feedback: feedback,
                      postClassMood: postClassMood,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text('$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
