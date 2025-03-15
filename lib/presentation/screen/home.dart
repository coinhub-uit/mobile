import "package:flutter/material.dart";
import "package:coinhub/core/services/auth.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:coinhub/presentation/components/purple_card.dart";
import "package:coinhub/presentation/components/yellow_card.dart";
import "package:coinhub/presentation/components/header_container.dart";
import "package:coinhub/presentation/components/home_app_bar.dart";
import "package:coinhub/presentation/components/fixed_deposit_card.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:go_router/go_router.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String placeholderText = "This is a placeholder.";
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreenContent(),
    SavingsScreen(),
    ProfileScreen(),
  ];
  
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    AuthService.authStateChanges.listen((data) {
      setState(() {
        placeholderText = "User is signed in: ${data.session?.user.email}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          onItemTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wallet),
            label: "Savings",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.portrait),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// home screen content
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        userName: "User",
        imgUrl: "https://avatars.githubusercontent.com/u/47231161?v=4",
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              HeaderContainer(topLabel: "Balance:", bottomLabel: "21.987.000đ"),
              SizedBox(height: 2),
              Row(
                children: [
                  YellowCard(label: "+5.5%"),
                  SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: GestureDetector(
                        onTap:
                            () => {context.push(Routes.Transaction.transfer)},
                        child: PurpleCard(
                          icon: Icons.money,
                          label: "Transfer",
                          iconSize: 16,
                          labelSize: 16,
                          arrowSize: 16,
                          paddingTop: 6,
                          paddingBottom: 6,
                          paddingLeft: 16,
                          paddingRight: 16,
                          isTransferButton: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: GestureDetector(
                      onTap: () {},
                      child: PurpleCard(
                        icon: FontAwesomeIcons.piggyBank,
                        label: "Add new\nSaving plan",
                        iconSize: 56,
                        arrowSize: 64,
                        labelSize: 36,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          height: 180,
                          child: GestureDetector(
                            onTap: () {
                              context.push(Routes.Transaction.deposit);
                            },
                            child: PurpleCard(
                              icon: FontAwesomeIcons.arrowDown,
                              label: "Deposit",
                              iconSize: 48,
                              arrowSize: 56,
                              labelSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          height: 180,
                          child: GestureDetector(
                            onTap: () {
                              context.push(Routes.Transaction.withdraw);
                            },
                            child: PurpleCard(
                              icon: FontAwesomeIcons.arrowUpFromBracket,
                              label: "Withdraw",
                              iconSize: 48,
                              arrowSize: 56,
                              labelSize: 24,
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
      ),
    );
  }
}

// savings screen
class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        userName: "User",
        imgUrl: "https://avatars.githubusercontent.com/u/47231161?v=4",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            HeaderContainer(topLabel: "Savings:", bottomLabel: "21.987.000đ"),
            SizedBox(height: 2),
            YellowCard(label: "+123.000đ"),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return FixedDepositCard(
                    index: index + 1,
                    moneyInit: 1234000,
                    profit: 30000,
                    profitPercentage: 5.5,
                    startDate: "1/1/2025",
                    endDate: "1/6/2025",
                  );
                },
              ),
            )
            
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(child: Text("Profile")),
    );
  }
}
// Container(
//   constraints: BoxConstraints.expand(height: 100),
//   padding: EdgeInsets.symmetric(horizontal: 30),
//   child: Transform.translate(
//     offset: Offset(0, -10),
//     child:
//   ),
// ),
// Text(placeholderText, style: TextStyle(fontSize: 20)),
// SizedBox(height: 20),
// ElevatedButton(
//   onPressed: () async {
//     try {
//       await AuthService.signInWithGoogle();
//     } catch (e) {
//       debugPrint("Sign in failed: $e");
//     }
//   },
//   child: Text("Sign in with google"),
// ),