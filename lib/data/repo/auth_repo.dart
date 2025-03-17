import 'package:rheel_estate/data/api/api_client.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> login(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.LOGIN_URI, data);
  }

  Future<Response> deleteAccount() async {
    return await apiClient.delete(AppConstants.DELETE_ACCOUNT);
  }

  Future<Response> signUp(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.SIGNUP_URI, data);
  }

  Future<Response> verifyOtp(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.VERIFY_OTP, data);
  }

  Future<Response> resetPassword(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.RESET_PASSWORD, data);
  }

  Future<Response> forgottenPassword(String email) async {
    try {
      final response = await apiClient.post(
        AppConstants.FORGOT_PASSWORD,
        {"email": email},
      );

      return response; // Return full response, not just a bool
    } catch (e) {
      print("Error in forgottenPassword: $e");
      return const Response();
    }
  }

  Future<Response> properties() async {
    return await apiClient.getData(AppConstants.GET_PROPERTIES);
  }

  Future<void> setToken(String newToken) async {
    apiClient.updateHeader(newToken);
    await sharedPreferences.setString(AppConstants.TOKEN, newToken);
  }

  Future<String?> getToken() async {
    return sharedPreferences.getString(AppConstants.TOKEN);
  }

  Future<void> clearToken() async {
    await sharedPreferences.remove(AppConstants.TOKEN);
  }

  Future<void> setRemember(bool rememberMe) async {
    await sharedPreferences.setBool(AppConstants.REMEMBER_KEY, rememberMe);
  }

  Future<bool> getRemember() async {
    return sharedPreferences.getBool(AppConstants.REMEMBER_KEY) ?? false;
  }

  Future<void> clearAllData() async {
    await sharedPreferences.clear();
  }



  Future<void> setFirstInstall(bool firstInstall) async {
    await sharedPreferences.setBool(AppConstants.FIRST_INSTALL, firstInstall);
  }

  Future<bool> getFirstInstall() async {
    return sharedPreferences.getBool(AppConstants.FIRST_INSTALL) ?? true;
  }

}
