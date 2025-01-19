import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height20 * 9.5),
              //texts
              Text(
                'DESIGNED FOR NIGERIANS',
                style: TextStyle(
                    fontSize: Dimensions.font22, fontWeight: FontWeight.w500),
              ),
              Text(
                'HOME AND ABROAD',
                style: TextStyle(
                    fontSize: Dimensions.font25, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: Dimensions.height50),
              Text(
                '🏠 Search with Confidence ❤️Save your favourites',
                style: TextStyle(
                    fontSize: Dimensions.font13, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                '💰Save on Fees 🌎Available Worldwide',
                style: TextStyle(
                    fontSize: Dimensions.font13, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: Dimensions.height10 * 7.5,
              ),

              //image
              Container(
                height: Dimensions.height100 * 4.8,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.03),
                      offset: const Offset(0, -5),
                      blurRadius: Dimensions.radius5,
                      spreadRadius: Dimensions.radius5 / Dimensions.radius5,
                    )
                  ],
                  border: Border.all(
                      color: AppColors.blackColor,
                      width: Dimensions.width5 / Dimensions.width10),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimensions.radius45),
                    topLeft: Radius.circular(Dimensions.radius45),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(
                      AppConstants.getPngAsset('onboarding1'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: Dimensions.width10 * 6.5,
          bottom: Dimensions.height65,
          child: InkWell(
            onTap: () {
              Get.offNamed(AppRoutes.loginScreen);
            },
            child: Container(
              alignment: Alignment.center,
              width: Dimensions.width100 * 3,
              height: Dimensions.height50,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius45)),
              child: Text(
                'Next',
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: Dimensions.font17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
