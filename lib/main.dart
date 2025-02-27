import "package:coinhub/presentation/screen/auth/login_screen.dart";
import "package:flutter/material.dart";
// import "package:coinhub/presentation/screen/home.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:coinhub/core/constants/supabase.dart";

void main() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
