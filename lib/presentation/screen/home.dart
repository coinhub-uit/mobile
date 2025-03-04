import "package:flutter/material.dart";
import "package:coinhub/core/services/auth.dart";

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
        titleSpacing: 25,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Icon(Icons.notifications),
          SizedBox(width: 5),
          Icon(Icons.settings),
          SizedBox(width: 30),
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
                  "Hello ,",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
                ),
                SizedBox(width: 10),
                Text(
                  "User",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 22),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              constraints: BoxConstraints.expand(height: 50),
              child: Text('Balance:', style: TextStyle(fontSize: 40)),
            ),
            Container(
              constraints: BoxConstraints.expand(height: 100),
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Transform.translate(
                offset: Offset(0, -10),
                child: Text(
                  '21.987.000đ',
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
