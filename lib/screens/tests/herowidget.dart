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
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: Dimensions.height20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.height100),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
                child: Text(
                  'It is Okay to Not be Okay!!',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: Dimensions.font30 * 1.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: Dimensions.height30),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: Dimensions.height50,
                    right: 0,
                    child: Container(
                      height: Dimensions.height100 * 4,
                      width: Dimensions.width100 * 6.5,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CupertinoColors.lightBackgroundGray
                              .withOpacity(0.6)),
                    ),
                  ),
                  Container(
                    height: Dimensions.height240 * 2.8,
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          AppConstants.getPngAsset('201'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: Dimensions.height100,
                    child: InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.next);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: Dimensions.height10 * 8.5,
                        width: Dimensions.width100 * 3.5,
                        margin:
                            EdgeInsets.symmetric(horizontal: Dimensions.width50),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                        ),
                        child: Text(
                          'Let Us Help You',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.font25,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


