import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:go_router/go_router.dart";

class AccountDetailsScreen extends StatefulWidget {
  final UserModel userModel;
  final Function(UserModel) onUserUpdated;
  const AccountDetailsScreen({
    super.key,
    required this.userModel,
    required this.onUserUpdated,
  });

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserModel newUserModel;
  late TextEditingController controllerFullName;
  late TextEditingController controllerCitizenId;
  late TextEditingController controllerAddress;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    newUserModel = widget.userModel;
    controllerFullName = TextEditingController(text: widget.userModel.fullName);
    controllerCitizenId = TextEditingController(
      text: widget.userModel.citizenId,
    );
    controllerAddress = TextEditingController(text: widget.userModel.address);
    selectedDate = DateTime.parse(widget.userModel.birthDate);
  }

  @override
  void dispose() {
    controllerFullName.dispose();
    controllerCitizenId.dispose();
    controllerAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Account Details",
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
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UpdateDetailsError) {
            _showSnackBar(context, state.error, isError: true);
          } else if (state is UpdateDetailsSuccess) {
            _showSnackBar(context, "User details updated successfully");
            // ignore: use_build_context_synchronously
            Future.delayed(const Duration(seconds: 1), () {
              context.pop();
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account Details Header
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
                          Icons.person_outline,
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
                              "Personal Information",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Update your personal details",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha(
                                  179,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Account Details Form
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name Field
                        _buildTextField(
                          controller: controllerFullName,
                          label: "Full Name",
                          icon: Icons.person_outline,
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
                          onSaved: (value) {
                            newUserModel.fullName = value?.trim() ?? "";
                          },
                        ),

                        const SizedBox(height: 20),

                        // Citizen ID Field
                        _buildTextField(
                          controller: controllerCitizenId,
                          label: "Citizen ID",
                          icon: Icons.badge_outlined,
                          keyboardType: TextInputType.number,
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
                          onSaved: (value) {
                            newUserModel.citizenId = value ?? "";
                          },
                        ),

                        const SizedBox(height: 20),

                        // Birth Date Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Birth Date",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: theme.primaryColor,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null && picked != selectedDate) {
                                  setState(() {
                                    selectedDate = picked;
                                    newUserModel.birthDate = DateFormat(
                                      "yyyy-MM-dd",
                                    ).format(picked);
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.dividerTheme.color!,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: theme.primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      selectedDate != null
                                          ? DateFormat(
                                            "MMMM d, yyyy",
                                          ).format(selectedDate!)
                                          : "Select date",
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(153),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Address Field
                        _buildTextField(
                          controller: controllerAddress,
                          label: "Address",
                          icon: Icons.home_outlined,
                          readOnly: false, // allow typing
                          onSaved: (value) {
                            newUserModel.address = value ?? "";
                          },
                          onMapPick: () async {
                            final result = await context.push(
                              Routes.common.locationPicker,
                            );
                            if (result != null && result is Map) {
                              final String address = result["address"];
                              setState(() {
                                controllerAddress.text = address;
                                newUserModel.address = address;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        // Update Details Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                BlocProvider.of<UserBloc>(
                                  context,
                                ).add(UpdateDetailsSubmitted(newUserModel));
                                widget.onUserUpdated(newUserModel);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Save Changes",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    bool readOnly = false,
    Future<void> Function()? onMapPick, // <-- optional handler
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      readOnly: readOnly,
      onTap: readOnly && onMapPick != null ? () => onMapPick() : null,
      keyboardType: keyboardType,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.primaryColor, fontSize: 14),
        prefixIcon: Icon(icon, color: theme.primaryColor),
        suffixIcon:
            onMapPick != null
                ? IconButton(
                  icon: const Icon(Icons.location_on_outlined),
                  tooltip: "Pick from map",
                  onPressed: () => onMapPick(),
                )
                : null,
        filled: true,
        fillColor: theme.colorScheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerTheme.color!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
