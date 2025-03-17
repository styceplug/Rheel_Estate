import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Frequently Asked Questions',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: Dimensions.font22),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20,vertical: Dimensions.height10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. What is Rheel App?',
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'Rheel App is the official property search platform of Rheel Estate Limited, designed to help Nigerians at home and abroad find verified properties for sale or lease in Abuja, Nigeria.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                '2. Who can use Rheel App?',
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              Text(
                '• Property buyers & investors looking for verified properties.\n• Property owners who want to list properties through Rheel Estate Limited.\n• Nigerians in the diaspora who want to acquire property in Nigeria without fraud risks.\n• Multinational companies seeking to lease properties in Abuja.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                '3. Do I need to register to use Rheel App?',
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              Text(
                '• No, you can browse properties as a guest.\n• However, to save properties or make inquiries, you must register or log in using Google, Apple ID, or Facebook.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                '4. How are properties listed on Rheel App?',
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              Text(
                'All properties are listed exclusively by Rheel Estate Limited\'s authorized staff. We do not accept external agent listings, ensuring every property is under our direct management.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                '5. Can I list my property on Rheel App?',
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              Text(
                'No, property owners cannot list directly. However, you can contact Rheel Estate Limited, and if approved, our team will handle the listing on your behalf.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                '6. Does Rheel App support online payments?',
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              Text(
                'No, Rheel App does not accept online payments. Property transactions require verification and vetting before payment. All payments are made directly between buyers and sellers.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: Dimensions.height50),
            ],
          ),
        ),
      ),
    );
  }
}
