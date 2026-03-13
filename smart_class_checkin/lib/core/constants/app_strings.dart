class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Smart Class Check-in';

  // Home
  static const String homeTitle = 'หน้าหลัก';
  static const String checkInButton = 'เช็คชื่อเข้าเรียน';
  static const String finishClassButton = 'เสร็จสิ้นการเรียน';

  // Check-in screen
  static const String checkInTitle = 'เช็คชื่อเข้าเรียน';
  static const String previousTopicLabel = 'หัวข้อที่เรียนครั้งที่แล้ว';
  static const String previousTopicHint = 'ระบุหัวข้อบทเรียนครั้งก่อน';
  static const String expectedTopicLabel = 'หัวข้อที่คาดว่าจะเรียนวันนี้';
  static const String expectedTopicHint = 'ระบุหัวข้อที่คาดหวัง';
  static const String moodLabel = 'อารมณ์ก่อนเรียน (1–5)';
  static const String postClassMoodLabel = 'ความรู้สึกหลังเรียน (1–5)';
  static const String confirmCheckIn = 'ยืนยันเช็คชื่อ';

  // Finish class screen
  static const String checkOutTitle = 'สรุปการเรียน';
  static const String learnedTodayLabel = 'สิ่งที่เรียนรู้วันนี้';
  static const String learnedTodayHint = 'สรุปสั่นๆ ว่าเรียนรู้อะไร';
  static const String feedbackLabel = 'ความคิดเห็นต่อครู/ชั้นเรียน';
  static const String feedbackHint = 'ข้อเสนอแนะหรือความรู้สึก';
  static const String confirmFinish = 'ยืนยันเสร็จสิ้นการเรียน';

  // QR Scanner
  static const String qrScanTitle = 'สแกน QR Code';
  static const String qrScanInstruction = 'จัดกรอบ QR Code ให้อยู่ในช่อง';
  static const String qrError = 'ไม่สามารถอ่าน QR Code ได้ กรุณาลองใหม่';

  // GPS
  static const String gpsRequesting = 'กำลังดึงตำแหน่ง GPS...';
  static const String gpsSuccess = 'ได้รับตำแหน่งแล้ว';
  static const String gpsError = 'ไม่สามารถดึงตำแหน่งได้';
  static const String gpsPermissionDenied = 'กรุณาอนุญาตการเข้าถึงตำแหน่ง';

  // Validation
  static const String fieldRequired = 'กรุณากรอกข้อมูล';
  static const String moodRequired = 'กรุณาเลือกระดับอารมณ์';

  // Success / Error
  static const String checkInSuccess = 'เช็คชื่อเข้าเรียนสำเร็จ';
  static const String checkOutSuccess = 'บันทึกการเรียนสำเร็จ';
  static const String genericError = 'เกิดข้อผิดพลาด กรุณาลองใหม่';
  static const String saveError = 'ไม่สามารถบันทึกข้อมูลได้';
}
