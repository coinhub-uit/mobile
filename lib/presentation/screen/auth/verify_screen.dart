import "dart:async";
import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class VerifyScreen extends StatefulWidget {
  final String userEmail;
  const VerifyScreen({super.key, required this.userEmail});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  int _resendTimer = 0;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckIfVerified());
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() => _resendTimer = 30);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ResendVerificationSuccess) _startResendTimer();
          if (state is Verified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "You have successfully verified your email. Returning to login scren...",
                ),
                backgroundColor: Colors.green,
              ),
            );
            context.go(Routes.auth.login);
          } else if (state is NotVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please verify your email first."),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CheckingIfVerified) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildVerificationUI(state);
        },
      ),
    );
  }

  Widget _buildVerificationUI(AuthState state) {
    final isResending = state is ResendingVerification;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/CoinHub-Character.png", width: 150),
          const SizedBox(height: 24),
          Text(
            "Verify Your Email",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "We've sent a verification link to your email. Click the link to verify.",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _resendTimer > 0
              ? Text(
                "Resend code in $_resendTimer seconds",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
              : ElevatedButton(
                onPressed:
                    isResending
                        ? null
                        : () {
                          context.read<AuthBloc>().add(
                            ResendVerification(widget.userEmail),
                          );
                        },
                child:
                    isResending
                        ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                        : const Text(
                          "Resend Code",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
              ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(CheckIfVerified());
            },
            child: const Text(
              "Proceed to Login",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
