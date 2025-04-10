import "dart:async";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/constants/theme.dart";
import "package:coinhub/presentation/routes/router.dart";
import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:coinhub/core/util/env.dart";
import "package:uni_links/uni_links.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );


  runApp(const MyApp());
}

final supabase = Supabase.instance.client;
final goRouter = RouteRouter().router;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _handleInitialUri();     // Cold start links
    _handleStreamedLinks();  // Links received while app is running
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await getInitialUri();

      if (uri != null) {
        _handleUri(uri);
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        goRouter.go("/auth/login");
      });
    }
  }

  void _handleStreamedLinks() {
    _sub = uriLinkStream.listen((uri) {
      if (uri != null) {
        _handleUri(uri);
      }
    }, onError: (err) {
    });
  }

  void _handleUri(Uri uri) {
    if (uri.scheme != "coinhub") return;

    final host = uri.host;
    final path = uri.path;
    final code = uri.queryParameters["code"];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (host == "auth" && path == "/reset-password" && code != null) {
        goRouter.go("/auth/reset-password?code=$code");
      } else if (host == "auth" && path == "/verify") {
        goRouter.go("/");
      } else {
        goRouter.go("/auth/login");
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
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