class Routes {
  static const String home = "/";

  static Auth auth = Auth();
  static Account account = Account();
}

class Auth {
  final String root = "/auth";
  String get login => "$root/login";
  String get signUp => "$root/signUp";
  String get forgotPassword => "$root/forgotPassword";
  String get verify => "$root/verify";
}

class Account {
  //TODO: Implement account routes
}
