import "package:flutter/material.dart";
import "package:coinhub/core/services/auth.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(placeholderText, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await AuthService.signInWithGoogle();
                } catch (e) {
                  debugPrint("Sign in failed: $e");
                }
              },
              child: Text("Sign in with google"),
            ),
          ],
        ),
      ),
    );
  }
}
