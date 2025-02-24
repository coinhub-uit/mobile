import "package:flutter/material.dart";
import "package:coinhub/presentation/screen/home.dart";
import "package:supabase_flutter/supabase_flutter.dart";

void main() async {
  await Supabase.initialize(
    url: "https://yopvlrbdzgkmbfilgrqf.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlvcHZscmJkemdrbWJmaWxncnFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAyMDg2MjEsImV4cCI6MjA1NTc4NDYyMX0.V4dAeIA_ck-8-P12GMJu8YD9WK_pXPf_qgEEFD97Xgk",
  );
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
