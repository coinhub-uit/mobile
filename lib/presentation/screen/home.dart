import "package:flutter/material.dart";
import "package:coinhub/core/services/auth.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:coinhub/presentation/components/purple_card.dart";
import "package:coinhub/presentation/components/yellow_card.dart";
import "package:coinhub/presentation/components/header_container.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String placeholderText = "This is a placeholder.";

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
      appBar: AppBar(
        titleSpacing: 24,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          SizedBox(width: 20),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 27,
                  backgroundImage: NetworkImage(
                    //imgUrl
                    "https://avatars.githubusercontent.com/u/47231161?v=4",
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Hello,",
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                SizedBox(width: 10),
                Text(
                  "User",
                  style: Theme.of(context).appBarTheme.toolbarTextStyle,
                ),
              ],
            ),
          ],
        ),
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
              YellowCard(label: '+5.5%'),
              SizedBox(height: 32),
              PurpleCard(
                icon: FontAwesomeIcons.piggyBank,
                label: "Add new\nSaving plan",
                iconSize: 56,
                arrowSize: 64,
                labelSize: 36,
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: 180,
                    child: PurpleCard(
                      icon: FontAwesomeIcons.arrowDown,
                      label: "Deposit",
                      iconSize: 48,
                      arrowSize: 56,
                      labelSize: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: 180,
                    child: PurpleCard(
                      icon: FontAwesomeIcons.arrowUpFromBracket,
                      label: "Withdraw",
                      iconSize: 48,
                      arrowSize: 56,
                      labelSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
