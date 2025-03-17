import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        toolbarHeight: Dimensions.height50 * 1.2,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'A B O U T  U S',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: Dimensions.font25),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20,vertical: Dimensions.height30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rheel App is the official, easy-to-use property search platform for Rheel Estate Limited, designed to help Nigerians worldwide find verified properties for sale and lease in Abuja, Nigeria. Whether you\'re a property owner, buyer, investor, or a Nigerian in the diaspora, the Rheel App provides a secure and transparent way to navigate the real estate market.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'What Makes Rheel App Different?',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'Unlike other real estate platforms, every property listed on Rheel App is 100% under our direct management—no external agents, no third-party listings, and no risks. Our user-friendly platform ensures a seamless experience with: ✅ Verified Listings – Every property is managed directly by Rheel Estate Limited ✅ Reduced Agency Fees – Lower costs to help you save ✅ Zero Listing fee & Up to 2% Cashback Offers – More value for your investment ✅ Comprehensive Property Details – High-quality photos, in-depth descriptions, and floor plans ✅ Virtual Tours – Explore properties remotely before making a decision ✅ In-App Messaging – Connect directly with our team for quick assistance',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'Our Mission & Vision',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'At Rheel Estate Limited, our goal is to make buying and leasing properties in Nigeria easier, safer, and more transparent—especially for Nigerians abroad who face challenges acquiring property due to fraud. We are committed to bringing sanity to the real estate industry in Nigeria while creating a better life for our clients, staff, and the general public through our affiliate program.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'Who is Rheel App For?',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                '📌 Property Owners – List your properties with ease 📌 Property Buyers & Investors – Find trusted properties without agent complications 📌 Nigerians Abroad – Secure property in Nigeria without fear of fraud 📌 Multinational Companies – Lease prime properties in Abuja hassle-free',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'Where We Operate',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'Rheel App is focused on the Nigerian real estate market, catering to both local buyers and Nigerians in the diaspora, as well as multinational companies looking to lease properties in Abuja, Nigeria.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'Who We Are',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'The Rheel App is the official property search platform of Rheel Estate Limited, With a commitment to trust, transparency, and efficiency, we are transforming the real estate experience for Nigerians at home and abroad.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height100)
            ],
          ),
        ),
      ),
    );
  }
}
