import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:rheel_estate/utils/dimensions.dart';

class HeroWidget extends StatefulWidget {
  const HeroWidget({super.key});

  @override
  State<HeroWidget> createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          margin: EdgeInsets.symmetric(
              vertical: Dimensions.height20, horizontal: Dimensions.width20),
          child: Column(
            children: [
              Container(
                height: Dimensions.height240 * 2.2,
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    AppConstants.getPngAsset('bghome'),
                  ),
                )),
              ),
              Text(
                'Fall in Love with Coffee in Blissful Delight!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font30 * 1.2,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Welcome to our cozy coffee corner, where every cup is a delightful for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font17,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              SizedBox(height: Dimensions.height20),
              InkWell(
                onTap: (){
                  Get.toNamed(AppRoutes.next);
                },
                child: Container(
                  height: Dimensions.height65,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
