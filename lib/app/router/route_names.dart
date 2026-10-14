abstract final class RouteNames {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const vehicles = '/vehicles';
  static const vehicleNew = '/vehicles/new';

  static String vehicleEdit(String id) => '/vehicles/$id/edit';
}
