import "package:flutter/material.dart";

class YellowCard extends StatelessWidget {
  final String label;

  const YellowCard({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Theme.of(context).colorScheme.onSecondary,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Text(label, style: Theme.of(context).textTheme.displayMedium),
      ),
    );
  }
}
