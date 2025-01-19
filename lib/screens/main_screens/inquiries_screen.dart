import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/inquiries_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';


class InquiriesScreen extends StatelessWidget {
  const InquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InquiryController inquiryController = Get.find();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Dimensions.height50 * 1.2,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'My Inquiries',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: Dimensions.font25),
        ),
      ),
      body: Obx(() {
        if (inquiryController.inquiries.isEmpty) {
          return Center(
            child: Text(
              'No inquiries yet.',
              style: TextStyle(fontSize: Dimensions.font18),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          itemCount: inquiryController.inquiries.length,
          itemBuilder: (context, index) {
            final inquiry = inquiryController.inquiries[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
              child: ListTile(
                contentPadding: EdgeInsets.all(Dimensions.width10),
                title: Text(
                  inquiry['propertyType'] ?? 'Property Type',
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //propertyImage
                    Container(
                      width: Dimensions.width50*1.5, // Adjust size as needed
                      height: Dimensions.height50*1.5,
                      margin: EdgeInsets.only(right: Dimensions.width15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius10),
                        image: DecorationImage(
                          image: NetworkImage(
                            inquiry['propertyImage'] ?? 'https://via.placeholder.com/150',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    //propertyDetails
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${inquiry['propertyLocation'] ?? ''}',style: TextStyle(fontWeight: FontWeight.w500),),
                        Text('Price: ${inquiry['propertyPrice'] ?? ''}'),
                        Text(
                          'Date: ${inquiry['timestamp'] ?? ''}',
                          style: TextStyle(fontSize: Dimensions.font14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}