import "package:flutter/material.dart";
import "package:coinhub/presentation/screen/home.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:coinhub/core/util/env.dart";

void main() async {
  debugPrint("env");
  debugPrint("db");
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
