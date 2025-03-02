class Routes {
  static const String home = "/";

  static _Auth auth = _Auth();
  static _Account account = _Account();
}

class _Auth {
  final String root = "/auth";
  String get login => "$root/login";
  String get signUp => "$root/signUp";
  String get forgotPassword => "$root/forgotPassword";
  String get verify => "$root/verify";
}

class _Account {
  //TODO: Implement account routes
}
