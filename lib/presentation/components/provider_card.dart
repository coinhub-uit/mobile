import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class ProviderCard extends StatelessWidget {
  final Widget img;
  final String provider;
  final Color color;

  const ProviderCard({
    required this.color,
    required this.img,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 52,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  SizedBox(width: 24, height: 24, child: img),

                  const SizedBox(width: 8),
                  Text(
                    provider,
                    style: TextStyle(color: onSurface, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
