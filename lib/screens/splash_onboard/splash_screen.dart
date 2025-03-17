import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:rheel_estate/controllers/auth_controller.dart';
import 'package:rheel_estate/controllers/user_controller.dart';
import 'package:rheel_estate/models/user_model.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Animation Controller
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    // ✅ Check internet before proceeding
    _checkInternetAndProceed();
  }

  /// 🔹 Checks internet connection and proceeds accordingly
  Future<void> _checkInternetAndProceed() async {
    print("🔍 Checking internet connection...");

    bool hasInternet = await InternetConnectionChecker.createInstance().hasConnection;

    if (hasInternet) {
      print("✅ Internet is available. Proceeding with initialization...");
      _initialize();
    } else {
      print("❌ No internet connection. Showing dialog...");
      _showNoInternetDialog();
    }
  }

  /// 🔹 Authentication & Routing Logic
  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate splash delay

    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      Get.offAllNamed(AppRoutes.onboardingScreenRedesigned);
      return;
    }

    // ✅ Check "Remember Me" preference
    bool remember = await Get.find<AuthController>().getRemember();
    if (remember) {
      Get.find<UserController>().loadUser();
      Get.offAllNamed(AppRoutes.floatingBar);
      return;
    }

    // ✅ Check JWT Token (User logged in before)
    final String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      Get.find<UserController>().loadUser();
      Get.offAllNamed(AppRoutes.floatingBar);
      return;
    }

    // ✅ Check Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser =
      await googleSignIn.signInSilently();
      if (googleUser != null) {
        Get.find<UserController>().saveUser(UserModel(
          id: int.tryParse(googleUser.id) ?? 0,
          phoneNumber: '',
          email: googleUser.email,
          name: googleUser.displayName ?? 'Google User',
        ));
        Get.offAllNamed(AppRoutes.floatingBar);
        return;
      }
    } catch (e) {
      print("❌ Google Sign-In check failed: $e");
    }

    // ✅ Check Apple Sign-In (iOS/macOS)
    if (Platform.isIOS || Platform.isMacOS) {
      try {
        final credentialState = await SignInWithApple.getCredentialState(
            prefs.getString('appleUserId') ?? '');
        if (credentialState == CredentialState.authorized) {
          Get.offAllNamed(AppRoutes.floatingBar);
          return;
        }
      } catch (e) {
        print("❌ Apple Sign-In check failed: $e");
      }
    }

    // ✅ Default: Go to Login Screen
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  /// 🔹 Show No Internet Dialog
  void _showNoInternetDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        title: Text(
          "No Internet Connection",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: Dimensions.font20),
        ),
        content: Text(
          "Please check your internet and try again.",
          style: TextStyle(fontSize: Dimensions.font14),
        ),
        actions: [
          InkWell(
            onTap: () => Get.back(),
            child: Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          SizedBox(width: Dimensions.width10),
          InkWell(
            onTap: () {
              Get.back();
              _checkInternetAndProceed(); // Retry connection check
            },
            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height5,
                    horizontal: Dimensions.width10),
                decoration: BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius5),
                ),
                child: Text(
                  "Retry",
                  style: TextStyle(
                      color: AppColors.white, fontSize: Dimensions.font15),
                )),
          ),
        ],
      ),
      barrierDismissible: false, // Prevents closing by tapping outside
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Centered Logo & Text
          Expanded(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppConstants.getPngAsset('logoSplash'),
                      // 🔹 Your app logo
                      height: Dimensions.height100,
                    ),
                    SizedBox(height: Dimensions.height5),

                  ],
                ),
              ),
            ),
          ),

          // 🔹 Bouncing Dots Indicator (Bottom of screen)
          Padding(
            padding: EdgeInsets.only(bottom: Dimensions.height50),
            child: BouncingDotsIndicator(),
          ),
        ],
      ),
    );
  }
}

class BouncingDotsIndicator extends StatefulWidget {
  final Color color;
  final double dotSize;
  final double spacing;

  const BouncingDotsIndicator({
    super.key,
    this.color = AppColors.accentColor,
    this.dotSize = 10.0,
    this.spacing = 8.0,
  });

  @override
  _BouncingDotsIndicatorState createState() => _BouncingDotsIndicatorState();
}

class _BouncingDotsIndicatorState extends State<BouncingDotsIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      4,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..repeat(reverse: true, period: const Duration(milliseconds: 800)),
    );

    _animations = _controllers
        .map((controller) =>
            Tween<double>(begin: 0, end: 10.0).animate(controller))
        .toList();

    // 🔹 Delay each dot's animation for a wave effect
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              child: Transform.translate(
                offset: Offset(0, -_animations[index].value),
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
