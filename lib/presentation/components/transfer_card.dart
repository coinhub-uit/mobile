import "package:flutter/material.dart";

class TransferCard extends StatefulWidget {
  final String title;
  const TransferCard({super.key, required this.title});
  @override
  State<TransferCard> createState() => _TransferCardState();
}

class _TransferCardState extends State<TransferCard> {
  final TextEditingController amountController = TextEditingController();
  final int limitLength = 160;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transfer to:",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: "Account Number")),
            SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: "Amount")),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: "Description",
                counterText: "${amountController.text.length}/$limitLength",
              ),
              maxLength: limitLength,
              controller: amountController,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
