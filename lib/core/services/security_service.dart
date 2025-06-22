import "package:flutter/material.dart";
import "package:coinhub/core/services/biometric_service.dart";
import "package:coinhub/core/services/local_storage.dart";
import "package:coinhub/presentation/screen/auth/pin_verification_screen.dart";
import "package:go_router/go_router.dart";
import "package:coinhub/presentation/routes/routes.dart";

enum AuthenticationType {
  sensitiveOperation, // For transfers, saving plans, new sources - go back home on failure
  timeout, // For timeout scenarios that require logout
}

class SecurityService {
  static final BiometricService _biometricService = BiometricService();
  static final LocalStorageService _storage = LocalStorageService();

  /// Check if any security method is enabled
  static Future<bool> isSecurityEnabled() async {
    final pinEnabled = await _storage.read("pin_enabled") == "true";
    final fingerprintEnabled =
        await _storage.read("fingerprint_enabled") == "true";
    final faceIdEnabled = await _storage.read("face_id_enabled") == "true";

    return pinEnabled || fingerprintEnabled || faceIdEnabled;
  }

  /// Authenticate user for sensitive operations
  /// Returns true if authentication successful, false otherwise
  static Future<bool> authenticateForSensitiveOperation(
    BuildContext context, {
    String title = "Security Verification",
    String subtitle = "Please authenticate to continue this operation",
    AuthenticationType type = AuthenticationType.sensitiveOperation,
  }) async {
    try {
      // Check if security is enabled
      final securityEnabled = await isSecurityEnabled();
      if (!securityEnabled) {
        // No security setup, allow operation
        return true;
      }

      // Check what authentication methods are available
      final pinEnabled = await _storage.read("pin_enabled") == "true";
      final fingerprintEnabled =
          await _storage.read("fingerprint_enabled") == "true";
      final faceIdEnabled = await _storage.read("face_id_enabled") == "true";
      final biometricEnabled = fingerprintEnabled || faceIdEnabled;

      // Try biometric first if enabled
      if (biometricEnabled) {
        try {
          final biometricResult = await _biometricService.authenticate(
            reason: subtitle,
          );

          if (biometricResult) {
            return true;
          }

          // Biometric failed, fall back to PIN if available
          if (!pinEnabled) {
            // Only biometric was enabled and it failed
            return false;
          }
        } catch (e) {
          // Biometric error, fall back to PIN if available
          if (!pinEnabled) {
            return false;
          }
        }
      }

      // Use PIN authentication
      if (pinEnabled) {
        if (!context.mounted) return false;

        return await _showPinVerification(context, title, subtitle, type);
      }

      // No authentication method worked
      return false;
    } catch (e) {
      debugPrint("Security authentication error: $e");
      return false;
    }
  }

  /// Show PIN verification dialog with back button support
  static Future<bool> _showPinVerification(
    BuildContext context,
    String title,
    String subtitle,
    AuthenticationType type,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder:
            (context) => PinVerificationScreen(
              title: title,
              subtitle: subtitle,
              showBackButton: type == AuthenticationType.sensitiveOperation,
              authenticationType: type,
              onSuccess: () {
                Navigator.of(context).pop(true);
              },
            ),
        fullscreenDialog: true,
      ),
    );

    return result ?? false;
  }

  /// Handle authentication failure based on type
  static Future<void> handleAuthenticationFailure(
    BuildContext context,
    AuthenticationType type,
  ) async {
    if (type == AuthenticationType.timeout) {
      // For timeout scenarios, logout user
      await _performLogout(context);
    } else {
      // For sensitive operations, just go back to home
      if (context.mounted) {
        context.go(Routes.home);
      }
    }
  }

  /// Perform logout for timeout scenarios
  static Future<void> _performLogout(BuildContext context) async {
    try {
      // Clear security-related data
      await _storage.delete("app_pin");
      await _storage.delete("pin_enabled");
      await _storage.delete("fingerprint_enabled");
      await _storage.delete("face_id_enabled");

      // Navigate to login screen
      if (context.mounted) {
        context.go(Routes.auth.login);

        // Show snackbar about logout
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Session expired. Please login again."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error during logout: $e");
      // Force navigation to login even if logout fails
      if (context.mounted) {
        context.go(Routes.auth.login);
      }
    }
  }

  /// Get security status description for UI
  static Future<String> getSecurityStatusDescription() async {
    final pinEnabled = await _storage.read("pin_enabled") == "true";
    final fingerprintEnabled =
        await _storage.read("fingerprint_enabled") == "true";
    final faceIdEnabled = await _storage.read("face_id_enabled") == "true";

    if (pinEnabled && (fingerprintEnabled || faceIdEnabled)) {
      return "PIN and Biometric authentication enabled";
    } else if (pinEnabled) {
      return "PIN authentication enabled";
    } else if (fingerprintEnabled || faceIdEnabled) {
      return "Biometric authentication enabled";
    } else {
      return "No security authentication enabled";
    }
  }
}
