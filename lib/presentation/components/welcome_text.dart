import "package:flutter/material.dart";

class WelcomeText extends StatelessWidget {
  final String title, text;

  const WelcomeText({super.key, required this.title, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 16 / 2),
        Text(text, style: TextStyle(color: Color(0xFF868686))),
        const SizedBox(height: 24),
      ],
    );
  }
}
