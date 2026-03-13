import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/qr_scanner_bloc.dart';
import '../bloc/qr_scanner_event.dart';
import '../bloc/qr_scanner_state.dart';

/// Full-screen QR scanner page.
///
/// Returns the scanned [String] via [Navigator.pop] when a valid QR is found.
/// Usage: `final qr = await context.push<String>(AppRoutes.checkInQr);`
class QrScannerPage extends StatelessWidget {
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QrScannerBloc>()..add(const QrScannerStarted()),
      child: const _QrScannerView(),
    );
  }
}

class _QrScannerView extends StatefulWidget {
  const _QrScannerView();

  @override
  State<_QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<_QrScannerView> {
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.qrScanTitle),
        actions: [
          // Torch toggle
          IconButton(
            icon: const Icon(Icons.flashlight_on_rounded),
            onPressed: () => _controller.toggleTorch(),
          ),
          // Camera flip
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_rounded),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: BlocListener<QrScannerBloc, QrScannerState>(
        listener: (context, state) {
          if (state is QrScannerSuccess) {
            // Stop camera before popping
            _controller.stop();
            Navigator.of(context).pop(state.result.rawValue);
          }
          if (state is QrScannerFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                action: SnackBarAction(
                  label: 'ลองใหม่',
                  textColor: Colors.white,
                  onPressed: () => context
                      .read<QrScannerBloc>()
                      .add(const QrScannerReset()),
                ),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // ── Camera preview ────────────────────────────
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                final barcode = capture.barcodes.firstOrNull;
                final value = barcode?.rawValue;
                if (value != null) {
                  context
                      .read<QrScannerBloc>()
                      .add(QrCodeDetected(value));
                }
              },
            ),

            // ── Overlay frame ─────────────────────────────
            _ScanOverlay(),

            // ── Instruction banner ────────────────────────
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    AppStrings.qrScanInstruction,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Darkened overlay with a transparent square cut-out indicating scan area.
class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanSize = size.width * 0.65;

    return CustomPaint(
      size: size,
      painter: _OverlayPainter(scanSize: scanSize),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final double scanSize;

  _OverlayPainter({required this.scanSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final half = scanSize / 2;

    // Draw 4 dark rectangles around the cutout
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, cy - half), paint);
    canvas.drawRect(
        Rect.fromLTRB(0, cy + half, size.width, size.height), paint);
    canvas.drawRect(Rect.fromLTRB(0, cy - half, cx - half, cy + half), paint);
    canvas.drawRect(
        Rect.fromLTRB(cx + half, cy - half, size.width, cy + half), paint);

    // Corner brackets
    final bracketPaint = Paint()
      ..color = AppColors.primaryLight
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    const r = 12.0;
    const len = 28.0;
    final l = cx - half;
    final t = cy - half;
    final ri = cx + half;
    final b = cy + half;

    // Top-left
    canvas.drawPath(
        Path()
          ..moveTo(l + len, t)
          ..lineTo(l + r, t)
          ..arcToPoint(Offset(l, t + r),
              radius: const Radius.circular(r), clockwise: false)
          ..lineTo(l, t + len),
        bracketPaint);
    // Top-right
    canvas.drawPath(
        Path()
          ..moveTo(ri - len, t)
          ..lineTo(ri - r, t)
          ..arcToPoint(Offset(ri, t + r),
              radius: const Radius.circular(r), clockwise: true)
          ..lineTo(ri, t + len),
        bracketPaint);
    // Bottom-left
    canvas.drawPath(
        Path()
          ..moveTo(l, b - len)
          ..lineTo(l, b - r)
          ..arcToPoint(Offset(l + r, b),
              radius: const Radius.circular(r), clockwise: true)
          ..lineTo(l + len, b),
        bracketPaint);
    // Bottom-right
    canvas.drawPath(
        Path()
          ..moveTo(ri, b - len)
          ..lineTo(ri, b - r)
          ..arcToPoint(Offset(ri - r, b),
              radius: const Radius.circular(r), clockwise: false)
          ..lineTo(ri - len, b),
        bracketPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
