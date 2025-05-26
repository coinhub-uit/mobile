class Routes {
  static const String home = "/";

  static const auth = _Auth();
  static const account = _Account();
  static const transaction = _Transaction();
  static const settings = _Settings();
}

class _Auth {
  final String root = "/auth";
  const _Auth();

  String get login => "$root/login";
  String get signUp => "$root/signUp";
  String get forgotPassword => "$root/forgotPassword";
  String get verify => "$root/verify";
  String get resetPassword => "$root/reset-password";
  String get signUpDetails => "$root/signUpDetails";
}

class _Account {
  final String root = "/account";
  const _Account();

  String get pin => "$root/pin";
}

class _Transaction {
  final String root = "/transaction";
  const _Transaction();

  String get pin => "$root/pin";
  String get deposit => "$root/deposit";
  String get withdraw => "$root/withdraw";
  String get transfer => "$root/transfer";
  String get savingPlan => "$root/new-saving-plan";
  String get addSource => "$root/add-source";
}

class _Settings {
  final String root = "/settings";
  const _Settings();

  String get theme => "$root/theme";
  String get security => "$root/security";
  String get privacy => "$root/privacy";
  String get accountDetails => "$root/account-details";
  String get advanced => "$root/advanced";
}
