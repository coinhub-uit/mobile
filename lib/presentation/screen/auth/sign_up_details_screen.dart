import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart";
import "package:coinhub/core/util/date_input_field.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/components/welcome_text.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SignUpDetailsScreen extends StatelessWidget {
  const SignUpDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignUpWithEmailInitial) {}
      },

      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 160, 16, 0),
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
                  title: "Sign Up Details",
                  text: "Please enter details\nfor your new account.",
                ),
                const SignUpDetailsForm(),
                const SizedBox(height: 16),
                Center(child: Text("Or", style: TextStyle())),
                const SizedBox(height: 16 * 1.5),

                Center(
                  child: Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      text: "Already have an account? ",
                      children: <TextSpan>[
                        TextSpan(
                          text: "Sign in!",
                          style: const TextStyle(fontWeight: FontWeight.w900),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  context.read<AuthBloc>().add(ShowLogin());
                                },
                        ),
                      ],
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

class SignUpDetailsForm extends StatefulWidget {
  const SignUpDetailsForm({super.key});

  @override
  State<SignUpDetailsForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late UserModel userModel;
  DateTime? dob = DateTime.now();

  @override
  void initState() {
    super.initState();
    userModel = UserModel(
      fullName: "",
      phoneNumber: "",
      id: "",
      birthDay: DateTime.now(),
      citizenId: "",
      createdAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // fullName Field
          TextFormField(
            onSaved: (value) {
              userModel.fullName = value?.trim() ?? "";
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Full Name",
              filled: false,
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          // citizenId Field
          TextFormField(
            onSaved: (value) {
              userModel.citizenId = value ?? "";
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Citizen ID",
              filled: false,
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 16),
          // birthDay Field
          DateInputField(
            onDateSelected: (date) {
              if (date != null) {
                userModel.birthDay = date;
              } else {
                throw Exception("Date is null");
              }
            },
          ),
          const SizedBox(height: 16),
          // address Field
          TextFormField(
            onSaved: (value) {
              userModel.address = value ?? "";
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: "Address",
              filled: false,
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 16),
          // phoneNumber Field
          TextFormField(
            onSaved: (value) {
              userModel.phoneNumber = value ?? "";
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Phone Number",
              filled: false,
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 32),

          // Sign Up Button
          FilledButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // if (_password != _confirmPassword) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text("Passwords do not match"),
                //       backgroundColor: Colors.red,
                //     ),
                //   );
                //   return;
                // }
                // // Handle sign-up logic here
                // context.read<AuthBloc>().add(
                //   SignUpWithEmailSubmitted(_email, _password),
                // );
              }
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Create Account", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
