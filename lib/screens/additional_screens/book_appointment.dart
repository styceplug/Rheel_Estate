import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:rheel_estate/widgets/custom_textfield.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController mailController = TextEditingController();
TextEditingController locationController = TextEditingController();
TextEditingController propertyTypeController = TextEditingController();
TextEditingController transactionTypeController = TextEditingController();
TextEditingController propertyStatusController = TextEditingController();

class _BookAppointmentState extends State<BookAppointment> {

  // Method to send email
  Future<void> sendEmail() async {
    // SMTP server credentials
    String username = 'styceplug@gmail.com'; // Replace with your email
    String password = 'rhuf dmmm mjtr jail'; // Replace with your app password

    final smtpServer = gmail(username, password);

    // Email message
    final message = Message()
      ..from = Address(username, 'Book Appointment App')
      ..recipients.add('olastephanie2003@gmail.com') // Replace with recipient email
      ..subject = 'New Appointment Booking'
      ..text = '''
New Appointment Booking:
First Name: ${firstNameController.text}
Last Name: ${lastNameController.text}
Phone: ${phoneController.text}
Email: ${mailController.text}
Location: ${locationController.text}
Property Type: ${propertyTypeController.text}
Transaction Type: ${transactionTypeController.text}
Property Status: ${propertyStatusController.text}
      ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      Get.snackbar('Success', 'Appointment booked successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print('Message not sent. $e');
      Get.snackbar('Error', 'Failed to book appointment!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

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
        toolbarHeight: Dimensions.height50 * 1.3,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'BOOK APPOINTMENT',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: Dimensions.font22),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.width20, vertical: Dimensions.height10),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height10),
            const Text('Book an Appointment today to be considered for listing'),
            SizedBox(height: Dimensions.height20),
            //first & last name
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      controller: firstNameController,
                      hintText: 'Enter First Name',
                      labelText: 'First Name'),
                ),
                SizedBox(width: Dimensions.width20),
                Expanded(
                  child: CustomTextField(
                      controller: lastNameController,
                      hintText: 'Enter Last Name',
                      labelText: 'Last Name'),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            //pno, mail, address, type && status
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      controller: phoneController,
                      hintText: 'Area Code first',
                      labelText: 'Input Phone Number'),
                ),
                SizedBox(width: Dimensions.width20),
                Expanded(
                  child: CustomTextField(
                      controller: mailController,
                      hintText: 'Input email address',
                      labelText: 'Email Address'),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            CustomTextField(
                controller: locationController,
                hintText: 'Input Address',
                labelText: 'Property Address'),
            SizedBox(height: Dimensions.height20),
            CustomTextField(
                controller: propertyTypeController,
                hintText:
                    'Duplex, Bungalow, Terrace, Apartment, Land, Commercial',
                labelText: 'Property Type'),
            SizedBox(height: Dimensions.height20),
            CustomTextField(
                controller: transactionTypeController,
                hintText: 'Sale or Lease',
                labelText: 'Transaction Type'),
            SizedBox(height: Dimensions.height20),
            CustomTextField(
                controller: propertyStatusController,
                hintText: 'Completed or Non-Completed ',
                labelText: 'Property Status'),
            SizedBox(height: Dimensions.height40),
            InkWell(
              onTap: sendEmail,
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width30,
                      vertical: Dimensions.height15),
                  decoration: BoxDecoration(
                      gradient: AppColors.mainGradient,
                      borderRadius: BorderRadius.circular(Dimensions.radius30)),
                  child: Text(
                    'Book Appointment Now',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.font18),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
