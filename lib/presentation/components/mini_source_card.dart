import "package:flutter/material.dart";
import "package:intl/intl.dart";

class MiniSourceCard extends StatelessWidget {
  final String sourceId;
  final String moneyInit;
  final bool abnormal;
  final IconData icon;
  final Color color;

  const MiniSourceCard({
    required this.moneyInit,
    required this.sourceId,
    required this.icon,
    required this.color,
    this.abnormal = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String vndFormat(int amount) {
      final formatter = NumberFormat("#,###", "vi_VN");
      return "${formatter.format(amount)}đ";
    }

    String formatMoney(String moneyInit) {
      try {
        return vndFormat(int.parse(moneyInit));
      } catch (_) {
        return moneyInit;
      }
    }

    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    final Color onSurfaceWithOpacity = onSurface.withValues(
      alpha: (0.4 * 255).round().toDouble(),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child:
          !abnormal
              ? Container(
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
                          Icon(icon, size: 30, color: onSurface),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sourceId,
                                  style: TextStyle(
                                    color: onSurface,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  formatMoney(moneyInit),
                                  style: TextStyle(
                                    color: onSurfaceWithOpacity,
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
              )
              : Container(
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
                          Icon(icon, size: 30, color: onSurface),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sourceId,
                                  style: TextStyle(
                                    color: onSurface,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  formatMoney(moneyInit),
                                  style: TextStyle(
                                    color: onSurfaceWithOpacity,
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
