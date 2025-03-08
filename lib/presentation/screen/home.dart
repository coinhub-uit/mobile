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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: [
            SizedBox(height: 48),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Balance:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                  '21.987.000đ',
                    style: Theme.of(context).textTheme.titleLarge,
                ),
                ],
              )
              
            ),
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
          ],
        ),
      ),
    );
  }
}
