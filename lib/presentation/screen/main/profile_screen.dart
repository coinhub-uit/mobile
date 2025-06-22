import "package:coinhub/presentation/components/profile/account_action_section.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/components/profile/account_section.dart";
import "package:coinhub/presentation/components/profile/profile_header.dart";
import "package:coinhub/presentation/components/profile/profile_snackbar.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:go_router/go_router.dart";

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
        final theme = Theme.of(context);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Delete Account", style: theme.textTheme.titleLarge),
          content: Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(false);
              },
              child: Text("Cancel", style: theme.textTheme.labelLarge),
            ),
            ElevatedButton(
              onPressed: () {
                context.pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: Text(
                "Delete",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text("Profile", style: theme.textTheme.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UpdateAvatarError) {
            ProfileSnackbar.show(context, state.error, isError: true);
          } else if (state is UpdateAvatarSuccess) {
            ProfileSnackbar.show(context, "Avatar updated successfully");
            // widget.model.avatar = state.avatarUrl;
          } else if (state is DeleteAccountError) {
            ProfileSnackbar.show(context, state.error, isError: true);
          } else if (state is DeleteAccountSuccess) {
            ProfileSnackbar.show(
              context,
              "Account deleted successfully",
              duration: 1,
            );
            Future.delayed(const Duration(seconds: 1));
            context.go(Routes.auth.login);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header with Avatar
              ProfileHeader(model: widget.model, userEmail: widget.userEmail),

              // Account Section
              AccountSection(
                userModel: widget.model,
                userEmail: widget.userEmail,
                onUserUpdated: widget.onUserUpdated,
              ),

              const SizedBox(height: 24),

              // Account Actions Section
              AccountActionsSection(
                userId: widget.model.id,
                onDeleteAccount: confirmAndDelete,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
