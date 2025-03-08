class Routes {
  static const String home = "/";

  static Auth auth = Auth();
  static Account account = Account();
  static Transaction transaction = Transaction();
}

class Auth {
  final String root = "/auth";
  String get login => "$root/login";
  String get signUp => "$root/signUp";
  String get forgotPassword => "$root/forgotPassword";
  String get verify => "$root/verify";
}

class Account {
  final String root = "/account";
  String get pin => "$root/pin";
  //TODO: Implement account routes
}

class Transaction {
  final String root = "/transaction";
  String get pin => "$root/pin";
}
