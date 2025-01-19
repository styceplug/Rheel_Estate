import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
        toolbarHeight: Dimensions.height50 * 2,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'P R I V A C Y  P O L I C Y',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: Dimensions.font25),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last updated: September 08, 2023',
                style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Interpretation and Definitions \nInterpretation',
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              Text(
                'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Definitions \nFor the purposes of this Privacy Policy:',
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              Text(
                'Account means a unique account created for You to access our Service or parts of our Service. Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority. Application refers to RHEEL, the software program provided by the Company. Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to RHEEL. Country refers to: Nigeria Device means any device that can access the Service such as a computer, a cellphone or a digital tablet. Personal Data is any information that relates to an identified or identifiable individual. Service refers to the Application. Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used. Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit). You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.',
                style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Collecting and Using Your Personal Data \nTypes of Data Collected \nPersonal Data',
                style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              Text(
                'While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                '- Email address\n- First name and last name\n- Phone number\n- Address, State, Province, ZIP/Postal code, City',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Usage Data',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'Usage Data is collected automatically when using the Service. Usage Data may include information such as Your Device\'s Internet Protocol address (e.g., IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers, and other diagnostic data.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers, and other diagnostic data.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Information Collected while Using the Application',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'While using Our Application, in order to provide features of Our Application, We may collect, with Your prior permission:',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                '- Information regarding your location\n\n'
                'We use this information to provide features of Our Service, to improve and customize Our Service. The information may be uploaded to the Company\'s servers and/or a Service Provider\'s server, or it may be simply stored on Your device.\n\n'
                'You can enable or disable access to this information at any time through Your Device settings.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Use of Your Personal Data',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'The Company may use Personal Data for the following purposes:',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                '- To provide and maintain our Service, including to monitor the usage of our Service.\n'
                '- To manage Your Account: to manage Your registration as a user of the Service.\n'
                '- For the performance of a contract: the development, compliance, and undertaking of a purchase contract.\n'
                '- To contact You: by email, telephone calls, SMS, or push notifications.\n'
                '- To provide You with news, special offers, and general information about other goods or services.\n'
                '- To manage Your requests: To attend and manage Your requests to Us.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'We may share Your personal information in the following situations:',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                '- With Service Providers: to monitor and analyze the use of our Service.\n'
                '- For business transfers: during negotiations of any merger or sale of Company assets.\n'
                '- With Affiliates: requiring them to honor this Privacy Policy.\n'
                '- With business partners: to offer You certain products, services, or promotions.\n'
                '- With other users: when You share personal information publicly.\n'
                '- With Your consent: for any other purpose with Your explicit consent.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                'Retention of Your Personal Data',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Transfer of Your Personal Data',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'Your information, including Personal Data, is processed at the Company\'s operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Delete Your Personal Data',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You. You may update, amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the account settings section that allows you to manage Your personal information. Please note, however, that We may need to retain certain information when we have a legal obligation or lawful basis to do so.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Security of Your Personal Data',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Children\'s Privacy',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'Our Service does not address anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Changes to this Privacy Policy',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height40),
            ],
          ),
        ),
      ),
    );
  }
}
