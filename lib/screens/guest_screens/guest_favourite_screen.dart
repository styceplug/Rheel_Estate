import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/routes/routes.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class GuestFavouriteScreen extends StatefulWidget {
  const GuestFavouriteScreen({super.key});

  @override
  State<GuestFavouriteScreen> createState() => _GuestFavouriteScreenState();
}

class _GuestFavouriteScreenState extends State<GuestFavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Dimensions.height50 * 1.7,
        centerTitle: true,
        leadingWidth: Dimensions.width70,
        automaticallyImplyLeading: false,
        title: Text(
          'Favourites',
          style: TextStyle(
              fontSize: Dimensions.font22, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height20),
          margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          height: Dimensions.height20 * 14,
          decoration: BoxDecoration(
              gradient: AppColors.mainGradient,
              borderRadius: BorderRadius.circular(Dimensions.radius20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Unlock More with an Account!!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.font22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Sign up now to explore this feature and enjoy personalized property recommendations, save your favorites, and get real-time updates.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(height: Dimensions.height20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.signupScreen); // Navigate to Sign Up
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Dimensions.height50,
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.width10),
                      decoration: BoxDecoration(
                        color: AppColors.accentColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width20),
                  InkWell(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.guestFloatingBar); // Navigate back
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Dimensions.height50,
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.width10),
                      decoration: BoxDecoration(
                        color: AppColors.accentColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
