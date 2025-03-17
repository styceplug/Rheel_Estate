import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rheel_estate/controllers/auth_controller.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  String email = '';
  AuthController authController = Get.find<AuthController>();

  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  TextEditingController otp5Controller = TextEditingController();
  TextEditingController otp6Controller = TextEditingController();

  bool isLoading = false;
  bool isResendEnabled = false;
  int secondsRemaining = 5; // 10 minutes
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadEmail();
    startTimer();
  }

  void loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('forgotten_email') ?? '';
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          isResendEnabled = true;
          timer.cancel();
        });
      }
    });
  }

  void verifyOtp() async {
    String otp = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text +
        otp5Controller.text +
        otp6Controller.text;

    if (otp.length < 6) {
      Get.snackbar(
        "Error",
        "Please enter a valid 6-digit OTP",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    print("Attempting OTP verification: $otp");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('forgotten_email');
      String? resetToken = prefs.getString('resetToken');
      await prefs.setString('otp', otp);

      if (email == null || email.isEmpty) {
        Get.snackbar(
          "Error",
          "Email is missing. Please restart the process.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        setState(() => isLoading = false);
        return;
      }

      Response response = await authController.verifyOtp(
        email: email,
        otp: otp,
        resetToken: resetToken ?? '',
      );

      print("Backend Response: ${response.body}"); // ✅ Log full response

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = response.body;

        print("OTP Verified Successfully: $responseBody");

        if (responseBody.containsKey('resetToken') && responseBody['resetToken'] != null) {
          await prefs.setString('newResetToken', responseBody['resetToken']);
          print('Stored newResetToken: ${responseBody['resetToken']}');
        } else {
          print("Warning: resetToken not provided in the response.");
        }

        Get.snackbar(
          "Success",
          responseBody['message'] ?? "OTP Verified Successfully.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.toNamed(AppRoutes.resetPassword);

        otp1Controller.clear();
        otp2Controller.clear();
        otp3Controller.clear();
        otp4Controller.clear();
        otp5Controller.clear();
        otp6Controller.clear();
      } else {
        print("OTP Verification Failed: ${response.body}");
        Get.snackbar(
          "Error",
          response.body['message'] ?? "Failed to verify OTP. Please try again.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error during OTP verification: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void resendOtp() async {
    if (!isResendEnabled) return;

    setState(() {
      isResendEnabled = false;
      secondsRemaining = 600; // Reset timer
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email =
          prefs.getString('forgotten_email'); // Retrieve saved email

      if (email == null || email.isEmpty) {
        Get.snackbar("Error",
            "No email found. Please go back and enter your email again.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }


      await authController.forgottenPassword(email);

      Get.snackbar("OTP Resent", "A new OTP has been sent to $email.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white);

      otp1Controller.clear();
      otp2Controller.clear();
      otp3Controller.clear();
      otp4Controller.clear();
      otp5Controller.clear();
      otp6Controller.clear();

    } catch (e) {
      Get.snackbar("Error", "Failed to resend OTP. Please try again.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }

    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
          'Verify OTP',
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
          margin: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height20),
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
                      AppConstants.getPngAsset('otp'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height20),

              SizedBox(height: Dimensions.height20),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    height: Dimensions.height50,
                    width: Dimensions.width50,
                    child: TextField(
                      controller: [
                        otp1Controller,
                        otp2Controller,
                        otp3Controller,
                        otp4Controller,
                        otp5Controller,
                        otp6Controller,
                      ][index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      cursorColor: AppColors.blackColor.withOpacity(0.6),
                      decoration: InputDecoration(
                        hintText: '-',
                        hintStyle: TextStyle(
                          color: AppColors.blackColor.withOpacity(0.3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius5),
                          borderSide: BorderSide(
                            color: AppColors.blackColor.withOpacity(0.4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius5),
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width20,
                            color: AppColors.blackColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius5),
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width20,
                            color: AppColors.blackColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height50),

              // Verify OTP Button
              InkWell(
                onTap: isLoading ? null : verifyOtp,
                child: Container(
                  alignment: Alignment.center,
                  height: Dimensions.height50,
                  width: Dimensions.screenWidth,
                  decoration: BoxDecoration(
                    color: isLoading ? Colors.grey : AppColors.accentColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: Dimensions.height30,
                          child:  LoadingAnimationWidget.threeRotatingDots(
                            size: Dimensions.iconSize16,
                              color: Colors.white))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Verify OTP',
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
              SizedBox(height: Dimensions.height20),

              // Resend OTP Button
              TextButton(
                onPressed: isResendEnabled ? resendOtp : null,
                child: Text(
                  isResendEnabled
                      ? "Resend OTP"
                      : "Resend OTP in ${secondsRemaining ~/ 60}:${(secondsRemaining % 60).toString().padLeft(2, '0')}",
                  style: TextStyle(
                    color: isResendEnabled ? Colors.blue : Colors.grey,
                    fontSize: Dimensions.font16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
