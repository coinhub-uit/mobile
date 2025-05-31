import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:coinhub/core/services/biometric_service.dart";
import "package:coinhub/core/services/local_storage.dart";
import "package:coinhub/core/services/timeout_service.dart";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart";
import "package:coinhub/presentation/screen/auth/pin_verification_screen.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:go_router/go_router.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class UnlockScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  final bool showBackButton;

  const UnlockScreen({super.key, this.onSuccess, this.showBackButton = false});

  @override
  State<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends State<UnlockScreen>
    with TickerProviderStateMixin {
  final LocalStorageService _storage = LocalStorageService();
  final BiometricService _biometricService = BiometricService();
  final TimeoutService _timeoutService = TimeoutService();

  bool _pinEnabled = false;
  bool _biometricEnabled = false;
  bool _isLoading = true;
  bool _showPinEntry = false;
  int _biometricAttempts = 0;
  static const int _maxBiometricAttempts = 5;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadAuthSettings();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _loadAuthSettings() async {
    try {
      final pinEnabled = await _storage.read("pin_enabled") == "true";
      final fingerprintEnabled =
          await _storage.read("fingerprint_enabled") == "true";
      final faceIdEnabled = await _storage.read("face_id_enabled") == "true";

      setState(() {
        _pinEnabled = pinEnabled;
        _biometricEnabled = fingerprintEnabled || faceIdEnabled;
        _isLoading = false;
      });

      // Auto-attempt biometric authentication if enabled
      if (_biometricEnabled && !_showPinEntry) {
        _attemptBiometricAuth();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _attemptBiometricAuth() async {
    try {
      final authenticated = await _biometricService.authenticate(
        reason: "Unlock CoinHub to continue",
      );

      if (authenticated) {
        _onAuthSuccess();
      } else {
        // Biometric failed
        _biometricAttempts++;
        if (_biometricAttempts >= _maxBiometricAttempts) {
          await _logoutUser();
        } else if (_pinEnabled) {
          setState(() {
            _showPinEntry = true;
          });
        }
      }
    } catch (e) {
      _biometricAttempts++;
      if (_biometricAttempts >= _maxBiometricAttempts) {
        await _logoutUser();
      } else if (_pinEnabled) {
        setState(() {
          _showPinEntry = true;
        });
      }
    }
  }

  Future<void> _logoutUser() async {
    try {
      // Show logout message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Too many failed attempts. Logging out for security."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      // Wait a moment
      await Future.delayed(const Duration(seconds: 1));

      // Use AuthBloc to logout properly
      if (mounted) {
        context.read<AuthBloc>().add(const LogoutEvent());

        // Clear security-related data
        await _storage.delete("app_pin");
        await _storage.delete("pin_enabled");
        await _storage.delete("fingerprint_enabled");
        await _storage.delete("face_id_enabled");

        // Navigate to login screen
        context.go(Routes.auth.login);
      }
    } catch (e) {
      debugPrint("Error during logout: $e");
      // Force navigation to login even if logout fails
      if (mounted) {
        context.go(Routes.auth.login);
      }
    }
  }

  void _onAuthSuccess() {
    HapticFeedback.lightImpact();
    _timeoutService.unlock();
    if (widget.onSuccess != null) {
      widget.onSuccess!();
    }
  }

  void _showPinVerification() {
    setState(() {
      _showPinEntry = true;
    });
  }

  Future<void> _onPinSuccess() async {
    _onAuthSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_showPinEntry) {
      return PinVerificationScreen(
        title: "Unlock CoinHub",
        subtitle: "Enter your PIN to unlock the app",
        onSuccess: _onPinSuccess,
      );
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginInitial) {
          // Successfully logged out
          context.go(Routes.auth.login);
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar:
            widget.showBackButton
                ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
                )
                : null,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                height: mediaQuery.size.height,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo/Icon
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          // CoinHub Logo
                          Image.asset(
                            "assets/images/CoinHub.png",
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          // Lock Icon overlay
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              size: 24,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title
                    Text(
                      "CoinHub Locked",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      "Authenticate to continue using the app",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(179),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 64),

                    // Authentication options
                    Column(
                      children: [
                        // Biometric authentication button
                        if (_biometricEnabled &&
                            _biometricAttempts < _maxBiometricAttempts)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ElevatedButton.icon(
                              onPressed: _attemptBiometricAuth,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.fingerprint, size: 24),
                              label: Text(
                                _getBiometricButtonText(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        // PIN authentication button
                        if (_pinEnabled)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _showPinVerification,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.primaryColor,
                                minimumSize: const Size(double.infinity, 56),
                                side: BorderSide(
                                  color: theme.primaryColor,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.pin_outlined, size: 24),
                              label: const Text(
                                "Use PIN",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        // Show warning if biometric attempts are exhausted
                        if (_biometricEnabled &&
                            _biometricAttempts >= _maxBiometricAttempts)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  color: Colors.red[700],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Biometric authentication disabled due to too many failed attempts",
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // No authentication methods available
                        if (!_pinEnabled && !_biometricEnabled)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.orange[200]!),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.warning_outlined,
                                  color: Colors.orange[700],
                                  size: 32,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "No Authentication Method",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Please set up PIN or biometric authentication in settings to secure your app.",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.orange[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed:
                                      _onAuthSuccess, // Allow bypass for now
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange[600],
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("Continue"),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // Footer info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (theme.dividerTheme.color ?? Colors.grey)
                              .withAlpha(128),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: theme.colorScheme.onSurface.withAlpha(179),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Your app is locked for security",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(179),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getBiometricButtonText() {
    // This could be enhanced to detect specific biometric types
    return "Use Biometric";
  }
}
