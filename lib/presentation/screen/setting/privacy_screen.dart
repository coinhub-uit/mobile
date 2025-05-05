import "package:coinhub/core/services/biometric_service.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:local_auth/local_auth.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:go_router/go_router.dart";
import "package:coinhub/presentation/routes/routes.dart";

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final _biometricService = BiometricService();
  // Authentication settings
  bool _fingerprintEnabled = false;
  bool _faceIdEnabled = false;
  bool _smartOtpEnabled = false;
  bool _pinEnabled = false;

  // Available biometrics
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  bool _hasFaceId = false;
  bool _hasFingerprint = false;

  // Auto-lock timeout (in minutes)
  int _autoLockTimeout = 5;
  final List<int> _timeoutOptions = [1, 5, 10, 15, 30];

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _loadSettings();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _localAuth.canCheckBiometrics;
      debugPrint("Can check biometrics: $canCheckBiometrics");
    } on PlatformException {
      canCheckBiometrics = false;
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });

    if (_canCheckBiometrics) {
      _getAvailableBiometrics();
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await _localAuth.getAvailableBiometrics();
      debugPrint("Available biometrics: $availableBiometrics");
    } on PlatformException {
      availableBiometrics = <BiometricType>[];
    }

    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
      _hasFaceId = _availableBiometrics.contains(BiometricType.face);
      _hasFingerprint = _availableBiometrics.contains(
        BiometricType.fingerprint,
      );
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fingerprintEnabled = prefs.getBool("fingerprint_enabled") ?? false;
      _faceIdEnabled = prefs.getBool("face_id_enabled") ?? false;
      _smartOtpEnabled = prefs.getBool("smart_otp_enabled") ?? false;
      _pinEnabled = prefs.getBool("pin_enabled") ?? false;
      _autoLockTimeout = prefs.getInt("auto_lock_timeout") ?? 5;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fingerprint_enabled", _fingerprintEnabled);
    await prefs.setBool("face_id_enabled", _faceIdEnabled);
    await prefs.setBool("smart_otp_enabled", _smartOtpEnabled);
    await prefs.setBool("pin_enabled", _pinEnabled);
    await prefs.setInt("auto_lock_timeout", _autoLockTimeout);
  }

  void _showPinSetupDialog() {
    context.push(Routes.account.pin);
  }

  void _showSmartOtpSetupDialog() {
    // Implementation for Smart OTP setup
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            "Smart OTP Setup",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "This would connect to your Smart OTP setup flow. Would you like to enable Smart OTP (no function now)?",
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                "Cancel",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(179),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _smartOtpEnabled = true;
                });
                _saveSettings();
                context.pop();
                _showSnackBar("Smart OTP enabled successfully");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text("Enable"),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Privacy & Security",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.privacy_tip_outlined,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Privacy Settings",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Configure your app security preferences",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(179),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Authentication Methods Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Authentication Methods",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // PIN Authentication
                    _buildSwitchTile(
                      icon: Icons.pin_outlined,
                      title: "PIN Authentication",
                      subtitle: "Secure your app with a PIN code",
                      value: _pinEnabled,
                      onChanged: (value) {
                        if (value) {
                          _showPinSetupDialog();
                        } else {
                          setState(() {
                            _pinEnabled = false;
                          });
                          _saveSettings();
                          _showSnackBar("PIN authentication disabled");
                        }
                      },
                    ),

                    const SizedBox(height: 16),
                    // Smart OTP
                    _buildSwitchTile(
                      icon: Icons.security_outlined,
                      title: "Smart OTP",
                      subtitle: "Enable one-time password for transactions",
                      value: _smartOtpEnabled,
                      onChanged: (value) {
                        if (value) {
                          _showSmartOtpSetupDialog();
                        } else {
                          setState(() {
                            _smartOtpEnabled = false;
                          });
                          _saveSettings();
                          _showSnackBar("Smart OTP disabled");
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Fingerprint Authentication
                    if (_availableBiometrics.contains(
                      BiometricType.fingerprint,
                    ))
                      _buildSwitchTile(
                        icon: Icons.fingerprint,
                        title: "Fingerprint Authentication",
                        subtitle: "Use your fingerprint to unlock the app",
                        value: _fingerprintEnabled,
                        enabled: _hasFingerprint,
                        onChanged: (value) async {
                          if (value) {
                            final authenticated = await _biometricService
                                .authenticate(
                                  reason: "Enable fingerprint authentication",
                                );
                            if (!authenticated) {
                              _showSnackBar(
                                "Fingerprint authentication failed",
                              );
                              return;
                            }
                          }

                          setState(() {
                            _fingerprintEnabled = value;
                          });
                          _saveSettings();
                          _showSnackBar(
                            value
                                ? "Fingerprint authentication enabled"
                                : "Fingerprint authentication disabled",
                          );
                        },
                      ),

                    const SizedBox(height: 16),

                    // Face ID Authentication
                    if (_availableBiometrics.contains(BiometricType.face))
                      _buildSwitchTile(
                        icon: Icons.face_outlined,
                        title: "Face ID Authentication",
                        subtitle: "Use facial recognition to unlock the app",
                        value: _faceIdEnabled,
                        enabled: _hasFaceId,
                        onChanged: (value) async {
                          if (value) {
                            final authenticated = await _biometricService
                                .authenticate(
                                  reason: "Enable Face ID authentication",
                                );
                            if (!authenticated) {
                              _showSnackBar("Face ID authentication failed :v");
                              return;
                            }
                          }

                          setState(() {
                            _faceIdEnabled = value;
                          });
                          _saveSettings();
                          _showSnackBar(
                            value
                                ? "Face ID authentication enabled"
                                : "Face ID authentication disabled",
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Auto-Lock Settings
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Auto-Lock Settings",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.timer_outlined,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Auto-Lock Timeout",
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Lock app after period of inactivity",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    153,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Timeout Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.dividerTheme.color!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _autoLockTimeout,
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: theme.colorScheme.onSurface.withAlpha(153),
                          ),
                          style: theme.textTheme.bodyLarge,
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _autoLockTimeout = newValue;
                              });
                              _saveSettings();
                              _showSnackBar("Auto-lock timeout updated");
                            }
                          },
                          items:
                              _timeoutOptions.map<DropdownMenuItem<int>>((
                                int value,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                    value == 1
                                        ? "$value minute"
                                        : "$value minutes",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Privacy Tips
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue[200]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Security Tips",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSecurityTip(
                      "Enable at least two authentication methods for better security",
                    ),
                    _buildSecurityTip(
                      "Set a shorter auto-lock timeout for sensitive information",
                    ),
                    _buildSecurityTip(
                      "Use Smart OTP for all financial transactions",
                    ),
                    _buildSecurityTip(
                      "Regularly update your PIN for enhanced security",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    bool enabled = true,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: AbsorbPointer(
        absorbing: !enabled,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.primaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: theme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTip(String tip) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.blue[700], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(204),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
