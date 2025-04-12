import "package:coinhub/presentation/screen/account/create_pin_screen.dart";
import "package:coinhub/presentation/screen/auth/forgot_password_screen.dart";
import "package:coinhub/presentation/screen/auth/login_screen.dart";
import "package:coinhub/presentation/screen/auth/reset_password_screen.dart";
import "package:coinhub/presentation/screen/auth/sign_up_details_screen.dart";
import "package:coinhub/presentation/screen/auth/sign_up_screen.dart";
import "package:coinhub/presentation/screen/auth/verify_screen.dart";
import "package:coinhub/presentation/screen/home.dart";
import "package:coinhub/presentation/screen/setting/pin_screen.dart";
import "package:coinhub/presentation/screen/transaction/deposit_screen.dart";
import "package:coinhub/presentation/screen/transaction/withdraw_screen.dart";
import "package:coinhub/presentation/screen/transaction/transfer_screen.dart";
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
        name: "signUpDetails",
        path: Routes.auth.signUpDetails,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, String>;
          final email = data["email"] ?? "";
          final password = data["password"] ?? "";
          return MaterialPage(
            child: SignUpDetailsScreen(
              userEmail: email,
              userPassword: password,
            ),
          );
        },
      ),
      GoRoute(
        name: "verify",
        path: Routes.auth.verify,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, String>;
          final email = data["email"] ?? "";
          final password = data["password"] ?? "";

          return MaterialPage(
            child: VerifyScreen(userEmail: email, userPassword: password),
          );
        },
      ),
      GoRoute(
        name: "resetPassword",
        path: Routes.auth.resetPassword,
        pageBuilder: (context, state) {
          final code = state.uri.queryParameters["code"];
          return MaterialPage(child: ResetPasswordScreen(code: code));
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
        name: "deposit",
        path: Routes.transaction.deposit,
        builder: (context, state) {
          return DepositScreen();
        },
      ),
      GoRoute(
        name: "withdraw",
        path: Routes.transaction.withdraw,
        builder: (context, state) {
          return WithdrawScreen();
        },
      ),
      GoRoute(
        name: "transfer",
        path: Routes.transaction.transfer,
        builder: (context, state) {
          return TransferScreen();
        },
      ),
    ],
  );
}
