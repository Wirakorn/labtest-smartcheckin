import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../presentation/bloc/check_in_bloc.dart';
import '../../presentation/bloc/check_in_event.dart';
import '../../presentation/bloc/check_in_state.dart';
import '../widgets/pre_class_form.dart';
import '../../../qr_scanner/presentation/pages/qr_scanner_page.dart';

// ── Temporary student ID constant (replace with Auth when available) ──────────
const _kStudentId = 'STU001';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CheckInBloc>()..add(const CheckInStarted()),
      child: const _CheckInView(),
    );
  }
}

class _CheckInView extends StatelessWidget {
  const _CheckInView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.checkInTitle)),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listener: (context, state) {
          if (state is CheckInSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.checkInSuccess),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop(); // back to Home
          }
          if (state is CheckInFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                action: SnackBarAction(
                  label: 'ลองใหม่',
                  textColor: Colors.white,
                  onPressed: () =>
                      context.read<CheckInBloc>().add(const CheckInReset()),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          // ── Loading GPS ──────────────────────────────────
          if (state is CheckInLocationLoading) {
            return const _StatusView(
              icon: Icons.location_searching_rounded,
              message: AppStrings.gpsRequesting,
              showSpinner: true,
            );
          }

          // ── Awaiting QR ───────────────────────────────────
          if (state is CheckInAwaitingQr) {
            return _QrPromptView(state: state);
          }

          // ── Form ready ────────────────────────────────────
          if (state is CheckInFormReady) {
            return _FormView(state: state);
          }

          // ── Saving ────────────────────────────────────────
          if (state is CheckInSaving) {
            return const _StatusView(
              icon: Icons.save_rounded,
              message: 'กำลังบันทึกข้อมูล...',
              showSpinner: true,
            );
          }

          // ── Initial / error (handled via listener) ────────
          return const _StatusView(
            icon: Icons.login_rounded,
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
  final CheckInAwaitingQr state;

  const _QrPromptView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // GPS success badge
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
      context.read<CheckInBloc>().add(CheckInQrScanned(qrValue));
    }
  }
}

class _FormView extends StatelessWidget {
  final CheckInFormReady state;

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

          // Pre-class form
          PreClassForm(
            onSubmit: ({
              required previousTopic,
              required expectedTopic,
              required mood,
            }) {
              context.read<CheckInBloc>().add(
                    CheckInFormSubmitted(
                      studentId: _kStudentId,
                      previousTopic: previousTopic,
                      expectedTopic: expectedTopic,
                      mood: mood,
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
