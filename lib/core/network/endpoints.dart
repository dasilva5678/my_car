class Routes {
  static String baseUrl = "http://localhost:8080";
  static String login = "/user/login";
}

class Endpoints {
  static String login = "${Routes.baseUrl}${Routes.login}";
}
