import "dart:async";

import "package:flutter/material.dart";
import "package:pinput/pinput.dart";

class VerifyScreen extends StatefulWidget {
  final String email;
  final VerificationType type;

  const VerifyScreen({
    super.key,
    required this.email,
    this.type = VerificationType.email,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

enum VerificationType { email, phone }

class _VerifyScreenState extends State<VerifyScreen> {
  final codeController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _isResending = false;
  int _resendTimer = 0;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 30;
    });

    // Use a periodic timer instead of recursive delayed calls
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        // Cancel the timer when done or if widget is unmounted
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {}, // Removed navigation logic
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Image.asset("assets/images/CoinHub-Wordmark.png"),
                  ),
                  Expanded(child: Container()),
                ],
              ),
              WelcomeText(
                title: "Verification",
                text:
                    widget.type == VerificationType.email
                        ? "We've sent a verification code to\n${widget.email}"
                        : "We've sent a verification code to\nyour phone",
              ),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Center(
                  child: Pinput(
                    controller: codeController,
                    focusNode: focusNode,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    showCursor: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return "Please enter the 6-digit verification code";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child:
                    _resendTimer > 0
                        ? Text(
                          "Resend code in $_resendTimer seconds",
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )
                        : TextButton(
                          onPressed: _isResending ? null : _resendCode,
                          child:
                              _isResending
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    "Resend Code",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Verification logic removed
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Verify", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resendCode() {
    setState(() {
      _isResending = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isResending = false;
          _startResendTimer();
        });
      }
    });
  }
}

/// This screen was initially using Bloc for authentication state management.
/// - BlocListener handled success and error states from the authentication flow.
/// - Navigation logic was used to transition users based on verification success.
/// - Removed navigation, Bloc, and authentication logic for a UI-only version.

class WelcomeText extends StatelessWidget {
  final String title, text;

  const WelcomeText({super.key, required this.title, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(color: Color(0xFF868686))),
        const SizedBox(height: 24),
      ],
    );
  }
}
