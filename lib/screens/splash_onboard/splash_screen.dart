import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Simulate splash screen duration
    await Future.delayed(const Duration(seconds: 3));

    // Check if the user is opening the app for the first time
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Mark as not first time for future launches
      await prefs.setBool('isFirstTime', false);
      Get.offAllNamed(AppRoutes.onboardingScreenRedesigned);
    } else {
      // Navigate to AuthGate for session management
      Get.offAllNamed(AppRoutes.authGate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: Dimensions.height12 * 15,
          width: Dimensions.width20 * 15,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AppConstants.getPngAsset('logoSplash'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}