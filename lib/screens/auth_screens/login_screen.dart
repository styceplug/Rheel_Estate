import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rheel_estate/controllers/auth_controller.dart';
import 'package:rheel_estate/controllers/user_controller.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import 'package:rheel_estate/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  UserController userController = Get.find<UserController>();

  //get auth service
  final authController = Get.find<AuthController>();

  //text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //bool
  bool rememberMe = true;
  bool isLoading = false;


  Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }



  void remember(){
    rememberMe = !rememberMe;
  }

  @override
  void initState() {
    super.initState();

  }




  //login func
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      isLoading = true;
    });

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Invalid Input',
        'Please fill out all fields.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      Response response = await authController.login(
        username: email,
        password: password,
        remember: rememberMe,
      );

      int statusCode = response.statusCode ?? 500;
      String message = response.body?["message"] ?? "An error occurred";

      if (statusCode == 200) {
        bool status = response.body?["status"] ?? false;
        String? token = response.body?["token"];
        Map<String, dynamic>? user = response.body?["user"];

        if (status && token != null && user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          // Step 1: Save Auth Token
          await prefs.setString("auth_token", token);

          // Step 2: Save User Data
          await prefs.setString("user", jsonEncode(user));

          // Step 3: Clear previous Google/Apple user data
          await prefs.remove("googleUser");
          await prefs.remove("appleUser");

          print("✅ Token saved: $token");
          print("✅ User data saved: ${user['name']}");

          Get.offAllNamed(AppRoutes.floatingBar);
          Get.snackbar(
            'Login Successful',
            'Enjoy your time here, ${user['name']}!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        } else {
          print(message);
          Get.snackbar(
            'Login Failed',
            'Please try again later.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      } else if (statusCode == 400) {
        Get.snackbar(
          'Login Failed',
          'Invalid email or password.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      } else if (statusCode == 401) {
        Get.snackbar(
          'Login Failed',
          'Invalid email. Please check and try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          icon: const Icon(Icons.warning, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Login Failed',
          'Unexpected error occurred. Please try again later.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      String errorMessage = 'An unexpected error occurred. Please try again later.';

      if (e.toString().contains('user-not-found')) {
        errorMessage = 'No user found with this email.';
      } else if (e.toString().contains('invalid_credentials')) {
        errorMessage = 'Incorrect email or password. Please try again.';
      } else if (e.toString().contains('invalid_email')) {
        errorMessage = 'Invalid email address. Please check and try again.';
      }

      Get.snackbar('Login Failed', errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );

      print("❌ Exception: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? userId;


  void printLongString(String text) {
    const int chunkSize = 1000; // Adjust chunk size as needed
    for (int i = 0; i < text.length; i += chunkSize) {
      print(text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
  }

  //google

  Future<void> googleSignIn() async {
    const webClientId = '752868949038-690r4hel1srgq8otl91obbdn8b2m8gdl.apps.googleusercontent.com';
    const iosClientId = '752868949038-3vjd46cje2r04qfca2hj7vubbbr5068a.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
      clientId: iosClientId,
    );

    isLoading = true; // ✅ Start loading

    try {
      print("Starting Google Sign-In...");

      final googleUser = await googleSignIn.signIn();
      print("Google User Object: $googleUser");

      if (googleUser == null) {
        throw 'Google sign-in canceled by user.';
      }

      /*print("Google User Email: ${googleUser.email}");
      print("Google User Display Name: ${googleUser.displayName}");
      print("Google User ID: ${googleUser.id}");
      print("Google User Photo URL: ${googleUser.photoUrl}");*/

      final googleAuth = await googleUser.authentication;
      print("Google Authentication Object: $googleAuth");

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw 'Failed to retrieve authentication token.';
      }

      printLongString("📢 ID Token received: $idToken");
      printLongString("📢 Access Token received: $accessToken");

      // Send token to the backend
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}/user/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken, 'email': googleUser.email}),
      );

      print("Backend Response Status Code: ${response.statusCode}");
      print("Backend Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Decoded Backend Response: $responseBody");

        if (responseBody['status'] == true) {
          final user = responseBody['user'];
          final String? token = responseBody['token'];
          await saveUserToken(token!);

          print("User Object from Backend: $user");
          print("User Name: ${user['name'] ?? 'N/A'}");
          print("User Email: ${user['email'] ?? 'N/A'}");
          print("User Phone Number: ${user['phone_number'] ?? 'N/A'}");
          print("JWT Token: $token");

          // Save token and user details securely
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('user_name', user['name'] ?? '');
          await prefs.setString('user_email', user['email'] ?? '');
          await prefs.setString('user_phone', user['phone_number'] ?? '');
          await prefs.setString('profile_picture', user['profile_picture'] ?? '');

          print('User signed in successfully: ${user['name']}');
          printLongString('User signed in successfully: $token');

          Get.snackbar(
            "Success",
            "Signed in successfully as ${user['name'] ?? 'User'}",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Get.offAllNamed(AppRoutes.floatingBar);
        } else {
          throw 'Authentication failed: ${responseBody['message']}';
        }
      } else {
        throw 'Failed to authenticate with the backend: ${response.body}';
      }
    } catch (e) {
      print('Google Sign-In failed: $e');

      Get.snackbar(
        "Error",
        'Sign in with google failed',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false; // ✅ Stop loading
    }
  }

  //anonymous sign in
  void signInAsGuest() async {
    setState(() {
      isLoading = true;
    });
    try {
        Get.offNamed(AppRoutes.guestFloatingBar);
        Get.snackbar('Successful', 'You are signed in as a Guest',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.blue.withOpacity(0.8),
            colorText: Colors.white,
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ));

    } catch (e) {
      Get.snackbar('Error', "Failed to sign in as Guest. Please try again ",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white));
      print('$e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Toast for "Coming Soon"
  void showComingSoonToast() {
    Get.snackbar(
      'Feature Coming Soon',
      'This feature is not available yet.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  bool isVisible = true;

  void visiblePass() {
    isVisible = !isVisible;
  }

  //apple sign in

  Future<void> appleSignIn() async {
    isLoading = true; // ✅ Start loading

    try {
      print("🔄 Starting Apple Sign-In...");

      // Generate nonce
      final rawNonce = generateNonce();
      final sha256Nonce = sha256.convert(utf8.encode(rawNonce)).toString();
      print("✅ Nonce generated: $rawNonce");

      // Request Apple Sign-In credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: sha256Nonce,
      );

      if (credential.identityToken == null) {
        print("❌ Apple Sign-In failed: No identity token received.");
        Get.snackbar(
          'Error',
          'Apple Sign-In failed: No identity token.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      print("✅ Apple credential received: ${credential.email ?? "No email"}");

      // Prepare request body in the correct format
      final requestBody = jsonEncode({
        "provider": "apple",
        "response": {
          "identityToken": credential.identityToken,
          "user": {
            "name": {
              "firstName": credential.givenName ?? "",
              "lastName": credential.familyName ?? "",
            },
            "email": credential.email ?? "",
          }
        }
      });

      print("📨 Prepared requestBody: $requestBody");

      // Prepare request to backend
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.APPLE_SIGNIN}'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print("Identity token: ${credential.identityToken}");
      print("📡 Sending token to backend: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData["token"] ?? credential.identityToken;
        await saveUserToken(token);


        Get.offAllNamed(AppRoutes.floatingBar);
        print("✅ Apple Sign-In successful!");
        Get.snackbar(
          'Success',
          'Signed in with Apple Successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        print("❌ Backend authentication failed. Response: ${response.body}");
        Get.snackbar(
          'Error',
          'Sorry we cant sign you in at the moment',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e, stacktrace) {
      print("🚨 Exception occurred: $e");
      print(stacktrace);
      Get.snackbar(
        'Error',
        'Sorry we cant sign you in at the moment',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading = false; // ✅ Stop loading
    }
  }
// Generate a cryptographically secure nonce
  String generateNonce({int length = 32}) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  //facebook sign in

  Future<void> facebookSignIn() async {

    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
    } else{
      print(result.status);
      print(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height20),
          child: AutofillGroup(
            child: Column(
              children: [
                SizedBox(height: Dimensions.height50 * 1.5),
                //guest login
                InkWell(
                  onTap: signInAsGuest,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(isLoading ? 'Signing in as Guest...' :
                      'Continue as Guest',
                        style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        Icons.arrow_forward_outlined,
                        size: Dimensions.iconSize20,
                      )
                    ],
                  ),
                ),
                //login form
                SizedBox(height: Dimensions.height50 * 1.5),
                Text(
                  'Enter your Login Information',
                  style: TextStyle(
                      fontSize: Dimensions.font20, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: Dimensions.height30),
                CustomTextField(
                  // autofillHints: [AutofillHints.email],
                  controller: emailController,
                  hintText: 'Enter Your Email',
                  labelText: 'Email Address',
                  prefixIcon: Icon(
                    Icons.email,
                    color: AppColors.blackColor.withOpacity(0.3),
                    size: Dimensions.iconSize20,
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                TextField(
                  // autofillHints: [AutofillHints.password],
                  controller: passwordController,
                  obscureText: !isVisible,
                  showCursor: true,
                  cursorColor: AppColors.blackColor.withOpacity(0.6),
                  decoration: InputDecoration(
                    alignLabelWithHint: false,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                      vertical: Dimensions.height15,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          visiblePass();
                        });
                      },
                      child: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off),
                    ),
                    hintText: 'Input Password',
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      size: Dimensions.iconSize20,
                      color: AppColors.blackColor.withOpacity(0.6),
                    ),
                    labelStyle:
                    TextStyle(color: AppColors.blackColor,
                        fontSize: Dimensions.font14),
                    hintStyle: TextStyle(
                      color: AppColors.blackColor.withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      borderSide: BorderSide(
                        width: Dimensions.width5 / Dimensions.width10,
                        color: AppColors.blackColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      borderSide: BorderSide(
                        width: Dimensions.width5 / Dimensions.width10,
                        color: AppColors.blackColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      borderSide: BorderSide(
                        width: Dimensions.width5 / Dimensions.width10,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),

                ),
                SizedBox(height: Dimensions.height20),
                //remember me && forgot pass
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              remember();

                            });
                          },
                          child: Icon(
                            !rememberMe
                                ? Icons.circle_outlined
                                : Icons.check_circle_outline_sharp,
                            size: Dimensions.iconSize24,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text(
                          'Remember Me?',
                          style: TextStyle(fontSize: Dimensions.font15),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.forgotPassword);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: Dimensions.font15),
                      ),
                    ),
                  ],
                ),
                //login btn
                SizedBox(height: Dimensions.height43),
                InkWell(
                  onTap: isLoading ? null : login,
                  // Disable button when loading
                  child: Container(
                    alignment: Alignment.center,
                    height: Dimensions.height54,
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(
                      gradient: isLoading
                          ? AppColors.blackGradient
                          : AppColors.mainGradient,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                    child: Text(
                      isLoading ? 'Please wait...' : 'LOGIN', // Change text
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: Dimensions.font17,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                //other login methods
                SizedBox(height: Dimensions.height40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Expanded(
                      child: Container(
                        height: Dimensions.height5 / Dimensions.height10,
                        width: Dimensions.width100 * 1.5,
                        color: AppColors.blackColor,
                      ),
                    ),*/
                    SizedBox(width: Dimensions.width20),
                    const Text('OR'),
                    SizedBox(width: Dimensions.width20),
                    /*Container(
                      height: Dimensions.height5 / Dimensions.height10,
                      width: Dimensions.width100 * 1.5,
                      color: AppColors.blackColor,
                    ),*/
                  ],
                ),
                SizedBox(height: Dimensions.height50),
                InkWell(
                  onTap: (){
                    if(Platform.isAndroid) {
                      showComingSoonToast();
                    } else{
                      appleSignIn();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: Dimensions.height54,
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(
                        color: AppColors.blackColor,
                        borderRadius: BorderRadius.circular(
                            Dimensions.radius30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Dimensions.width33,
                          height: Dimensions.height33,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                            color: AppColors.white,

                          ),
                          child: const Icon(Icons.apple),
                        ),
                        SizedBox(width: Dimensions.width20),
                        Text(isLoading?
                           'Signing in with Apple..':'Continue with Apple',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: Dimensions.font17,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [


                    //google
                    InkWell(
                      onTap: googleSignIn,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width20),
                        height: Dimensions.height54,
                        width: Dimensions.width100 * 1.6,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.blackColor,
                                width: Dimensions.width5 /
                                    Dimensions.width20),
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: Dimensions.height30,
                              width: Dimensions.width30,
                              decoration: BoxDecoration(
                                color: AppColors.accentColor.withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(Dimensions.radius30),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/google.png',
                                  ),
                                ),
                              ),
                            ),
                            Text(isLoading ? 'Please wait..' :
                            'Google',
                              style: TextStyle(
                                  fontSize: Dimensions.font14,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),

                    //facebook
                    InkWell(
                      onTap: (){
                        if(Platform.isAndroid){
                          showComingSoonToast();
                        } else {
                          showComingSoonToast();
                        }
                      },
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width20),
                        height: Dimensions.height54,
                        width: Dimensions.width100 * 1.6,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.blackColor,
                                width: Dimensions.width5 / Dimensions.width20),
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: Dimensions.height30,
                              width: Dimensions.width30,
                              decoration: BoxDecoration(
                                color: AppColors.accentColor.withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(Dimensions.radius30),
                              ),
                              child: Icon(
                                Icons.facebook,
                                color: Colors.purpleAccent,
                                size: Dimensions.iconSize24,
                              ),
                            ),
                            Text(
                              'Facebook',
                              style: TextStyle(
                                  fontSize: Dimensions.font14,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height50),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.signupScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: Dimensions.font14),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: Dimensions.font14,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
