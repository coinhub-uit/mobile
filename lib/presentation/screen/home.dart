import "package:coinhub/core/services/user_service.dart";
import "package:coinhub/core/util/date_input_field.dart";
import "package:coinhub/models/user_model.dart";
import "package:flutter/material.dart";
import "package:coinhub/core/services/auth_service.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:coinhub/presentation/components/purple_card.dart";
import "package:coinhub/presentation/components/yellow_card.dart";
import "package:coinhub/presentation/components/header_container.dart";
import "package:coinhub/presentation/components/home_app_bar.dart";
import "package:coinhub/presentation/components/fixed_deposit_card.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:go_router/go_router.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = "temporaryId";
  int _selectedIndex = 0;
  UserModel? userModel;
  String? userEmail;
  String? userPassword;
  bool get isUserLoaded => userModel?.id != "temporaryId";

  // final List<Widget> _screens = [
  //   HomeScreenContent(model: userModel),
  //   SavingsScreen(),
  //   ProfileScreen(),
  // ];
  List<Widget> get _screens => [
    if (userModel != null) ...[
      HomeScreenContent(model: userModel!),
      SavingsScreen(model: userModel!),
      ProfileScreen(
        model: userModel!,
        userEmail: userEmail!,
        userPassword: userPassword!,
      ),
    ] else ...[
      const Center(child: CircularProgressIndicator()),
    ],
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<UserModel> getUserModel(String id) async {
    return await UserService.getUser(id)
        .then((value) {
          return value;
        })
        .catchError((error) {
          debugPrint("Error: $error");
          return UserModel(
            id: "This is a placeholder.",
            citizenId: "This is a placeholder.",
            fullname: "This is a placeholder.",
            birthDate: DateTime.now().toUtc().toIso8601String(),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    AuthService.authStateChanges.listen((data) async {
      final id = data.session?.user.id;
      final email = data.session?.user.email;
      final password =
          data.session?.accessToken; // fake password for showing only
      print(password);
      print(email);
      if (email != null) {
        setState(() {
          userEmail = email;
        });
      }
      if (password != null) {
        setState(() {
          userPassword = password;
        });
      }

      if (id != null) {
        setState(() {
          userId = id;
        });

        final model = await getUserModel(id);
        setState(() {
          userModel = model;
        });
      } else {
        debugPrint("User not logged in.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserLoaded) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          onItemTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wallet),
            label: "Savings",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.imagePortrait),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// home screen content
class HomeScreenContent extends StatelessWidget {
  final UserModel model;
  const HomeScreenContent({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        userName: model.fullname.trim().split(" ").last,
        imgUrl: model.avatar ?? "",
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              HeaderContainer(topLabel: "Balance:", bottomLabel: "21.987.000đ"),
              SizedBox(height: 2),
              Row(
                children: [
                  YellowCard(label: "+5.5%"),
                  SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: GestureDetector(
                        onTap:
                            () => {context.push(Routes.transaction.transfer)},
                        child: PurpleCard(
                          icon: Icons.money,
                          label: "Transfer",
                          iconSize: 16,
                          labelSize: 16,
                          arrowSize: 16,
                          paddingTop: 6,
                          paddingBottom: 6,
                          paddingLeft: 16,
                          paddingRight: 16,
                          isTransferButton: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: GestureDetector(
                      onTap: () {},
                      child: PurpleCard(
                        icon: FontAwesomeIcons.piggyBank,
                        label: "Add new\nSaving plan",
                        iconSize: 56,
                        arrowSize: 64,
                        labelSize: 36,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          height: 180,
                          child: GestureDetector(
                            onTap: () {
                              context.push(Routes.transaction.deposit);
                            },
                            child: PurpleCard(
                              icon: FontAwesomeIcons.arrowDown,
                              label: "Deposit",
                              iconSize: 48,
                              arrowSize: 56,
                              labelSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          height: 180,
                          child: GestureDetector(
                            onTap: () {
                              context.push(Routes.transaction.withdraw);
                            },
                            child: PurpleCard(
                              icon: FontAwesomeIcons.arrowUpFromBracket,
                              label: "Withdraw",
                              iconSize: 48,
                              arrowSize: 56,
                              labelSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// savings screen
class SavingsScreen extends StatelessWidget {
  final UserModel model;
  const SavingsScreen({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        userName: model.fullname.trim().split(" ").last,
        imgUrl: model.avatar ?? "",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            HeaderContainer(topLabel: "Savings:", bottomLabel: "21.987.000đ"),
            SizedBox(height: 2),
            YellowCard(label: "+123.000đ"),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return FixedDepositCard(
                    index: index + 1,
                    moneyInit: 1234000,
                    profit: 30000,
                    profitPercentage: 5.5,
                    startDate: "1/1/2025",
                    endDate: "1/6/2025",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final UserModel model;
  final String userEmail;
  final String userPassword;
  const ProfileScreen({
    super.key,
    required this.model,
    required this.userEmail,
    required this.userPassword,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(userName: model.fullname.trim().split(" ").last),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 64.0, bottom: 32.0),
            child: Center(
              child: CircleAvatar(
                radius: 84,
                backgroundImage:
                    model.avatar!.isNotEmpty
                        ? NetworkImage(model.avatar!)
                        : AssetImage("assets/images/CoinHub.png")
                            as ImageProvider,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, bottom: 8),
                    child: const Text(
                      "Account Privacy",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: UpdatePrivacyForm(
                      email: userEmail,
                      password: userPassword,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      top: 16.0,
                      bottom: 8,
                    ),
                    child: const Text(
                      "Account Details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: UpdateDetailsForm(userModel: model),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatePrivacyForm extends StatefulWidget {
  final String email;
  final String password;
  const UpdatePrivacyForm({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<UpdatePrivacyForm> createState() => _UpdatePrivacyFormState();
}

class _UpdatePrivacyFormState extends State<UpdatePrivacyForm> {
  final _formKey = GlobalKey<FormState>();
  bool isObscurePassword = true;
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // email Field
          TextFormField(
            readOnly: !isEditing,
            onSaved: (value) {
              //_email = value?.trim() ?? "";
            },
            controller: TextEditingController(text: widget.email),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email Address",
              filled: false,
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 16),
          // citizenId Field
          TextFormField(
            obscureText: isObscurePassword,
            readOnly: !isEditing,
            controller: TextEditingController(text: widget.password),
            onSaved: (value) {
              //_password = value ?? "";
            },
            decoration: InputDecoration(
              hintText: "Password",
              filled: false,
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  isObscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed:
                    isEditing
                        ? () {
                          setState(() {
                            isObscurePassword = !isObscurePassword;
                          });
                        }
                        : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed:
                    isEditing
                        ? () async {
                          // handle toggle back
                          setState(() {
                            isEditing = !isEditing;
                          });
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            //print(userModel.toJson());
                            // context.read<UserBloc>().add(
                            //   SignUpDetailsSubmitted(userModel, userEmail, userPassword),
                            // );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please fill in all fields correctly",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                        : null,
                style: FilledButton.styleFrom(
                  minimumSize: Size(
                    MediaQuery.of(context).size.width / 2 - 48,
                    48,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("Save", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed:
                    !isEditing
                        ? () async {
                          // handle toggle back
                          setState(() {
                            isEditing = !isEditing;
                          });
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            //print(userModel.toJson());
                            // context.read<UserBloc>().add(
                            //   SignUpDetailsSubmitted(userModel, userEmail, userPassword),
                            // );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please fill in all fields correctly",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                        : null,
                style: FilledButton.styleFrom(
                  minimumSize: Size(
                    MediaQuery.of(context).size.width / 2 - 48,
                    48,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                child: const Text("Change", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),

          // Sign Up Button
        ],
      ),
    );
  }
}

class UpdateDetailsForm extends StatefulWidget {
  final UserModel userModel;
  const UpdateDetailsForm({super.key, required this.userModel});

  @override
  State<UpdateDetailsForm> createState() => _UpdateDetailsFormState();
}

class _UpdateDetailsFormState extends State<UpdateDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // fullname Field
          TextFormField(
            readOnly: !isEditing,
            onSaved: (value) {
              //userModel.fullname = value?.trim() ?? "";
            },
            controller: TextEditingController(text: widget.userModel.fullname),
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
            readOnly: !isEditing,
            controller: TextEditingController(text: widget.userModel.citizenId),
            onSaved: (value) {
              //userModel.citizenId = value ?? "";
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
            // TODO: make it read only!!!!!!!!!!!!!!!!!

            // onDateSelected: (date) {
            //   if (date != null) {
            //     //userModel.birthDate = date.toUtc().toIso8601String();
            //   } else {
            //     throw Exception("Date is null");
            //   }
            // },
            onDateSelected: (date) {
              if (date != null) {
                date = DateTime.parse(widget.userModel.birthDate);
              }
            },
          ),
          const SizedBox(height: 16),
          // address Field
          TextFormField(
            readOnly: !isEditing,
            onSaved: (value) {
              //userModel.address = value ?? "";
            },
            controller: TextEditingController(text: widget.userModel.address),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: "Address",
              filled: false,
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 8),

          // account details Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed:
                    isEditing
                        ? () async {
                          // handle toggle back
                          setState(() {
                            isEditing = !isEditing;
                          });
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            //print(userModel.toJson());
                            // context.read<UserBloc>().add(
                            //   SignUpDetailsSubmitted(userModel, userEmail, userPassword),
                            // );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please fill in all fields correctly",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                        : null,
                style: FilledButton.styleFrom(
                  minimumSize: Size(
                    MediaQuery.of(context).size.width / 2 - 48,
                    48,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("Save", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed:
                    !isEditing
                        ? () async {
                          // handle toggle back
                          setState(() {
                            isEditing = !isEditing;
                          });
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            //print(userModel.toJson());
                            // context.read<UserBloc>().add(
                            //   SignUpDetailsSubmitted(userModel, userEmail, userPassword),
                            // );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please fill in all fields correctly",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                        : null,
                style: FilledButton.styleFrom(
                  minimumSize: Size(
                    MediaQuery.of(context).size.width / 2 - 48,
                    48,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                child: const Text("Change", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Container(
//   constraints: BoxConstraints.expand(height: 100),
//   padding: EdgeInsets.symmetric(horizontal: 30),
//   child: Transform.translate(
//     offset: Offset(0, -10),
//     child:
//   ),
// ),
// Text(placeholderText, style: TextStyle(fontSize: 20)),
// SizedBox(height: 20),
// ElevatedButton(
//   onPressed: () async {
//     try {
//       await AuthService.signInWithGoogle();
//     } catch (e) {
//       debugPrint("Sign in failed: $e");
//     }
//   },
//   child: Text("Sign in with google"),
// ),
