import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:intl/intl.dart";

class FixedDepositCard extends StatelessWidget {
  final int index;
  final int moneyInit;
  final int profit;
  final double profitPercentage;
  final String startDate;
  final String endDate;

  const FixedDepositCard({
    super.key,
    required this.index,
    required this.moneyInit,
    required this.profit,
    required this.profitPercentage,
    required this.startDate,
    required this.endDate,
  });
  @override
  Widget build(BuildContext context) {
    String vndFormat(int amount) {
      // format money to VND
      final formatter = NumberFormat("#,###", "vi_VN");
      return "${formatter.format(amount)}đ";
    }

    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.dollarSign,
                      size: 36,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Fixed Deposit $index",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.displayMedium!.fontSize,
                        fontWeight: FontWeight.w500,
                      ),

                      //Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Divider(thickness: 2, color: Colors.grey, height: 1),
            ),
            Text(
              vndFormat(moneyInit),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  "Expected Profit: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${vndFormat(profit)} ($profitPercentage%)",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      startDate,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text(
                      endDate,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Settlement",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Withdraw",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
