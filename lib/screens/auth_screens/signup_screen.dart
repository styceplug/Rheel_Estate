import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/auth/auth_service.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import 'package:rheel_estate/widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  bool isVisible = false;
  bool isConfirmVisible = false;
  bool tickTerms = false;
  String passwordStrengthMessage = ""; // Declare this variable

  void acceptTerms() {
    setState(() {
      tickTerms = !tickTerms;
    });
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

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final authService = AuthService();

  void signUp() async {
    final name = nameController.text;
    final email = emailController.text;
    final number = numberController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        number.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Invalid Input',
        'Please fill out all fields.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return;
    }

    if (!tickTerms) {
      Get.snackbar(
        'Terms and Conditions',
        'You must accept the terms and conditions to continue.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return;
    }

    try {
      await authService.signUpWithEmailPassword(email, password);

      Get.offNamed(AppRoutes.floatingBar);
      Get.snackbar(
        'Sign-Up Successful',
        'Your account has been created successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Sign-Up Failed',
        'Error: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          autofillHints: [AutofillHints.newPassword],
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
            /* InkWell(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: passwordController.text),
                );
                Get.snackbar(
                  'Copied',
                  'Password copied to clipboard',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green.withOpacity(0.8),
                  colorText: Colors.white,
                );
              },
              child: Text('Copy Password',style: TextStyle(fontSize: Dimensions.font13,fontWeight: FontWeight.w300,color: Colors.red),),
            ),*/
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
          autofillHints: [AutofillHints.newPassword],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    alignment: Alignment.center,
                    height: Dimensions.height33,
                    width: Dimensions.width33,
                    decoration: BoxDecoration(
                        color: AppColors.accentColor.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20)),
                    child: Icon(CupertinoIcons.chevron_back)),
              ),
              SizedBox(height: Dimensions.height50),
              Text(
                'Create your account',
                style: TextStyle(
                    fontSize: Dimensions.font18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: Dimensions.height40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                        fontSize: Dimensions.font14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: Dimensions.height5),
                  AuthTextField(
                      controller: nameController, hintText: 'ex. Jon Smith'),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                        fontSize: Dimensions.font14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: Dimensions.height5),
                  AuthTextField(
                      controller: emailController,
                      hintText: 'example@gmail.com'),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number',
                    style: TextStyle(
                        fontSize: Dimensions.font14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: Dimensions.height5),
                  AuthTextField(
                    controller: numberController,
                    hintText: 'Enter Valid Phone Number',
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              buildPasswordField(),
              SizedBox(height: Dimensions.height20),
              buildConfirmPasswordField(),
              SizedBox(height: Dimensions.height20),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        acceptTerms();
                      });
                    },
                    child: Icon(!tickTerms
                        ? Icons.circle_outlined
                        : CupertinoIcons.check_mark_circled),
                  ),
                  SizedBox(width: Dimensions.width5),
                  Row(
                    children: [
                      Text(
                        'I understand the',
                        style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w400),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.privacyPolicy);
                        },
                        child: Text(
                          ' terms & Policy',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: Dimensions.height20),
              //sign up btn
              InkWell(
                onTap: isLoading ? null : signUp,
                child: Container(
                  alignment: Alignment.center,
                  height: Dimensions.height54,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      gradient: !isLoading
                          ? AppColors.mainGradient
                          : AppColors.blackGradient,
                      borderRadius: BorderRadius.circular(Dimensions.radius30)),
                  child: Text(
                    !isLoading ? 'SIGN UP' : 'Processing',
                    style: TextStyle(
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white),
                  ),
                ),
              ),
              //log in option
              SizedBox(height: Dimensions.height20),
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.loginScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have an account?',
                      style: TextStyle(fontSize: Dimensions.font15),
                    ),
                    SizedBox(width: Dimensions.width10),
                    Text(
                      'Log in',
                      style: TextStyle(
                          fontSize: Dimensions.font15,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      showCursor: true,
      cursorColor: AppColors.blackColor.withOpacity(0.6),
      decoration: InputDecoration(
        alignLabelWithHint: false,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height15,
        ),
        hintText: hintText,
        prefixIcon: prefixIcon,
        labelStyle:
            TextStyle(color: AppColors.blackColor, fontSize: Dimensions.font14),
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
    );
  }
}
