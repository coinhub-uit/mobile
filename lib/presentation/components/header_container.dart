import "package:flutter/material.dart";

class HeaderContainer extends StatelessWidget {
  final String topLabel;
  final String bottomLabel;
  const HeaderContainer({
    super.key,
    required this.topLabel,
    required this.bottomLabel,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          topLabel,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            bottomLabel,
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
