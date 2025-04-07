import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/core/constants/theme.dart";
import "package:coinhub/presentation/routes/router.dart";
import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:coinhub/core/util/env.dart";
import "package:http/http.dart" as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  testHttp(); // Test HTTP request to the API server
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;
final goRouter = RouteRouter().router;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => UserBloc()),
      ],
      child: MaterialApp.router(
        theme: catppuccinTheme(isDark: false),
        darkTheme: catppuccinTheme(isDark: true),
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
      ),
    );
  }
}

void testHttp() async {
  print("Requesting: ${Env.supabaseUrl}");
  try {
    final url = Uri.parse(Env.apiServerUrl); // get url
    final response = await http.get(url); // get response
    if (response.statusCode == 200) {
      print("Response: ${response.body}"); // print response body
    } else {
      print("Error: ${response.statusCode}"); // print error status code
    }
  } catch (e) {
    print("Error: $e"); // print error message
  }
}
