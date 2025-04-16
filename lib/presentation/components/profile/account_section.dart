import "package:coinhub/presentation/screen/setting/account_detail_screen.dart";
import "package:coinhub/presentation/screen/setting/security_screen.dart";
import "package:coinhub/presentation/screen/setting/theme_setting_screen.dart";
import "package:flutter/material.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/components/profile/navigation_option_item.dart";
import "package:coinhub/presentation/components/profile/profile_divider.dart";
import "package:coinhub/presentation/components/profile/profile_section_container.dart";

class AccountSection extends StatelessWidget {
  final UserModel userModel;
  final String userEmail;
  final Function(UserModel) onUserUpdated;

  const AccountSection({
    super.key,
    required this.userModel,
    required this.userEmail,
    required this.onUserUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      children: [
        // Account Details Option
        NavigationOptionItem(
          icon: Icons.person_outline,
          title: "Account Details",
          subtitle: "Edit your personal information",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AccountDetailsScreen(
                      userModel: userModel,
                      onUserUpdated: onUserUpdated,
                    ),
              ),
            );
          },
        ),

        const ProfileDivider(),

        // Security Option
        NavigationOptionItem(
          icon: Icons.lock_outline,
          title: "Security",
          subtitle: "Change your password",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecurityScreen(email: userEmail),
              ),
            );
          },
        ),

        const ProfileDivider(),

        // Notifications Option
        NavigationOptionItem(
          icon: Icons.notifications_outlined,
          title: "Notifications",
          subtitle: "Manage your notification preferences",
          onTap: () {
            // Navigate to notifications screen
          },
        ),

        const ProfileDivider(),

        // Privacy Option
        NavigationOptionItem(
          icon: Icons.privacy_tip_outlined,
          title: "Privacy",
          subtitle: "Manage your privacy settings",
          onTap: () {
            // Navigate to privacy screen
          },
        ),

        const ProfileDivider(),

        // Theme Settings Option
        NavigationOptionItem(
          icon: Icons.color_lens_outlined,
          title: "Theme Settings",
          subtitle: "Customize app appearance",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ThemeSettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
