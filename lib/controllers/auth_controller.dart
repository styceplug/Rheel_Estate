import 'dart:async';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rheel_estate/controllers/user_controller.dart';
import 'package:rheel_estate/data/repo/auth_repo.dart';
import 'package:rheel_estate/models/user_model.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthController extends GetxController {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo,
  });

  UserController userController = Get.find<UserController>();

  void logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    await prefs.remove('profile_picture');

    print("✅ All user data cleared from SharedPreferences.");

    Future.delayed(const Duration(milliseconds: 500), () async {
      await authRepo.clearAllData();
    });

    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        print("🔄 Google Sign-Out Successful.");
      }
    } catch (e) {
      print("❌ Error signing out from Google: $e");
    }

    Get.offAllNamed(AppRoutes.loginScreen);
    print("Sign Out Successfully");
  }

  Future<Response> login({
    required String username,
    required String password,
    required bool remember,
  }) async {
    try {
      Map<String, dynamic> data = {
        'email': username,
        'pswd': password,
      };
      Response response = await authRepo.login(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final status = response.body['status'];
        if (status == true) {
          final token = response.body['token'];
          final user = UserModel.fromJson(response.body['user']);

          await authRepo.setToken(token);
          await authRepo.setRemember(remember);
          await userController.saveUser(user);

          Get.snackbar('Login Successfully!', 'Proceed to dashboard',
              backgroundColor: Colors.blue.withOpacity(0.8),
              colorText: AppColors.white,
              icon: const Icon(Icons.check_circle_outline_sharp,
                  size: 30, color: AppColors.white),
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20));

          Get.offAllNamed(AppRoutes.floatingBar, arguments: 0);
        } else {
          Get.snackbar(
            'Failed',
            response.body['message'],
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: AppColors.white,
          );
        }
      }
      return response; // ✅ Now returning the response
    } catch (e) {
      Get.snackbar(
        'An Error Occurred',
        '',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: AppColors.white,
      );
      if (kDebugMode) {
        print('AuthController login exception $e');
      }
      return const Response(
          statusCode: 500,
          body: {"status": false, "message": "An error occurred"});
    }
  }

  Future<Response> signup({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "pswd": password,
        "confirmPswd": confirmPassword,
      };

      Response response = await authRepo.signUp(data);
      Get.offAllNamed(AppRoutes.floatingBar);
      return response;
    } catch (e) {
      print("Sign-up error: $e");
      return const Response(
          statusCode: 500,
          body: {"status": false, "message": "An error occurred."});
    }
  }

  void setToken(String newToken) async {
    return await authRepo.setToken(newToken);
  }

  Future<String?> getToken() async {
    return await authRepo.getToken();
  }

  Future<void> clearToken() async {
    return await authRepo.clearToken();
  }

  Future<Response> deleteAccount(String token) async {
    return await authRepo.deleteAccount();
  }

  Future<Response> verifyOtp(
      {required String otp, required String email, required String resetToken}) async {
    Map<String, dynamic> data = {'otp': otp, 'email': email, 'resetToken':resetToken};
    return await authRepo.verifyOtp(data);
  }

  Future<void> resetPassword(String newPassword, String otp, String email, String resetToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('forgotten_email');
    String? otp = prefs.getString('otp');
    String? resetToken = prefs.getString('resetToken');

    if (email == null || otp == null || resetToken == null) {
      Get.snackbar("Error", "Missing reset information. Please restart the process.",
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red.withOpacity(0.8));
      return;
    }

    if (newPassword.isEmpty || newPassword.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long.",
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red.withOpacity(0.8));
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepo.resetPassword({
        "email": email,
        "otp": otp,
        "newPassword": newPassword,
        "resetToken": resetToken,
      });

      if (response.statusCode == 200 && response.body['Status'] == true) {
        Get.snackbar("Success", "Password reset successfully. Please log in with your new password.",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.green);

        // Clear saved data
        await prefs.remove('forgotten_email');
        await prefs.remove('otp');
        await prefs.remove('resetToken');

        Get.offAllNamed('/login'); // Navigate to Login Screen
      } else {
        Get.snackbar("Error", response.body['Message'] ?? "Password reset failed",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red.withOpacity(0.8));
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred. Please try again.",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8));
    } finally {
      isLoading.value = false;
    }
  }

  var isLoading = false.obs; // Ensure it's an observable variable

  Future<void> forgottenPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a valid email.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
      );
      return;
    }

    isLoading.value = true;

    try {
      // 🔍 Make API call
      final Response response = await authRepo.forgottenPassword(email);
      print("Backend Response: ${response.body}"); // ✅ Log full response

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = response.body; // ✅ Remove jsonDecode

        if (responseBody['status'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('forgotten_email', email);

          if (responseBody.containsKey('resetToken') && responseBody['resetToken'] != null) {
            await prefs.setString('resetToken', responseBody['resetToken']);
            print("Stored Reset Token: ${responseBody['resetToken']}"); // ✅ Log reset token
          } else {
            print("Error: Reset token missing in response.");
          }

          Get.snackbar(
            "Success",
            responseBody['message'] ?? "OTP sent successfully.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
          );

          Get.toNamed('/verify-otp');
        } else {
          Get.snackbar(
            "Error",
            responseBody['message'] ?? "Failed to send OTP.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(0.8),
          );
        }
      } else {
        print("Unexpected Response Code: ${response.statusCode}");
        Get.snackbar(
          "Error",
          "Unexpected response from server. Try again later.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
        );
      }
    } catch (e) {
      print("Error during forgottenPassword: $e"); // ✅ Log error
      Get.snackbar(
        "Error",
        "An error occurred. Please check your internet connection and try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> getFirstInstall() async {
    return await authRepo.getFirstInstall();
  }

  Future<bool> getRemember() async {
    return await authRepo.getRemember();
  }
}
