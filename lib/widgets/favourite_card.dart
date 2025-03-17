

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/models/products_data.dart';
import 'package:rheel_estate/routes/routes.dart';
import '../utils/dimensions.dart';
import '../controllers/properties_controller.dart';

class FavouriteCard extends StatelessWidget {
  final PropertiesModel property;

  final PropertiesController propertiesController =
      Get.find<PropertiesController>();

  FavouriteCard({
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
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.propertyDetailsScreen, arguments: {property});
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.width10,
          vertical: Dimensions.height10,
        ),
        padding: EdgeInsets.all(Dimensions.height10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.4),
            width: Dimensions.width5 / Dimensions.width10,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: Dimensions.height100 * 2,
                  width: double.maxFinite,
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
                    child: InkWell(
                        onTap: (){
                          likeProperty();
                        },
                        child: propertiesController.favorites.any((fav) => fav.id == property.id)
                            ? const Icon(Icons.favorite,color: Colors.white)
                            : const Icon(Icons.favorite_border, color: Colors.white,)
                    ),
                  ),
                ),

                Positioned(
                  bottom: Dimensions.height10,
                  left: Dimensions.width25,
                  child: Row(
                    children: [
                      _buildFeatureItem(
                          Icons.chair_outlined, '${property.livingRoom} Living'),
                      SizedBox(width: Dimensions.width10),
                      _buildFeatureItem(Icons.bathtub_outlined, '${property.bathroom} Baths'),
                      SizedBox(width: Dimensions.width10),
                      _buildFeatureItem(Icons.bed_outlined, '${property.bedroom} Beds'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                  width: Dimensions.width5 / Dimensions.width20,
                ),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle,
                          size: Dimensions.iconSize16,
                          color: const Color(0xFF016D54)),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        getPropertyFor(property.propertyFor),
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: Dimensions.iconSize16,
                          color: const Color(0xFF016D54)),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        property.location,
                        style: TextStyle(
                          fontSize: Dimensions.font15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    property.price.toString(),
                    style: TextStyle(
                      fontSize: Dimensions.font18,
                      fontWeight: FontWeight.w600,
                    ),
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
              fontSize: Dimensions.font14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}


