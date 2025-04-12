import "package:flutter/material.dart";

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final Color? iconColor;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // Fix the deprecated withOpacity by using withValues
    final Color fallbackColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: (0.5 * 255).round().toDouble(),
    );

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: color ?? fallbackColor,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed ?? () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}