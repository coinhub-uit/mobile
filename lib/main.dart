import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/constants/theme.dart";
import "package:coinhub/presentation/routes/router.dart";
import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:coinhub/core/util/env.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;
final goRouter = RouteRouter().router;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AuthBloc())],
      child: MaterialApp.router(
        theme: catppuccinTheme(isDark: false),
        darkTheme: catppuccinTheme(isDark: true),
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
      ),
    );
  }
}
