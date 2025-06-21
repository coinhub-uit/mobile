import "dart:async";
import "dart:developer";
import "package:coinhub/core/bloc/auth/auth_logic.dart";
import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart" as auth_bloc;
import "package:coinhub/core/bloc/deposit/deposit_logic.dart";
import "package:coinhub/core/bloc/plan/plan_logic.dart";
import "package:coinhub/core/bloc/source/source_logic.dart";
import "package:coinhub/core/bloc/ticket/ticket_logic.dart";
import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/core/constants/theme.dart";
import "package:coinhub/core/constants/theme_provider.dart";
import "package:coinhub/core/util/notification.dart";
import "package:coinhub/core/util/timeout.dart";
import "package:coinhub/core/services/timeout_service.dart";
import "package:coinhub/firebase_options.dart";
import "package:coinhub/presentation/routes/router.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:coinhub/core/util/env.dart";
import "package:app_links/app_links.dart";
import "package:http/http.dart" as http;

void main() async {
  print("Env.supabaseUrl: ${Env.supabaseUrl}");
  print("Env.supabaseAnonKey: ${Env.supabaseAnonKey}");
  print("Env.apiServerUrl: ${Env.apiServerUrl}");

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  log("JWT Token: ${supabase.auth.currentSession?.accessToken}");
  testHttp(); // Test HTTP request to the API server
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.instance.initialize();
  NotificationService.instance.getDeviceToken();

  // Initialize timeout service
  final timeoutService = TimeoutService();
  await timeoutService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: timeoutService),
      ],
      child: const MyApp(),
    ),
  );
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
        goRouter.go(Routes.auth.login);
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
        goRouter.go("${Routes.auth.resetPassword}?code=$code");
      } else if (host == "auth" && path == "/verify") {
        goRouter.go(Routes.home);
      } else {
        goRouter.go(Routes.auth.login);
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => PlanBloc()),
        BlocProvider(create: (context) => SourceBloc()),
        BlocProvider(create: (context) => TicketBloc()),
        BlocProvider(create: (context) => DepositBloc()),
      ],
      child: SessionAwareApp(themeProvider: themeProvider),
    );
  }
}

/// Wrapper widget that handles session initialization and navigation
class SessionAwareApp extends StatefulWidget {
  final ThemeProvider themeProvider;

  const SessionAwareApp({super.key, required this.themeProvider});

  @override
  State<SessionAwareApp> createState() => _SessionAwareAppState();
}

class _SessionAwareAppState extends State<SessionAwareApp> {
  @override
  void initState() {
    super.initState();
    // Initialize session on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const InitializeSession());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, auth_bloc.AuthState>(
      listener: (context, state) {
        if (state is auth_bloc.SessionRestored) {
          // User has an active session, navigate to home
          debugPrint("Session restored for user: ${state.userId}");
          NotificationService.instance.registerDeviceToken(
            userId: state.userId,
            accessToken: state.jwt,
          );
          goRouter.go(Routes.home);
        } else if (state is auth_bloc.SessionNotFound) {
          // No session found, navigate to login
          debugPrint("No session found, redirecting to login");
          goRouter.go(Routes.auth.login);
        } else if (state is auth_bloc.LoginSuccess) {
          // User just logged in successfully, navigate to home
          debugPrint("Login successful, redirecting to home");
          final session = supabase.auth.currentSession;
          if (session?.user.id != null && session?.accessToken != null) {
            NotificationService.instance.registerDeviceToken(
              userId: session!.user.id,
              accessToken: session.accessToken,
            );
          }
          goRouter.go(Routes.home);
        } else if (state is auth_bloc.SignUpWithGoogleSuccess) {
          // User signed up with Google successfully, navigate to home
          debugPrint("Google sign up successful, redirecting to home");
          final session = supabase.auth.currentSession;
          if (session?.user.id != null && session?.accessToken != null) {
            NotificationService.instance.registerDeviceToken(
              userId: session!.user.id,
              accessToken: session.accessToken,
            );
          }
          goRouter.go(Routes.home);
        }
      },
      child: BlocBuilder<AuthBloc, auth_bloc.AuthState>(
        builder: (context, state) {
          // Show loading screen while initializing session
          if (state is auth_bloc.SessionInitializing) {
            return MaterialApp(
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: widget.themeProvider.themeMode,
              debugShowCheckedModeBanner: false,
              home: const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Initializing..."),
                    ],
                  ),
                ),
              ),
            );
          }

          // Return the main app after session initialization
          return Timeout(
            child: MaterialApp.router(
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: widget.themeProvider.themeMode,
              debugShowCheckedModeBanner: false,
              routerConfig: goRouter,
            ),
          );
        },
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
