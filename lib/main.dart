import "dart:async";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/core/constants/theme.dart";
import "package:coinhub/core/util/notification.dart";
import "package:coinhub/firebase_options.dart";
import "package:coinhub/presentation/routes/router.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:coinhub/core/util/env.dart";
import "package:app_links/app_links.dart";
import "package:http/http.dart" as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  testHttp(); // Test HTTP request to the API server
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.instance.initialize();
  NotificationService.instance.getDeviceToken();
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
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleInitialUri();
    _handleStreamedLinks();
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await _appLinks.getInitialLink();
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
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleUri(uri);
      },
      onError: (err) {
        // Log or ignore errors depending on what you want
      },
    );
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
  debugPrint("Requesting: ${Env.supabaseUrl}");
  try {
    final url = Uri.parse(Env.apiServerUrl); // get url
    final response = await http.get(url); // get response
    if (response.statusCode == 200) {
      debugPrint("Response: ${response.body}"); // debugPrin response body
    } else {
      debugPrint(
        "Error: ${response.statusCode}",
      ); // debugPrint error status code
    }
  } catch (e) {
    debugPrint("Error: $e"); // debugPrint error message
  }
}
