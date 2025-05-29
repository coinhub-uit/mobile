import "package:coinhub/models/plan_model.dart";
import "package:coinhub/models/source_model.dart";
import "package:coinhub/models/ticket_model.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/screen/account/create_pin_screen.dart";
import "package:coinhub/presentation/screen/auth/forgot_password_screen.dart";
import "package:coinhub/presentation/screen/auth/login_screen.dart";
import "package:coinhub/presentation/screen/auth/reset_password_screen.dart";
import "package:coinhub/presentation/screen/auth/sign_up_details_screen.dart";
import "package:coinhub/presentation/screen/auth/sign_up_screen.dart";
import "package:coinhub/presentation/screen/auth/verify_screen.dart";
import "package:coinhub/presentation/screen/main/home.dart";
import "package:coinhub/presentation/screen/setting/pin_screen.dart";
import "package:coinhub/presentation/screen/setting/account_detail_screen.dart";
import "package:coinhub/presentation/screen/setting/advance_settings_screen.dart";
import "package:coinhub/presentation/screen/setting/privacy_screen.dart";
import "package:coinhub/presentation/screen/setting/security_screen.dart";
import "package:coinhub/presentation/screen/setting/theme_setting_screen.dart";
import "package:coinhub/presentation/screen/transaction/add_source_screen.dart";
import "package:coinhub/presentation/screen/transaction/deposit_screen.dart";
import "package:coinhub/presentation/screen/transaction/saving_plan_screen.dart";
import "package:coinhub/presentation/screen/transaction/source_details_screen.dart";
import "package:coinhub/presentation/screen/transaction/ticket_detail_screen.dart";
import "package:coinhub/presentation/screen/transaction/withdraw_screen.dart";
import "package:coinhub/presentation/screen/transaction/transfer_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:coinhub/presentation/routes/routes.dart";

class RouteRouter {
  final GoRouter router = GoRouter(
    initialLocation: Routes.auth.login,
    routes: [
      GoRoute(
        name: "home",
        path: Routes.home,
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomeScreen());
        },
      ),
      GoRoute(
        name: "login",
        path: Routes.auth.login,
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginScreen());
        },
      ),
      GoRoute(
        name: "signUp",
        path: Routes.auth.signUp,
        pageBuilder: (context, state) {
          return const MaterialPage(child: SignUpScreen());
        },
      ),
      GoRoute(
        name: "forgotPassword",
        path: Routes.auth.forgotPassword,
        pageBuilder: (context, state) {
          return const MaterialPage(child: ForgotPasswordScreen());
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
          return const PinEntryScreen();
        },
      ),
      GoRoute(
        name: "newPin",
        path: Routes.account.pin,
        builder: (context, state) {
          return const CreatePinScreen();
        },
      ),
      GoRoute(
        name: "deposit",
        path: Routes.transaction.deposit,
        builder: (context, state) {
          final model = state.extra as UserModel;
          return DepositScreen(model: model);
        },
      ),
      GoRoute(
        name: "withdraw",
        path: Routes.transaction.withdraw,
        builder: (context, state) {
          final model = state.extra as UserModel;
          return WithdrawScreen(model: model);
        },
      ),
      GoRoute(
        name: "transfer",
        path: Routes.transaction.transfer,
        builder: (context, state) {
          return const TransferScreen();
        },
      ),
      GoRoute(
        name: "new-saving-plan",
        path: Routes.transaction.savingPlan,
        builder: (context, state) {
          // You can pass any required data through state.extra if needed
          final model = state.extra as UserModel;
          return SavingPlanScreen(model: model);
        },
      ),
      GoRoute(
        name: "add-source",
        path: Routes.transaction.addSource,
        builder: (context, state) {
          // You can pass any required data through state.extra if needed
          print("Navigated to AddSourceScreen!");
          return const AddSourceScreen();
        },
      ),
      GoRoute(
        name: "source-details",
        path: Routes.transaction.sourceDetails,
        builder: (context, state) {
          final model = state.extra as SourceModel;
          return SourceDetailsScreen(model: model);
        },
      ),
      GoRoute(
        name: "ticket-detail",
        path: Routes.transaction.ticketDetail,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final ticket = extra["ticket"] as TicketModel;
          final plan = extra["plan"] as PlanModel;
          return TicketDetailsScreen(ticketModel: ticket, planModel: plan);
        },
      ),
      // Settings routes
      GoRoute(
        name: "theme",
        path: Routes.settings.theme,
        builder: (context, state) {
          return const ThemeSettingsScreen();
        },
      ),
      GoRoute(
        name: "security",
        path: Routes.settings.security,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final email = data["email"] as String;
          return SecurityScreen(email: email);
        },
      ),
      GoRoute(
        name: "privacy",
        path: Routes.settings.privacy,
        builder: (context, state) {
          return const PrivacyScreen();
        },
      ),
      GoRoute(
        name: "accountDetails",
        path: Routes.settings.accountDetails,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final userModel = data["userModel"] as UserModel;
          final onUserUpdated = data["onUserUpdated"] as Function(UserModel);
          return AccountDetailsScreen(
            userModel: userModel,
            onUserUpdated: onUserUpdated,
          );
        },
      ),
      GoRoute(
        name: "advanced",
        path: Routes.settings.advanced,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final userId = data["userId"] as String;
          final onDeleteAccount =
              data["onDeleteAccount"] as Function(BuildContext);
          return AdvancedSettingsScreen(
            userId: userId,
            onDeleteAccount: onDeleteAccount,
          );
        },
      ),
    ],
    // Add custom transition animations
    // transitionBuilder: (context, state, child) {
    //   return SlideTransition(
    //     position: Tween<Offset>(
    //       begin: const Offset(1, 0),
    //       end: Offset.zero,
    //     ).animate(CurvedAnimation(
    //       parent: state.pageKey.route!.animation!,
    //       curve: Curves.easeInOut,
    //     )),
    //     child: child,
    //   );
    // },
    // Error handling for routes
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Page not found",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).go(Routes.home),
                child: const Text("Go Home"),
              ),
            ],
          ),
        ),
      );
    },
  );
}
