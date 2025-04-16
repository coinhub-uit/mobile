import "package:flutter/material.dart";

class ProfileDivider extends StatelessWidget {
  final double indent;
  final double endIndent;

  const ProfileDivider({super.key, this.indent = 20, this.endIndent = 20});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Divider(
      height: 1,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
      color: theme.dividerTheme.color,
    );
  }
}
