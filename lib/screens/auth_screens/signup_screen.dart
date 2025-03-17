import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/controllers/auth_controller.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';

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

  final authController = Get.find<AuthController>();

  // final authService = AuthService();

  void signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final number = numberController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    print("🛠️ Debugging:");
    print("➡️ Name: $name");
    print("➡️ Email: $email");
    print("➡️ Phone: $number");
    print("➡️ Password: '${password.isEmpty ? '🚨 EMPTY' : password}'");
    print("➡️ Confirm Password: '${confirmPassword.isEmpty ? '🚨 EMPTY' : confirmPassword}'");

    // ✅ Field Validation
    if (name.isEmpty || email.isEmpty || number.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showSnackbar('Missing Fields', 'Please fill out all required fields.', Colors.red);
      return;
    }

    // ✅ Email Validation
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      showSnackbar('Invalid Email', 'Please enter a valid email address.', Colors.red);
      return;
    }

    // ✅ Phone Number Validation (10-15 digits)
    if (!RegExp(r"^[0-9]{10,15}$").hasMatch(number)) {
      showSnackbar('Invalid Phone Number', 'Enter a valid phone number (10-15 digits).', Colors.red);
      return;
    }

    // ✅ Password Strength Validation
    if (password.length < 6) {
      showSnackbar('Weak Password', 'Password must be at least 6 characters long.', Colors.red);
      return;
    }

    // ✅ Password Match Check
    if (password != confirmPassword) {
      showSnackbar('Password Mismatch', 'Passwords do not match.', Colors.red);
      return;
    }

    // ✅ Terms & Conditions Check
    if (!tickTerms) {
      showSnackbar('Terms & Conditions', 'You must accept the terms and conditions.', Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print("📤 Sending signup request...");

      Response response = await authController.signup(
        fullName: name,
        phoneNumber: number,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      print("📥 API Response: ${response.body}");

      // ✅ Handle API Response Based on Status Code
      if (response.statusCode == 201 && response.body['status'] == true) {
        // 🔥 Save Token
        String? token = response.body['data']['token'];
        if (token != null) {
          authController.setToken(token);
          print("🔑 Token saved successfully!");
        }

        showSnackbar('Success 🎉', 'Welcome, ${response.body['data']['name']}!', Colors.green);
        Get.offAllNamed(AppRoutes.floatingBar);
      } else if (response.statusCode == 400) {
        showSnackbar('Invalid Input ❌', response.body['message'] ?? 'Check your input and try again.', Colors.orange);
      } else if (response.statusCode == 409) {
        showSnackbar('Email Already Exists 🚨', response.body['message'] ?? 'This email is already registered.', Colors.red);
      } else if (response.statusCode == 500) {
        showSnackbar('Server Error 🛠️', 'Something went wrong. Try again later.', Colors.red);
      } else {
        showSnackbar('Unexpected Error ❗', 'An unknown error occurred.', Colors.red);
      }
    } catch (e) {
      print("❌ Signup error: $e");
      showSnackbar('Network Error 🌐', 'Check your internet and try again.', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// ✅ Snackbar Helper Function
  void showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color.withOpacity(0.8),
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  void verifyForm() async {
    await authController.signup(
      fullName: nameController.text.trim(),
      phoneNumber: numberController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
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
          // autofillHints: [AutofillHints.newPassword],
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
                width: Dimensions.width5 / Dimensions.width15,
                color: AppColors.blackColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width15,
                color: AppColors.blackColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width15,
                color: AppColors.blackColor,
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
                width: Dimensions.width5 / Dimensions.width15,
                color: AppColors.blackColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width15,
                color: AppColors.blackColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: Dimensions.width5 / Dimensions.width15,
                color: AppColors.blackColor,
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
                    child: const Icon(CupertinoIcons.chevron_back)),
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
                onTap: isLoading ? null : verifyForm,
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
            width: Dimensions.width5 / Dimensions.width15,
            color: AppColors.blackColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          borderSide: BorderSide(
            width: Dimensions.width5 / Dimensions.width15,
            color: AppColors.blackColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          borderSide: BorderSide(
            width: Dimensions.width5 / Dimensions.width15,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
