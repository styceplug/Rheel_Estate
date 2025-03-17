

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/controllers/auth_controller.dart';
import 'package:rheel_estate/data/repo/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

AuthController authController = Get.find<AuthController>();
AuthRepo authRepo = Get.find<AuthRepo>();

TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

bool isLoading = false;
bool isVisible = false;
bool isConfirmVisible = false;
String passwordStrengthMessage = "";

class _ResetPasswordState extends State<ResetPassword> {


  void resetPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? otp = prefs.getString('otp');
      String? email = prefs.getString('forgotten_email');
      String? resetToken = prefs.getString('newResetToken');

      print('Reset Password Request: email: $email, otp: $otp, resetToken: $resetToken');

      if (email == null || otp == null || resetToken == null) {
        Get.snackbar(
          "Error",
          "Missing required data. Please restart the process.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
        );
        return;
      }

      // ✅ Ensure resetPassword() in authRepo returns a Response
      Response response = await authRepo.resetPassword({
        "email": email,
        "otp": otp,
        "newPassword": confirmPasswordController.text.trim(),
        "resetToken": resetToken
      });

      // ✅ Print full response body from backend
      print("Backend Response: ${response.body}");

      if (response.statusCode == 200 && response.body['status'] == true) {
        Get.snackbar(
          "Success",
          response.body['message'] ?? "Password reset successful!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
        );

        // Navigate to login screen
        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        Get.snackbar(
          "Error",
          response.body['message'] ?? "Failed to reset password.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
        );
      }
    } catch (e) {
      print("Error resetting password: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
      );
    }
  }



  void visiblePass() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void visibleConfirmPass() {
    setState(() {
      isConfirmVisible = !isConfirmVisible;
    });
  }

  Widget buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
              fontSize: Dimensions.font14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: Dimensions.height5),
        TextField(
          obscureText: !isVisible,
          controller: passwordController,
          cursorColor: AppColors.blackColor.withOpacity(0.6),
          onChanged: (value) {
            setState(() {
              passwordStrengthMessage = passwordStrength(value);
            });
          },
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  visiblePass();
                });
              },
              child: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
            ),
            alignLabelWithHint: false,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height15,
            ),
            hintText: '**************',
            hintStyle: TextStyle(
              color: AppColors.blackColor.withOpacity(0.6),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width20,
                color: AppColors.blackColor.withOpacity(0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width20,
                color: AppColors.blackColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width20,
                color: AppColors.blackColor.withOpacity(0.4),
              ),
            ),
          ),
          selectionControls:
              MaterialTextSelectionControls(), // Highlight feature
        ),
        SizedBox(height: Dimensions.height10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Password Strength: $passwordStrengthMessage',
              style: TextStyle(
                color: passwordStrengthMessage == "Strong"
                    ? Colors.green
                    : passwordStrengthMessage == "Medium"
                        ? Colors.orange
                        : Colors.red,
                fontSize: Dimensions.font12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: TextStyle(
              fontSize: Dimensions.font14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: Dimensions.height5),
        TextField(
          obscureText: !isConfirmVisible,
          controller: confirmPasswordController,
          cursorColor: AppColors.blackColor.withOpacity(0.6),
          onChanged: (value) {
            setState(() {}); // Trigger UI updates
          },
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  visibleConfirmPass();
                });
              },
              child: Icon(
                  isConfirmVisible ? Icons.visibility : Icons.visibility_off),
            ),
            alignLabelWithHint: false,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height15,
            ),
            hintText: '**************',
            hintStyle: TextStyle(
              color: AppColors.blackColor.withOpacity(0.6),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width20,
                color: AppColors.blackColor.withOpacity(0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width20,
                color: AppColors.blackColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width20,
                color: AppColors.blackColor.withOpacity(0.4),
              ),
            ),
          ),
        ),
        SizedBox(height: Dimensions.height10),
        Text(
          confirmPasswordController.text == passwordController.text
              ? "Passwords Match"
              : "Passwords Don't Match",
          style: TextStyle(
            color: confirmPasswordController.text == passwordController.text
                ? Colors.green
                : Colors.red,
            fontSize: Dimensions.font12,
          ),
        ),
      ],
    );
  }

  String passwordStrength(String password) {
    if (password.length < 6) {
      return "Weak";
    } else if (!RegExp(r"[A-Z]").hasMatch(password) ||
        !RegExp(r"[0-9]").hasMatch(password) ||
        !RegExp(r"[!@#\$&*~]").hasMatch(password)) {
      return "Medium";
    }
    return "Strong";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        toolbarHeight: Dimensions.height50 * 1.2,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Reset Password',
          style: TextStyle(
              fontSize: Dimensions.font22, fontWeight: FontWeight.w500),
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Row(
            children: [
              SizedBox(width: Dimensions.width20),
              Container(
                alignment: Alignment.center,
                height: Dimensions.height33,
                width: Dimensions.width33,
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: const Icon(CupertinoIcons.chevron_back),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height30),
              Container(
                height: Dimensions.height20 * 9,
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AppConstants.getPngAsset('forgot'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'Don’t worry! It happens. Please choose your new password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(0.8)),
              ),
              SizedBox(height: Dimensions.height30),
              buildPasswordField(),
              SizedBox(height: Dimensions.height20),
              buildConfirmPasswordField(),
              SizedBox(height: Dimensions.height20),
              InkWell(
                onTap: resetPassword,
                child: Container(
                  alignment: Alignment.center,
                  height: Dimensions.height50,
                  decoration: BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius30)),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.font17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
