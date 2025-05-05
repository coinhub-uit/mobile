// services/biometric_service.dart
import "package:local_auth/local_auth.dart";
import "package:flutter/services.dart";

class BiometricService {
  final _localAuth = LocalAuthentication();

  Future<bool> authenticate({
    String reason = "Please authenticate to continue",
  }) async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      print("Biometric error: $e");
      return false;
    }
  }
}
