import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:coinhub/core/services/local_storage.dart";
import "package:coinhub/core/services/security_service.dart";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart";
import "package:go_router/go_router.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PinVerificationScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  final String title;
  final String subtitle;
  final bool showBackButton;
  final AuthenticationType authenticationType;

  const PinVerificationScreen({
    super.key,
    this.onSuccess,
    this.title = "Enter PIN",
    this.subtitle = "Please enter your PIN to continue",
    this.showBackButton = false,
    this.authenticationType = AuthenticationType.timeout,
  });

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final LocalStorageService _storage = LocalStorageService();

  String _errorText = "";
  bool _isLoading = false;
  int _attemptCount = 0;
  static const int _maxAttempts = 3;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Auto focus PIN field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _verifyPin() async {
    if (_isLoading) return;

    final enteredPin = _pinController.text;

    if (enteredPin.isEmpty) {
      _showError("Please enter your PIN");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = "";
    });

    try {
      // Get stored PIN from secure storage
      final storedPin = await _storage.read("app_pin");

      if (storedPin == null) {
        _showError("No PIN found. Please set up your PIN in settings.");
        return;
      }

      if (enteredPin == storedPin) {
        // Success - reset attempt count
        _attemptCount = 0;
        HapticFeedback.lightImpact();
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        } else {
          if (mounted) context.pop(true);
        }
      } else {
        // Wrong PIN
        _attemptCount++;
        HapticFeedback.mediumImpact();
        _shakeController.forward().then((_) {
          _shakeController.reset();
        });

        if (_attemptCount >= _maxAttempts) {
          // Too many failed attempts - handle based on authentication type
          await _handleMaxAttemptsReached();
        } else {
          _showError(
            "Incorrect PIN. ${_maxAttempts - _attemptCount} attempts remaining.",
          );
        }
        _pinController.clear();
      }
    } catch (e) {
      _showError("An error occurred. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleMaxAttemptsReached() async {
    try {
      _showError("Too many failed attempts.");

      // Wait a moment for user to see the message
      await Future.delayed(const Duration(seconds: 2));

      if (widget.authenticationType == AuthenticationType.timeout) {
        // For timeout scenarios, log out user
        if (mounted) {
          context.read<AuthBloc>().add(const LogoutEvent());

          // Clear security-related data
          await _storage.delete("app_pin");
          await _storage.delete("pin_enabled");
          await _storage.delete("fingerprint_enabled");
          await _storage.delete("face_id_enabled");

          // Navigate to login screen
          context.go(Routes.auth.login);

          // Show snackbar about logout
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logged out due to too many failed PIN attempts"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        // For sensitive operations, just go back to home
        if (mounted) {
          context.go(Routes.home);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Authentication failed. Returning to home."),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error handling max attempts: $e");
      // Force navigation based on type
      if (mounted) {
        if (widget.authenticationType == AuthenticationType.timeout) {
          context.go(Routes.auth.login);
        } else {
          context.go(Routes.home);
        }
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _errorText = message;
    });
  }

  void _onPinChanged(String value) {
    if (_errorText.isNotEmpty) {
      setState(() {
        _errorText = "";
      });
    }

    // Auto-verify when PIN length reaches 4-6 digits
    if (value.length >= 4 && value.length <= 6) {
      _verifyPin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

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
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                )
                : null,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: mediaQuery.size.height - mediaQuery.padding.top,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon/Logo area
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // CoinHub Logo
                        Image.asset(
                          "assets/images/CoinHub.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        // Lock Icon
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                blurRadius: 6,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            size: 20,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title and subtitle
                  Text(
                    widget.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.subtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(179),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // PIN input with shake animation
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _shakeAnimation.value *
                              ((_shakeAnimation.value < 0.5) ? -10 : 10),
                          0,
                        ),
                        child: child,
                      );
                    },
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: TextField(
                          controller: _pinController,
                          focusNode: _pinFocusNode,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          enabled: !_isLoading,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: theme.textTheme.headlineSmall?.copyWith(
                            letterSpacing: 8.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: "••••",
                            hintStyle: theme.textTheme.headlineSmall?.copyWith(
                              letterSpacing: 8.0,
                              color: theme.colorScheme.onSurface.withAlpha(102),
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            counterText: "",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color:
                                    _errorText.isNotEmpty
                                        ? Colors.red
                                        : (theme.dividerTheme.color ??
                                            Colors.grey),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color:
                                    _errorText.isNotEmpty
                                        ? Colors.red
                                        : theme.primaryColor,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                          ),
                          onChanged: _onPinChanged,
                          onSubmitted: (_) => _verifyPin(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Error message
                  if (_errorText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _attemptCount >= _maxAttempts
                                ? Icons.logout
                                : Icons.error_outline,
                            color: Colors.red[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _errorText,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Attempt counter display
                  if (_attemptCount > 0 && _attemptCount < _maxAttempts)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Text(
                        "Attempt $_attemptCount of $_maxAttempts",
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Loading indicator
                  if (_isLoading)
                    Column(
                      children: [
                        CircularProgressIndicator(color: theme.primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          _attemptCount >= _maxAttempts
                              ? "Logging out..."
                              : "Verifying...",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(179),
                          ),
                        ),
                      ],
                    ),

                  const Spacer(),

                  // Manual verify button (optional)
                  if (!_isLoading &&
                      _pinController.text.isNotEmpty &&
                      _attemptCount < _maxAttempts)
                    ElevatedButton(
                      onPressed: _verifyPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Verify PIN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
