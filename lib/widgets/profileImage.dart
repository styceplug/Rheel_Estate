import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import '../utils/app_constants.dart';

class ProfileImage extends StatefulWidget {
  final double size;

  const ProfileImage({super.key, required this.size});

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  String? profilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Loads user profile data from SharedPreferences
  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // 🔹 Step 1: Clear any previously saved profile picture
    await prefs.remove("profile_picture");

    // 🔹 Step 2: Fetch user details

    String? savedProfilePicture = prefs.getString("profile_picture");


    // 🔹 Step 3: Check if user signed in with Google
    if (await _isGoogleSignIn()) {
      print("🔄 Fetching Google profile image...");
      await _loadGoogleProfilePicture();
      return;
    }

    // 🔸 Step 4: If a profile picture is found in SharedPreferences, use it
    if (savedProfilePicture != null && savedProfilePicture.isNotEmpty) {
      print("✅ Using saved profile picture.");
      setState(() {
        profilePicture = savedProfilePicture;
      });
      return;
    }

    // 🔹 Step 5: No profile image found, fallback to avatar
    print("⚠️ No profile picture found. Using default avatar.");
    setState(() {
      profilePicture = null;
    });
  }

  /// Checks if the user signed in using Google
  Future<bool> _isGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
    return googleUser != null;
  }

  /// Fetches Google profile picture and updates SharedPreferences
  Future<void> _loadGoogleProfilePicture() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
      if (googleUser != null && googleUser.photoUrl != null) {
        final prefs = await SharedPreferences.getInstance();

        // 🔹 Save new profile picture
        await prefs.setString('profile_picture', googleUser.photoUrl!);

        print("✅ Google profile picture updated: ${googleUser.photoUrl}");

        // 🔥 Force UI to update
        if (mounted) {
          setState(() {
            profilePicture = googleUser.photoUrl!;
          });
        }
        return;
      }
    } catch (e) {
      print("❌ Error fetching Google user: $e");
    }

    print("⚠️ Google profile picture not available.");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withOpacity(0.5),
          width: Dimensions.width5 / Dimensions.width5,
        ),
      ),
      child: ClipOval(
        child: profilePicture != null && profilePicture!.isNotEmpty
            ? Image.network(profilePicture!, fit: BoxFit.cover, key: UniqueKey()) // 🔥 Forces UI update
            : Image.asset(AppConstants.getGifAsset('avatar'), fit: BoxFit.cover),
      ),
    );
  }
}