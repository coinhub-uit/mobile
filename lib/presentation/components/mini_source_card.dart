import "package:flutter/material.dart";
import "package:intl/intl.dart";

class MiniSourceCard extends StatelessWidget {
  final String sourceId;
  final int moneyInit;
  final IconData icon;
  final Color color;

  const MiniSourceCard({
    required this.moneyInit,
    required this.sourceId,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String vndFormat(int amount) {
      // format money to VND
      final formatter = NumberFormat("#,###", "vi_VN");
      return "${formatter.format(amount)}đ";
    }

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
                  Icon(
                    icon,
                    size: 30,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          sourceId,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          vndFormat(moneyInit),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
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
