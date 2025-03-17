import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/inquiries_controller.dart';
import '../../utils/dimensions.dart';

class InquiriesScreen extends StatefulWidget {
  const InquiriesScreen({super.key});

  @override
  State<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends State<InquiriesScreen> {
  InquiryController inquiryController = Get.find<InquiryController>();

  void showDeleteDialog(BuildContext context, int index) {
    Get.defaultDialog(
      title: "Delete Inquiry?",
      middleText: "Are you sure you want to delete this inquiry?",
      textConfirm: "Yes, Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        inquiryController.deleteInquiry(index);
        Get.back(); // Close the dialog
      },
      onCancel: () => Get.back(),
      backgroundColor: Colors.white,
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      middleTextStyle: TextStyle(fontSize: 16),
    );
  }

  String getPropertyType(int? propertyTypeValue) {
    switch (propertyTypeValue) {
      case 1:
        return 'Duplex';
      case 2:
        return 'Terrace';
      case 3:
        return 'Bungalow';
      case 4:
        return 'Apartment';
      case 5:
        return 'Commercial';
      case 6:
        return 'Carcass';
      case 7:
        return 'Land';
      case 8:
        return 'JV Land';
      default:
        return 'Unknown'; // Fallback for unmapped values
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.width20, vertical: Dimensions.height10),
        child: Obx(() {
          if (inquiryController.inquiries.isEmpty) {
            return Center(
              child: Text(
                'No inquiries yet.',
                style: TextStyle(fontSize: Dimensions.font18),
              ),
            );
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: Dimensions.width10, // Space between columns
              mainAxisSpacing: Dimensions.height10, // Space between rows
              childAspectRatio: 0.8, // Adjust for better card layout
            ),
            itemCount: inquiryController.inquiries.length,
            itemBuilder: (context, index) {
              final inquiry = inquiryController.inquiries[index];
              final property = inquiry['property'] ?? {};

              return Card(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                      horizontal: Dimensions.width10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Property Image
                      if (property['property_images'] != null &&
                          property['property_images'] is List &&
                          property['property_images'].isNotEmpty)
                        Stack(children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius10),
                            child: CachedNetworkImage(
                              imageUrl: property['property_images'][0] ?? '',
                              width: double.infinity,
                              height: Dimensions.height50 * 2.5,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: (){
                                inquiryController.deleteInquiry(index);
                              },
                              child: Container(
                                height: Dimensions.height30,
                                width: Dimensions.width30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      offset: Offset(4, 4),
                                      blurRadius: Dimensions.radius10,
                                      spreadRadius: Dimensions.radius10
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.delete_forever),
                              ),
                            ),
                          )
                        ]),

                      // Property Type
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maxLines: 1,
                            getPropertyType(property['property_type_id']),
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          // Property Details
                          Text(
                            'Location: ${property['location'] ?? 'N/A'}',
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              fontSize: Dimensions.font14,
                            ),
                          ),

                          Text('Price: ${property['price'] ?? 'N/A'}',
                              maxLines: 1,
                              style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  fontSize: Dimensions.font13,
                                  fontWeight: FontWeight.w600)),

                          Text(
                            'Date: ${inquiry['timestamp'] ?? 'N/A'}',
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.clip,
                                fontSize: Dimensions.font12,
                                fontWeight: FontWeight.w500),
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
      ),
    );
  }
}
