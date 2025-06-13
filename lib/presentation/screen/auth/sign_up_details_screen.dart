import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/core/util/date_input_field.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/components/welcome_text.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class SignUpDetailsScreen extends StatelessWidget {
  final String userEmail;
  final String userPassword;
  const SignUpDetailsScreen({
    super.key,
    required this.userEmail,
    required this.userPassword,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is SignUpDetailsLoading) {
          print("🔄 Loading sign-up details...");
        }

        if (state is SignUpDetailsSuccess) {
          // print("✅ Sign-up success!");
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text("Sign up successfully"),
          //       backgroundColor: Colors.green,
          //     ),
          //   );
          // });
          context.go(Routes.auth.login);
        }

        if (state is SignUpDetailsError) {
          print("❌ Sign-up error: ${state.error}");
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          //   );
          // });
        }
      },
      builder: (context, state) {
        if (state is SignUpDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 160, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/images/CoinHub-Wordmark.png",
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  const WelcomeText(
                    title: "Sign Up Details",
                    text: "Please enter details\nfor your new account.",
                  ),
                  SignUpDetailsForm(email: userEmail, password: userPassword),
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
        );
      },
    );
  }
}

class SignUpDetailsForm extends StatefulWidget {
  final String email;
  final String password;
  const SignUpDetailsForm({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<SignUpDetailsForm> createState() => _SignUpDetailsFormState();
}

class _SignUpDetailsFormState extends State<SignUpDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late String userEmail = widget.email;
  late String userPassword = widget.password;
  late UserModel userModel;
  late String sourceId;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userModel = UserModel(
      fullName: "",
      id: "",
      avatar: "",
      birthDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      citizenId: "",
      createdAt: DateTime.now(),
    );
    sourceId = "";
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // fullname Field
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your full name";
              }
              if (RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                return null;
              } else {
                return "Please enter a valid name";
              }
            },
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your citizen ID";
              }
              if (RegExp(r"^\d{12}$").hasMatch(value)) {
                return null;
              } else {
                return "Please enter a valid citizen ID";
              }
            },
          ),
          const SizedBox(height: 16),
          // birthDay Field
          DateInputField(
            initialDate: DateTime.now(),
            isReadOnly: false,
            onDateSelected: (date) {
              if (date != null) {
                userModel.birthDate = DateFormat("yyyy-MM-dd").format(date);
              } else {
                throw Exception("Date is null");
              }
            },
          ),
          const SizedBox(height: 16),
          // address Field
          TextFormField(
            controller: _addressController,
            readOnly: false,
            onTap: () {},
            decoration: InputDecoration(
              hintText: "Enter address or use map",
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.home_outlined),
              suffixIcon: IconButton(
                icon: const Icon(Icons.location_on_outlined),
                tooltip: "Pick from map",
                onPressed: () async {
                  final result = await context.push(
                    Routes.common.locationPicker,
                  );
                  if (result != null && result is Map) {
                    //final LatLng location = result["location"];
                    final String address = result["address"];

                    setState(() {
                      _addressController.text = address;
                      userModel.address = address;
                    });
                  }
                },
              ),
            ),
            onSaved: (value) {
              userModel.address = value?.trim() ?? "";
            },
          ),

          // const SizedBox(height: 16),

          // TextFormField(
          //   onSaved: (value) {
          //     sourceId = value ?? "";
          //   },
          //   textInputAction: TextInputAction.next,
          //   keyboardType: TextInputType.number,
          //   decoration: InputDecoration(
          //     hintText: "Your first Source's ID",
          //     filled: false,
          //     border: const UnderlineInputBorder(),
          //     prefixIcon: const Icon(Icons.source_outlined),
          //   ),
          // ),
          const SizedBox(height: 32),
          // Sign Up Button
          FilledButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                context.read<UserBloc>().add(
                  SignUpDetailsSubmitted(userModel, userEmail, userPassword),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fill in all fields correctly"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },

            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Proceed", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
