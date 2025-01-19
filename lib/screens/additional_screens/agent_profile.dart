import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:rheel_estate/utils/dimensions.dart';

import '../../utils/colors.dart';

class AgentProfile extends StatefulWidget {
  const AgentProfile({super.key});

  @override
  State<AgentProfile> createState() => _AgentProfileState();
}

class _AgentProfileState extends State<AgentProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Owner Profile',
          style: TextStyle(
              fontSize: Dimensions.font20, fontWeight: FontWeight.w600),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              SizedBox(width: Dimensions.width20),
              Container(
                alignment: Alignment.center,
                height: Dimensions.height33,
                width: Dimensions.width33,
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: const Icon(CupertinoIcons.chevron_back),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: Dimensions.height150,
              width: Dimensions.width15 * 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentColor),
                image: DecorationImage(
                  image: AssetImage(
                    AppConstants.getPngAsset('logo'),
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'RHEEL ESTATE',
              style: TextStyle(
                  fontSize: Dimensions.font18, fontWeight: FontWeight.w500),
            ),
            Text(
              'Property Owner',
              style: TextStyle(
                  fontSize: Dimensions.font14, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
