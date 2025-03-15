class Routes {
  static const String home = "/";

  static const Auth = _Auth();
  static const Account = _Account();
  static const Transaction = _Transaction();
}

class _Auth {
  final String root = "/auth";
  const _Auth();

  String get login => "$root/login";
  String get signUp => "$root/signUp";
  String get forgotPassword => "$root/forgotPassword";
  String get verify => "$root/verify";
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
}


