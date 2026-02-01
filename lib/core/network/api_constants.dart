class ApiConstants {
  static const String apiBaseUrl = "https://oreedo.net";

  static const String login = "/api/login";
  static const String register = "/api/register";
  static const String setFavorite = '/api/set_favorite';
  static const String deleteCar = '/api/v1/delete_car';
  static const String deleteProperty = '/api/v1/delete_property';
  static const String deleteTechnician = '/api/v1/delete_technician';
  static const String deleteAnything = '/api/v1/delete_anything';
  static const String getFavorites = '/api/get_favorites';
  static const String updatePassword = "/api/update_password";
   static const String resetPassword = "/api/reset_password";
  static const String changePassword = "/api/change_password";
  static const String updatePasswordWithOtp = "/api/update_password_with_otp";
  static const String checkUser = "/api/check_user";
  static const String completeRegistration = "/api/complete_registration";
  static const String editProfile = "/api/edit_profile";
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
