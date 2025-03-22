import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';

import 'package:rheel_estate/controllers/auth_controller.dart';
import 'package:rheel_estate/controllers/user_controller.dart';
import 'package:rheel_estate/routes/routes.dart';

import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import 'package:rheel_estate/widgets/profileImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;



  @override
  void initState() {
    loadUserMetadata();
    super.initState();
  }

  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();

  void logout() async {
    authController.logout();
  }

  void deleteAccount() async {
    bool? confirmDelete = await Get.dialog(
      AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete != true) {
      print("⚠️ Account deletion canceled by user.");
      return;
    }

    print("🔄 Attempting to delete account...");

    try {
      // ✅ Retrieve the auth token from appController
      String? token = await authController.getToken();

      if (token == null || token.isEmpty) {
        print("🚨 No token found. Redirecting to login.");
        Get.snackbar(
          'Authentication Error',
          'No authentication token found. Please log in again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      // ✅ Send request with token
      Response response = await authController.deleteAccount(token);

      if (response.statusCode == 200) {
        bool status = response.body["status"] ?? false;
        String message = response.body["message"] ?? "Unknown response";

        if (status) {
          print("✅ $message");

          // ✅ Clear authentication data and log out (ONLY IF SUCCESSFUL)
          await authController.clearToken(); // Clear token using appController
          authController.logout();

          Get.offAllNamed(AppRoutes.loginScreen);

          Get.snackbar(
            'Profile Successfully Deleted',
            message,
            snackPosition: SnackPosition.TOP,
            colorText: AppColors.white,
            backgroundColor: Colors.blue.withOpacity(0.8),
          );
        } else {
          print("❌ Account deletion failed: $message");

          Get.snackbar(
            'Deletion Failed',
            message,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red.withOpacity(0.8),
          );
        }
      } else if (response.statusCode == 401) {
        print("🔑 Unauthorized: ${response.body["message"]}");

        Get.snackbar(
          'Session Expired',
          'Your session has expired. Please log in again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );

        // ❌ Do NOT log out here unless absolutely necessary
      } else if (response.statusCode == 500) {
        print("❌ Server error: ${response.body["message"]}");

        Get.snackbar(
          'Server Error',
          'An error occurred while deleting your account. Please try again later.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        print(
            "❌ Unexpected error: ${response.statusCode} - ${response.body["message"]}");

        Get.snackbar(
          'Error',
          'Unexpected error occurred. Please try again later.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (e is TimeoutException) {
        print("⏳ Server timeout: $e");

        Get.snackbar(
          "Server Timeout",
          "The server took too long to respond. Please try again later.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (e is SocketException) {
        print("📡 No internet: $e");

        Get.snackbar(
          "No Internet",
          "Please check your internet connection and try again.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        print("❌ Unknown error: $e");

        Get.snackbar(
          "Error",
          "An unexpected error occurred. Please try again later.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> loadUserMetadata() async {
    print("🔄 Loading user metadata...");

    // Step 1: Reset username to avoid carrying over old data
    setState(() {
      username = "User"; // Default username
    });

    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');

    if (userJson != null) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        if (userMap.containsKey("name") && userMap["name"] != null) {
          setState(() {
            username = userMap["name"];
          });
          print("🟢 Using Regular Sign-In Name: $username");
          return;
        }
      } catch (e) {
        print("❌ Error parsing stored user data: $e");
      }
    }

    // Step 2: Only check Google Sign-In if no regular sign-in details are found
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
      if (googleUser != null && username == "User") { // Ensure regular sign-in isn't overwritten
        setState(() {
          username = googleUser.displayName ?? 'Google User';
        });
        print("🟢 Using Google Account Name: $username");
        return;
      }
    } catch (e) {
      print("❌ Error fetching Google user: $e");
    }

    // Step 3: Check Apple Sign-In (iOS/macOS)
    if (Platform.isIOS || Platform.isMacOS) {
      try {
        final credentialState = await SignInWithApple.getCredentialState(
          prefs.getString('appleUserId') ?? '',
        );
        if (credentialState == CredentialState.authorized && username == "User") {
          setState(() {
            username = "Apple User";
          });
          print("🟢 Using Apple Sign-In Name: Apple User");
          return;
        }
      } catch (e) {
        print("❌ Error fetching Apple user: $e");
      }
    }

    print("🔹 Final Username to Display: $username");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: Dimensions.font25),
        ),
        centerTitle: true,
      ),
      body: Container(
        // alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.height24),
            //profile image
            Center(
              child: ProfileImage(size: Dimensions.height100),
            ),
            SizedBox(height: Dimensions.height15),
            InkWell(
              onTap: (){
                Get.toNamed(AppRoutes.heroScreen);
              },
              child: Text(
                "$username",
                style: TextStyle(
                    fontSize: Dimensions.font18, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: Dimensions.height24),

            //settings
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account Settings',
                style: TextStyle(
                    fontSize: Dimensions.font18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            ),
            InkWell(
              onTap: deleteAccount,
              child: Container(
                alignment: Alignment.centerLeft,
                height: Dimensions.height50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delete Account',
                      style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: Dimensions.iconSize16,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Clipboard.setData(
                  const ClipboardData(text: 'https://app.rheel.ng'),
                );
                Get.snackbar(
                  'Successful',
                  'Link Copied to Clipboard',
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  colorText: AppColors.white,
                );
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: Dimensions.height50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Share App',
                      style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: Dimensions.iconSize16,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
            ),
            //faq
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.faqScreen);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: Dimensions.height50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FAQ',
                      style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: Dimensions.iconSize16,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              height: Dimensions.height50,
              child: Text(
                'More',
                style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
            ),
            //about && privacy && toc
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.aboutUs);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: Dimensions.height50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'About us',
                      style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: Dimensions.iconSize16,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.privacyPolicy);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: Dimensions.height50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: Dimensions.iconSize16,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.termsAndConditions);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: Dimensions.height50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terms and Conditions',
                      style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: Dimensions.iconSize16,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
            ),

            //log out
            SizedBox(height: Dimensions.height40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                  alignment: Alignment.center,
                  height: Dimensions.height50,
                  // width: Dimensions.width100 * 1.5,
                  decoration: BoxDecoration(
                      gradient: AppColors.mainGradient,
                      borderRadius: BorderRadius.circular(Dimensions.radius30)),
                  child: InkWell(
                    onTap: (){
                      logout();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.logout,
                          size: Dimensions.iconSize20,
                          color: Colors.white,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text(
                          'L O G   O U T',
                          style: TextStyle(
                              fontSize: Dimensions.font20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height30),
            Center(
              child: InkWell(
                onTap: (){
                  Get.dialog(
                    AlertDialog(
                      title: Text("Confirm Exit"),
                      content: Text("Are you sure you want to leave the app?"),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(), // Close the dialog
                          child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () async {
                            Get.back(); // Close the dialog
                            final Uri url = Uri.parse("https://rheel.ng");
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              print("❌ Could not launch $url");
                            }
                          },
                          child: Text("Yes, Leave", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Powered by Rheel Estate Limited',
                  style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
