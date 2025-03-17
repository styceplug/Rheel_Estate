import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class TermAndConditions extends StatefulWidget {
  const TermAndConditions({super.key});

  @override
  State<TermAndConditions> createState() => _TermAndConditionsState();
}

class _TermAndConditionsState extends State<TermAndConditions> {
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
          'TERMS & CONDITION',
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
              SizedBox(height: Dimensions.height20),
              _buildSectionContent('Effective Date: 01/02/2025'),
              _buildSectionContent('Welcome to Rheel App, the official property search platform of Rheel Estate Limited. By using our mobile application or website, you agree to comply with the following Terms and Conditions. Please read them carefully.'),
              _buildSectionTitle('1. User Eligibility & Account Registration'),
              _buildSectionContent('• Users can browse property listings as guests without registration.\n• To save properties or make inquiries, users must register or log in via Google, Apple ID, or Facebook.\n• There is no age restriction for using the app.'),
              _buildSectionTitle('2. Property Listings & Transactions'),
              _buildSectionContent('• All property listings are managed and uploaded only by Rheel Estate Limited\'s authorized staff.\n• Rheel App does not facilitate direct payments. Buyers and tenants must verify properties and complete vetting before making any payments.\n• Property owners cannot list directly—all listings are controlled by Rheel Estate Limited.'),
              _buildSectionTitle('3. Fees & Payments'),
              _buildSectionContent('• Zero listing fee: Property owners can list their properties for free.\n• Sellers pay a discounted commission only after a property is sold.\n• Buyers pay a discounted commission only after a property is sold.\n• Cashback and affiliate rewards are processed within 7 working days after the deal is closed and all payments are concluded.'),
              _buildSectionTitle('4. User Responsibilities & Prohibited Activities'),
              _buildSectionContent('Users agree not to:\n• Post false or misleading property listings.\n• Engage in abusive behavior, harassment, or offensive communication.\n• Use the platform for spamming, fraud, or illegal activities.\nViolations may result in account suspension or legal action.'),
              _buildSectionTitle('5. Liability & Disclaimers'),
              _buildSectionContent('• Property details are provided "as-is." While we conduct due diligence, Rheel App is not responsible for any undisclosed defects or property issues.\n• Rheel App acts only as a connection platform between buyers and sellers. Our responsibility ends once a transaction is completed.\n• We do not guarantee the accuracy of property descriptions, pricing, or availability.'),
              _buildSectionTitle('6. Privacy & Data Protection'),
              _buildSectionContent('• We collect and store user data for app functionality (e.g., messaging, analytics).\n• User data is private and secure. We will never share data with third parties unless required by a court order.\n• Users are responsible for maintaining the confidentiality of their login credentials.'),
              _buildSectionTitle('7. Dispute Resolution & Governing Law'),
              _buildSectionContent('• All disputes shall be governed by Nigerian law.\n• Before legal action, disputes must go through mediation.\n• Rheel Estate Limited reserves the right to modify these terms at any time. Continued use of the app implies acceptance of the updated terms.'),
              _buildSectionContent('By using Rheel App, you agree to these Terms and Conditions. If you do not agree, please discontinue use immediately. For inquiries, contact: hello@rheelestate.com'),
              SizedBox(height: Dimensions.height50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Dimensions.font18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height15),
      child: Text(
        content,
        style: TextStyle(
          fontSize: Dimensions.font14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
