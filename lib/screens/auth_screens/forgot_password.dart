import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/controllers/auth_controller.dart';

import 'package:rheel_estate/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController forgottenPassController = TextEditingController();
  AuthController authController = Get.find<AuthController>();
  bool isLoading = false;

  void forgottenPassword() async {
    String email = forgottenPassController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please provide a valid email.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await authController.forgottenPassword(email);
      // await prefs.setString('forgotten_email', email);




      // Get.toNamed(AppRoutes.verifyOtp);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to process request. Please try again.\nError: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
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
          'Forgotten Password',
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
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height50),
              Container(
                height: Dimensions.height20 * 12,
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AppConstants.getPngAsset('fogot-pass'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'Forgotten Password?',
                style: TextStyle(
                    fontSize: Dimensions.font25, fontWeight: FontWeight.w600),
              ),
              Text(
                'Reset Password with your mail in no time',
                style: TextStyle(
                    fontSize: Dimensions.font16, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: Dimensions.height50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Input Email address'),
                  SizedBox(height: Dimensions.height10),
                  CustomTextField(
                    controller: forgottenPassController,
                    hintText: 'Provide Email Address',
                    labelText: '',
                  ),
                  SizedBox(height: Dimensions.height20),
                ],
              ),
              InkWell(
                onTap: isLoading ? null : forgottenPassword,
                child: Container(
                  alignment: Alignment.center,
                  height: Dimensions.height50,
                  width: Dimensions.screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: Dimensions.font17,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: Dimensions.width10),
                      const Icon(
                        CupertinoIcons.arrow_right,
                        color: AppColors.white,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height50),
            ],
          ),
        ),
      ),
    );
  }
}