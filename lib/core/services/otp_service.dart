import "dart:math";
import "package:otp/otp.dart";
import "package:coinhub/core/services/local_storage.dart";

class OtpService {
  final _storage = LocalStorageService();

  /// Generate a Base32 secret for TOTP and store it
  void init() {
    final random = Random.secure();
    final bytes = List<int>.generate(10, (_) => random.nextInt(256));
    final secret =
        OTP.randomSecret(); // You can also Base32 encode your own bytes

    _storage.write("OTP", secret);
    print("Generated and stored secret: $secret");
  }

  /// Generate the current OTP based on stored secret and current time
  String generateOtp() {
    final secret = _storage.read("OTP").toString();

    final otp = OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      interval: 30,
      length: 6,
      algorithm: Algorithm.SHA1,
    );

    return otp;
  }

  /// Compare the entered OTP with the currently generated one
  bool verifyOtp(String enteredOtp) {
    return enteredOtp == generateOtp();
  }
}
