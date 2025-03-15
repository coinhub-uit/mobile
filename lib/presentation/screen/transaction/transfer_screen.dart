import "package:coinhub/presentation/components/mini_source_card.dart";
import "package:flutter/material.dart";

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  late int selectedIndex;
  final TextEditingController amountController = TextEditingController();
  final int limitLength = 160;

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transfer",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get fund from:",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: MiniSourceCard(
                              icon: Icons.account_balance_wallet,
                              moneyInit: 10000000,
                              sourceId: "098573821",
                              color:
                                  selectedIndex == index
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.onSecondary.withOpacity(0.8)
                                      : Theme.of(context).colorScheme.secondary,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(decoration: InputDecoration(labelText: "Amount")),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
                    TextField(
                      decoration: InputDecoration(labelText: "Account Number"),
                    ),
                    SizedBox(height: 12),
                    TextField(decoration: InputDecoration(labelText: "Amount")),
                    SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Description",
                        counterText:
                            "${amountController.text.length}/$limitLength",
                      ),
                      maxLength: limitLength,
                      controller: amountController,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60, // Adjust height
          child: FloatingActionButton(
            onPressed: () {
              // Add onPressed
            },
            child: Text(
              "Transfer",
              style: Theme.of(
                context,
              ).textTheme.displayMedium!.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
