import "package:flutter/material.dart";
import "package:coinhub/presentation/components/profile/navigation_option_item.dart";
import "package:coinhub/presentation/components/profile/profile_divider.dart";
import "package:coinhub/presentation/components/profile/profile_section_container.dart";
import "package:go_router/go_router.dart";

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      children: [
        // Help & Support Option
        NavigationOptionItem(
          icon: Icons.help_outline,
          title: "Help & Support",
          subtitle: "Get help with your account",
          onTap: () => context.push("/support/help"),
        ),

        const ProfileDivider(),

        // About Option
        NavigationOptionItem(
          icon: Icons.info_outline,
          title: "About",
          subtitle: "Learn more about CoinHub",
          onTap: () => context.push("/support/about"),
        ),
      ],
    );
  }
}
