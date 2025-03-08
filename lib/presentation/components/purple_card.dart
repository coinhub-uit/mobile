import "package:flutter/material.dart";

class PurpleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double iconSize;
  final double labelSize;
  final double arrowSize;
  const PurpleCard({
    super.key,
    required this.icon,
    required this.label,
    required this.iconSize,
    required this.labelSize,
    required this.arrowSize,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.secondary,
                    size: iconSize,
                  ),
                  Icon(
                    Icons.arrow_circle_right_outlined,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: arrowSize,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: labelSize,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // TODO: implement build
  }
}
