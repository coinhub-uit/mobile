import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart" as auth_state;
import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/core/services/user_service.dart";
import "package:coinhub/core/util/date_input_field.dart";
import "package:coinhub/models/user_model.dart";
import "package:flutter/material.dart";
import "package:coinhub/core/services/auth_service.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:coinhub/presentation/components/purple_card.dart";
import "package:coinhub/presentation/components/yellow_card.dart";
import "package:coinhub/presentation/components/header_container.dart";
import "package:coinhub/presentation/components/home_app_bar.dart";
import "package:coinhub/presentation/components/fixed_deposit_card.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

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
        onUserUpdated: (updatedUser) {
          setState(() {
            userModel = updatedUser;
          });
        },
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

  Future<UserModel?> getUserModel(String id) async {
    return await UserService.getUser(id)
        .then((value) {
          return value;
        })
        .catchError((error) {
          debugPrint("Error: $error");
          return Future.value(
            UserModel(
              id: "This is a placeholder.",
              citizenId: "This is a placeholder.",
              fullname: "This is a placeholder.",
              birthDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    AuthService.authStateChanges.listen((data) async {
      final id = data.session?.user.id;
      final email = data.session?.user.email;

      if (email != null) {
        setState(() {
          userEmail = email;
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

class ProfileScreen extends StatefulWidget {
  final UserModel model;
  final String userEmail;
  final Function(UserModel) onUserUpdated;
  const ProfileScreen({
    super.key,
    required this.model,
    required this.userEmail,
    required this.onUserUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> confirmAndDelete(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
    if (result == true) {
      BlocProvider.of<UserBloc>(
        // ignore: use_build_context_synchronously
        context,
      ).add(DeleteAccountRequested(widget.model.id));
      await AuthService.signOut();
      // context.go(Routes.Auth.login); // in listener
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        userName: widget.model.fullname.trim().split(" ").last,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UpdateAvatarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is UpdateAvatarSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Avatar updated successfully"),
                backgroundColor: Colors.green,
              ),
            );
            widget.model.avatar = state.avatarUrl;
          } else if (state is DeleteAccountError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is DeleteAccountSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Account deleted successfully"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
            Future.delayed(const Duration(seconds: 1));
            context.go(Routes.auth.login);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 64.0, bottom: 32.0),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    BlocProvider.of<UserBloc>(
                      context,
                    ).add(UpdateAvatarSubmitted(widget.model.id));
                  },
                  child: CircleAvatar(
                    radius: 84,
                    backgroundImage:
                        (widget.model.avatar != null &&
                                widget.model.avatar!.isNotEmpty)
                            ? NetworkImage(
                              "${widget.model.avatar!}?t=${DateTime.now().millisecondsSinceEpoch}",
                            )
                            : const AssetImage("assets/images/CoinHub.png")
                                as ImageProvider,
                  ),
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
                      child: UpdatePrivacyForm(email: widget.userEmail),
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
                      child: UpdateDetailsForm(
                        userModel: widget.model,
                        onUserUpdated: (updatedUser) {
                          widget.onUserUpdated(updatedUser);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        bottom: 8,
                        top: 16,
                      ),
                      child: const Text(
                        "Danger Zone",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: FilledButton(
                        onPressed: () => confirmAndDelete(context),
                        style: FilledButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width - 48,
                            48,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdatePrivacyForm extends StatefulWidget {
  final String email;
  const UpdatePrivacyForm({super.key, required this.email});

  @override
  State<UpdatePrivacyForm> createState() => _UpdatePrivacyFormState();
}

class _UpdatePrivacyFormState extends State<UpdatePrivacyForm> {
  final _formKey = GlobalKey<FormState>();
  bool isObscureOldPassword = true;
  bool isObscureNewPassword = true;
  bool isEditing = false;
  String userOldPassword = "";
  String userNewPassword = "";
  late TextEditingController newPasswordController;
  late TextEditingController oldPasswordController;

  @override
  void initState() {
    super.initState();
    newPasswordController = TextEditingController(text: userNewPassword);
    oldPasswordController = TextEditingController(text: userOldPassword);
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, auth_state.AuthState>(
      listener: (context, state) {
        if (state is auth_state.UpdatePasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is auth_state.UpdatePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // email Field
            TextFormField(
              readOnly: true,
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
            // old password Field
            TextFormField(
              obscureText: isObscureOldPassword,
              readOnly: !isEditing,
              controller: oldPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your old password!";
                }

                return null;
              },
              onSaved: (value) {
                userOldPassword = value ?? "";
              },
              decoration: InputDecoration(
                hintText: "Old Password",
                filled: false,
                border: const UnderlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscureOldPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed:
                      isEditing
                          ? () {
                            setState(() {
                              isObscureOldPassword = !isObscureOldPassword;
                            });
                          }
                          : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // new password Field
            TextFormField(
              obscureText: isObscureNewPassword,
              readOnly: !isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your new password!";
                }
                if (value.length < 6) {
                  return "Password must be at least 6 characters long!";
                }
                if (value == oldPasswordController.text) {
                  return "New password must be different from old password!";
                }
                return null;
              },
              controller: newPasswordController,
              onSaved: (value) {
                userNewPassword = value ?? "";
              },
              decoration: InputDecoration(
                hintText: "New Password",
                filled: false,
                border: const UnderlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscureNewPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed:
                      isEditing
                          ? () {
                            setState(() {
                              isObscureNewPassword = !isObscureNewPassword;
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

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                isEditing = !isEditing;
                              });
                              BlocProvider.of<AuthBloc>(context).add(
                                UpdatePasswordSubmitted(
                                  widget.email,
                                  userOldPassword, // old password
                                  userNewPassword, // new password
                                ),
                              );
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
                            oldPasswordController.clear();
                            newPasswordController.clear();
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
      ),
    );
  }
}

class UpdateDetailsForm extends StatefulWidget {
  final UserModel userModel;
  final Function(UserModel) onUserUpdated;
  const UpdateDetailsForm({
    super.key,
    required this.userModel,
    required this.onUserUpdated,
  });

  @override
  State<UpdateDetailsForm> createState() => _UpdateDetailsFormState();
}

class _UpdateDetailsFormState extends State<UpdateDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  late UserModel newUserModel;
  TextEditingController? controllerFullName;
  TextEditingController? controllerCitizenId;
  TextEditingController? controllerAddress;

  @override
  void initState() {
    super.initState();
    newUserModel = widget.userModel;
    controllerFullName = TextEditingController(text: widget.userModel.fullname);
    controllerCitizenId = TextEditingController(
      text: widget.userModel.citizenId,
    );
    controllerAddress = TextEditingController(text: widget.userModel.address);
  }

  @override
  void dispose() {
    controllerFullName?.dispose();
    controllerCitizenId?.dispose();
    controllerAddress?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UpdateDetailsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is UpdateDetailsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User details updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // fullname Field
            TextFormField(
              readOnly: !isEditing,
              onSaved: (value) {
                newUserModel.fullname = value?.trim() ?? "";
              },
              controller: controllerFullName,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
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
              controller: controllerCitizenId,
              onSaved: (value) {
                newUserModel.citizenId = value ?? "";
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
              isReadOnly: !isEditing,
              initialDate: DateTime.parse(widget.userModel.birthDate),
              onDateSelected: (date) {
                if (date != null) {
                  newUserModel.birthDate = DateFormat(
                    "yyyy-MM-dd",
                  ).format(date);
                }
              },
            ),
            const SizedBox(height: 16),
            // address Field
            TextFormField(
              readOnly: !isEditing,
              onSaved: (value) {
                newUserModel.address = value ?? "";
              },
              controller: controllerAddress,
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
                              BlocProvider.of<UserBloc>(
                                context,
                              ).add(UpdateDetailsSubmitted(newUserModel));
                              widget.onUserUpdated(newUserModel);
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
