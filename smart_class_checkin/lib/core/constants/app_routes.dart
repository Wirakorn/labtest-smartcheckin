class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String checkIn = '/check-in';
  static const String checkInQr = '/check-in/qr';
  static const String checkOut = '/finish-class';
  static const String checkOutQr = '/finish-class/qr';

  /// Named parameter key for QR result passed back from scanner.
  static const String qrResultKey = 'qrResult';
}
