import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart";
import "package:coinhub/core/util/email_validator.dart";
import "package:coinhub/presentation/components/welcome_text.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password reset link sent to your email."),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ForgotPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
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
                const WelcomeText(
                  title: "Forgot Password",
                  text:
                      "Enter your email address and we'll\nsend you a link to reset your password.",
                ),
                const ForgotPasswordForm(),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.go(Routes.auth.login);
                    }, // Navigation logic removed
                    child: const Text(
                      "Back to Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  final bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (value) {
              _email = value?.trim() ?? "";
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              if (!value.isValidEmail()) {
                return null;
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email Address",
              filled: false,
              fillColor: Theme.of(context).colorScheme.surface,
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 32),

          // Reset Password Button
          FilledButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                context.read<AuthBloc>().add(ForgotPasswordSubmitted(_email));
              }
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                _isSubmitting
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      "Reset Password",
                      style: TextStyle(fontSize: 16),
                    ),
          ),
        ],
      ),
    );
  }
}
