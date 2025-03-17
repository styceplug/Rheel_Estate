import 'dart:convert';

import 'package:rheel_estate/data/api/api_client.dart';
import 'package:rheel_estate/models/user_model.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  UserRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<void> saveUser(UserModel seller) async {
    String userJson = json.encode(seller.toJson());
    await sharedPreferences.setString(AppConstants.LOGIN_URI, userJson);
  }

  Future<bool> checkUserExists() async {
    bool userExists = sharedPreferences.containsKey(AppConstants.SIGNUP_URI);
    return userExists;
  }

  Future<UserModel?> getUser() async {
    String? sellerJson = sharedPreferences.getString(AppConstants.LOGIN_URI);
    print('seller json is $sellerJson');
    if (sellerJson != null) {
      return UserModel.fromJson(json.decode(sellerJson));
    }
    return null;
  }



}
