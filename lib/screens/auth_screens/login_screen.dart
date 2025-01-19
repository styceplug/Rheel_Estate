import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rheel_estate/auth/auth_service.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/screens/auth_screens/signup_screen.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import 'package:rheel_estate/widgets/custom_textfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //google signIn
  String? userId;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          userId = data.session?.user.id;
        });
      }
    });
  }

  @override
  void dispose() {

    super.dispose();
  }


  bool rememberMe = false;
  bool isLoading = false; // Tracks login state

  void checkBox() {
    rememberMe = !rememberMe;
  }

  //get auth service
  final authService = AuthService();

  //text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //login func
  void login() async {
    //prepare data
    final email = emailController.text;
    final password = passwordController.text;

    setState(() {
      isLoading = true; // Start loading
    });

    //attempt login
    try {
      await authService.signInWithEmailPassword(email, password);



      // Navigate or show success message after successful login
      Get.offNamed(AppRoutes.floatingBar);
    } catch (e) {
      String errorMessage;

      // More defined error messages
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'No user found with this email.';
      } else if (e.toString().contains('invalid_credentials')) {
        errorMessage = 'Incorrect password or email. Please try again.';
      } else if (e.toString().contains('invalid_email')) {
        errorMessage = 'Invalid email address. Please check and try again.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again later.';
      }

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Invalid Input',
          'Please fill out all fields.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
        return;
      }

      if (mounted) {
        // Show Get.snackbar with the error message
        Get.snackbar(
          'Login Failed',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
      }
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    }
  }

  //google sign in
  /*Future<AuthResponse> googleSignIn() async {
    const webClientId = '752868949038-690r4hel1srgq8otl91obbdn8b2m8gdl.apps.googleusercontent.com';
    const iosClientId = '752868949038-3vjd46cje2r04qfca2hj7vubbbr5068a.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
      clientId: iosClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;


    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );



  }*/

  Future<void> googleSignIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      const webClientId =
          '752868949038-690r4hel1srgq8otl91obbdn8b2m8gdl.apps.googleusercontent.com';
      const iosClientId =
          '752868949038-3vjd46cje2r04qfca2hj7vubbbr5068a.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        clientId: iosClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // Sign-in was canceled
        print('Google Sign-In canceled.');
        if (mounted) {
          setState(() {
            isLoading =false;
          });
        }
        return;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Failed to retrieve access token or ID token.');
      }

      // Authenticate with Supabase
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      Get.snackbar(
        'Successful',
        'Sign in Successful',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Iconsax.tick_circle, color: Colors.white),
      );

      print('Sign-in successful: ${response.session?.user?.email}');

      if (response.session != null) {
        // Navigate to home screen
        Get.offNamed(
            AppRoutes.floatingBar); // Replace with your home screen route
      } else {
        print('Failed to retrieve session after Google Sign-In.');
      }
    } catch (e) {
      // Handle errors
      print('Google Sign-In error: $e');
      Get.snackbar(
        'Sign-In Failed',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  //anonymous sign in

  void signInAsGuest() async {
    setState(() {
      isLoading=true;
    });
    try {
      final response = await supabase.auth.signInAnonymously();
      final user = response.user;
      if (user != null) {
        Get.offNamed(AppRoutes.guestFloatingBar);
        Get.snackbar('Successful', 'You are signed in as a Guest',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.blue.withOpacity(0.8),
            colorText: Colors.white,
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ));
      }
    } catch (e) {
      Get.snackbar('Error', "Failed to sign in as Guest. Please try again $e",
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

  void visiblePass(){
    isVisible =! isVisible;
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
                      Text(isLoading? 'Signing in as Guest...' :
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
                  autofillHints: [AutofillHints.email],
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
                  autofillHints: [AutofillHints.password],
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
                      onTap: (){
                        setState(() {
                          visiblePass();
                        });
                      },
                      child: Icon(isVisible? Icons.visibility : Icons.visibility_off),
                    ),
                    hintText: 'Input Password',
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      size: Dimensions.iconSize20,
                      color: AppColors.blackColor.withOpacity(0.6),
                    ),
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
                              checkBox();
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
                    Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: Dimensions.font15),
                    ),
                  ],
                ),
                //login btn
                SizedBox(height: Dimensions.height43),
                InkWell(
                  onTap: isLoading ? null : login, // Disable button when loading
                  child: Container(
                    alignment: Alignment.center,
                    height: Dimensions.height54,
                    width: double.maxFinite,
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
                    Container(
                      height: Dimensions.height5 / Dimensions.height10,
                      width: Dimensions.width100 * 1.5,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(width: Dimensions.width20),
                    Text('OR'),
                    SizedBox(width: Dimensions.width20),
                    Container(
                      height: Dimensions.height5 / Dimensions.height10,
                      width: Dimensions.width100 * 1.5,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height50),
                InkWell(
                  onTap: showComingSoonToast,
                  child: Container(
                    alignment: Alignment.center,
                    height: Dimensions.height54,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: AppColors.blackColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius30)),
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
                            /*image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(
                                AppConstants.getPngAsset('apple'),
                              ),
                            ),*/
                          ),
                          child: Icon(Icons.apple),
                        ),
                        SizedBox(width: Dimensions.width20),
                        Text(
                          'Continue with Apple',
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
                    Container(
                      child: InkWell(
                        onTap: googleSignIn,
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
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/google.png',
                                    ),
                                  ),
                                ),
                              ),
                              Text( isLoading? 'Please wait..':
                                'Google',
                                style: TextStyle(
                                    fontSize: Dimensions.font14,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //facebook
                    InkWell(
                      onTap: showComingSoonToast,
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
                      )
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
