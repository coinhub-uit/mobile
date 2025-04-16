import "package:coinhub/presentation/screen/setting/advance_settings_screen.dart";
import "package:flutter/material.dart";
import "package:coinhub/core/services/auth_service.dart";
import "package:coinhub/presentation/components/profile/navigation_option_item.dart";
import "package:coinhub/presentation/components/profile/profile_divider.dart";
import "package:coinhub/presentation/components/profile/profile_section_container.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:go_router/go_router.dart";

class AccountActionsSection extends StatelessWidget {
  final String userId;
  final Function(BuildContext) onDeleteAccount;

  const AccountActionsSection({
    super.key,
    required this.userId,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      children: [
        // Logout Option
        NavigationOptionItem(
          icon: Icons.logout,
          title: "Logout",
          subtitle: "Sign out of your account",
          iconColor: Colors.orange[700],
          onTap: () async {
            await AuthService.signOut();
            // ignore: use_build_context_synchronously
            context.go(Routes.auth.login);
          },
        ),

        const ProfileDivider(),

        // Advanced Settings (contains danger zone)
        NavigationOptionItem(
          icon: Icons.settings,
          title: "Advanced Settings",
          subtitle: "Account deletion and other advanced options",
          iconColor: Theme.of(context).colorScheme.onSurface.withAlpha(179),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AdvancedSettingsScreen(
                      userId: userId,
                      onDeleteAccount: onDeleteAccount,
                    ),
              ),
            );
          },
        ),
      ],
    );
  }
}
