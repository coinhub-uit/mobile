import "package:flutter/material.dart";

class HeaderContainer extends StatelessWidget {
  final String topLabel;
  final String bottomLabel;
  HeaderContainer({
    super.key,
    required this.topLabel,
    required this.bottomLabel,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(topLabel, style: Theme.of(context).textTheme.titleSmall),
          Text(bottomLabel, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
