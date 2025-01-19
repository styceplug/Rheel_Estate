import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rheel_estate/auth/auth_service.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import 'package:rheel_estate/widgets/profileImage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.height30),
            //profile image
            Center(
              child: ProfileImage(size: Dimensions.height100),
            ),
            SizedBox(height: Dimensions.height24),

            //settings
            Text(
              'Account Settings',
              style: TextStyle(
                  fontSize: Dimensions.font18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
            Container(
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
            Container(
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
                    onTap: logout,
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
            InkWell(
              onTap: (){},
              child: Center(
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
