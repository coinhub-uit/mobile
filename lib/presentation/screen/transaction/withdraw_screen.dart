import "package:flutter/material.dart";
import "package:coinhub/presentation/components/mini_source_card.dart";

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});
  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = 0; // index of the selected source
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Withdraw"),
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
                      "Withdraw from:",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 18,
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
              "Withdraw",
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
