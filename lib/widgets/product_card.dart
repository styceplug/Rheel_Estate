import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rheel_estate/controllers/properties_controller.dart';
import 'package:rheel_estate/routes/routes.dart';

import 'package:rheel_estate/utils/dimensions.dart';

import '../models/products_data.dart';

class ProductCard extends StatelessWidget {
  final PropertiesModel property;

  PropertiesController propertiesController = Get.find<PropertiesController>();

  ProductCard({
    super.key,
    required this.property,
  });

  void likeProperty() async {
    propertiesController.toggleFavorite(property);
  }

  String getPropertyFor(String propertyForValue) {
    switch (propertyForValue) {
      case 'Sell':
        return 'For Sale';
      case 'Lease':
        return 'For Lease';
      default:
        return 'Unknown';
    }
  }

  String getPropertyType(int? propertyTypeValue) {
    switch (propertyTypeValue) {
      case 1:
        return 'Duplex Building';
      case 2:
        return 'Terrace Building';
      case 3:
        return 'Bungalow Building';
      case 4:
        return 'Apartment Building';
      case 5:
        return 'Commercial Building';
      case 6:
        return 'Carcass Building';
      case 7:
        return 'Land Building';
      case 8:
        return 'JV Land';
      default:
        return 'Unknown Building'; // Fallback for unmapped values
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerWidth = MediaQuery.of(context).size.width * 0.8;

    return InkWell(
      onTap: () {
        print('Navigating to details of: ${property.id}');
        Get.toNamed(AppRoutes.propertyDetailsScreen, arguments: property);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.height10, horizontal: Dimensions.width10),
        // height: Dimensions.height20 * 20,
        width: bannerWidth,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: Dimensions.width5 / Dimensions.width15),
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(
                  height: Dimensions.height100 * 2,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      border: Border.all(
                          color: Colors.black,
                          width: Dimensions.width5 / Dimensions.width15)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    child: CachedNetworkImage(
                      imageUrl:
                          property.image.isNotEmpty ? property.image[0] : '',
                      width: double.maxFinite,
                      height: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //like property
                Positioned(
                  right: Dimensions.width10,
                  top: Dimensions.height10,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height5,
                        horizontal: Dimensions.width5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Obx(
                      () => InkWell(
                          onTap: () {
                            likeProperty();
                          },
                          child: propertiesController.favorites
                                  .any((fav) => fav.id == property.id)
                              ? const Icon(Icons.favorite, color: Colors.red)
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                )),
                    ),
                  ),
                ),
                Positioned(
                  bottom: Dimensions.height15,
                  left: Dimensions.width10,
                  child: Row(
                    children: [
                      _buildFeatureItem(Icons.chair_outlined,
                          '${property.livingRoom} Living'),
                      SizedBox(width: Dimensions.width10),
                      _buildFeatureItem(
                          Icons.bathtub_outlined, '${property.bathroom} Baths'),
                      SizedBox(width: Dimensions.width10),
                      _buildFeatureItem(
                          Icons.bed_outlined, '${property.bedroom} Beds'),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height10),
              height: Dimensions.height10 * 9,
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black.withOpacity(0.6),
                    width: Dimensions.width5 / Dimensions.width15),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: bannerWidth - Dimensions.width85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: Dimensions.iconSize16,
                                  color: const Color(0xFF016D54),
                                ),
                                SizedBox(width: Dimensions.width5),
                                Text(
                                  getPropertyFor(property.propertyFor),
                                  style: TextStyle(
                                      fontSize: Dimensions.font14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            // SizedBox(width: Dimensions.width50 * 1.5),
                            //finance
                            Row(
                              children: [
                                Container(
                                  height: Dimensions.height10,
                                  width: Dimensions.width10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: !property.finance
                                          ? Colors.red
                                          : Colors.green),
                                ),
                                SizedBox(width: Dimensions.width5),
                                Text(
                                  'Finance:',
                                  style: TextStyle(
                                      fontSize: Dimensions.font15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                    width:
                                        Dimensions.width10 / Dimensions.width5),
                                Text(property.finance ? 'True' : 'False'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: Dimensions.iconSize16,
                            color: const Color(0xFF016D54),
                          ),
                          SizedBox(width: Dimensions.width5),
                          Text(
                            property.location,
                            style: TextStyle(
                                fontSize: Dimensions.font15,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Text(
                        '₦ ${NumberFormat("#,##0", "en_US").format(property.price)}',
                        style: TextStyle(
                          fontSize: Dimensions.font17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
      height: Dimensions.height30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: Dimensions.iconSize20,
            color: Colors.black.withOpacity(0.6),
          ),
          SizedBox(width: Dimensions.width5),
          Text(
            text,
            style: TextStyle(
                fontSize: Dimensions.font14, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget buildPropertyImages(List<String> images) {
    if (images.isEmpty) {
      return const Center(child: Text('No images available.'));
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Column(
        children: [
          // Scroll indicator (visible only if there are multiple images)
          if (images.length > 1)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Dimensions.height5,
                width: Dimensions.width50 * 3,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                ),
                child: Row(
                  children: List.generate(images.length, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.all(
                            Dimensions.width20 / Dimensions.width10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius5),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          SizedBox(height: Dimensions.height5),
          // Horizontal image list view
          SizedBox(
            height: Dimensions.height100 * 2,
            child: ListView.builder(
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
