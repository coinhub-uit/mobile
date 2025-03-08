import "package:coinhub/presentation/screen/account/create_pin_screen.dart";
import "package:coinhub/presentation/screen/auth/forgot_password_screen.dart";
import "package:coinhub/presentation/screen/auth/login_screen.dart";
import "package:coinhub/presentation/screen/auth/sign_up_screen.dart";
import "package:coinhub/presentation/screen/auth/verify_screen.dart";
import "package:coinhub/presentation/screen/home.dart";
import "package:coinhub/presentation/screen/setting/pin_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:coinhub/presentation/routes/routes.dart";

class RouteRouter {
  GoRouter router = GoRouter(
    initialLocation: Routes.auth.login,
    routes: [
      GoRoute(
        name: "home",
        path: Routes.home,
        pageBuilder: (context, state) {
          return MaterialPage(child: HomeScreen());
        },
      ),
      GoRoute(
        name: "login",
        path: Routes.auth.login,
        pageBuilder: (context, state) {
          return MaterialPage(child: LoginScreen());
        },
      ),
      GoRoute(
        name: "signUp",
        path: Routes.auth.signUp,
        pageBuilder: (context, state) {
          return MaterialPage(child: SignUpScreen());
        },
      ),
      GoRoute(
        name: "forgotPassword",
        path: Routes.auth.forgotPassword,
        pageBuilder: (context, state) {
          return MaterialPage(child: ForgotPasswordScreen());
        },
      ),
      GoRoute(
        name: "verify",
        path: Routes.auth.verify,
        pageBuilder: (context, state) {
          final String email =
              state.extra is Map ? (state.extra as Map)["email"] ?? "" : "";
          return MaterialPage(
            child: VerifyScreen(email: email, type: VerificationType.email),
          );
        },
      ),
      GoRoute(
        name: "pin",
        path: Routes.transaction.pin,
        builder: (context, state) {
          return PinEntryScreen();
        },
      ),
      GoRoute(
        name: "newPin",
        path: Routes.account.pin,
        builder: (context, state) {
          return CreatePinScreen();
        },
      ),
      GoRoute(
        name: "pin",
        path: Routes.transaction.pin,
        builder: (context, state) {
          return PinEntryScreen();
        },
      ),
      GoRoute(
        name: "newPin",
        path: Routes.account.pin,
        builder: (context, state) {
          return CreatePinScreen();
        },
      ),
    ],
  );
}
