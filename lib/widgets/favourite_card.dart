import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/dimensions.dart';
import '../controllers/properties_controller.dart';

class FavouriteCard extends StatelessWidget {
  final PropertiesController propertiesController =
  Get.put(PropertiesController());

  final String productImage;
  final String propertyFor;
  final String location;
  final String price;
  final String livingRooms;
  final String baths;
  final String beds;
  final String description;
  final String propertyType;
  final String floorplan;
  final String videoLink;
  final String updatedAt;
  final List<String> images;
  final bool liked;
  final Function(bool) onLike;

  FavouriteCard({
    super.key,
    required this.productImage,
    required this.propertyFor,
    required this.location,
    required this.price,
    required this.livingRooms,
    required this.baths,
    required this.beds,
    required this.description,
    required this.propertyType,
    required this.floorplan,
    required this.videoLink,
    required this.updatedAt,
    required this.images,
    this.liked = false,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/propertyDetails', arguments: {
          'productImage': productImage,
          'propertyFor': propertyFor,
          'location': location,
          'price': price,
          'livingRooms': livingRooms,
          'baths': baths,
          'beds': beds,
          'description': description,
          'propertyType': propertyType,
          'floorplan': floorplan,
          'videoLink': videoLink,
          'updatedAt': updatedAt,
          'images': images,
        });
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
                Container(
                  height: Dimensions.height100 * 2,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(productImage),
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
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
                      color: !liked
                          ? Colors.black.withOpacity(0.4)
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () {
                        onLike(!liked);
                        if (!liked) {
                          propertiesController.addFavorite({
                            'productImage': productImage,
                            'propertyFor': propertyFor,
                            'location': location,
                            'price': price,
                            'livingRooms': livingRooms,
                            'baths': baths,
                            'beds': beds,
                            'description': description,
                            'propertyType': propertyType,
                            'floorplan': floorplan,
                            'videoLink': videoLink,
                            'updatedAt': updatedAt,
                          });
                        } else {
                          propertiesController.removeFavorite({
                            'productImage': productImage,
                            'propertyFor': propertyFor,
                            'location': location,
                            'price': price,
                            'livingRooms': livingRooms,
                            'baths': baths,
                            'beds': beds,
                            'description': description,
                            'propertyType': propertyType,
                            'floorplan': floorplan,
                            'videoLink': videoLink,
                            'updatedAt': updatedAt,
                          });
                        }
                      },
                      child: Icon(
                        !liked ? Icons.favorite_border : Icons.favorite,
                        color: liked ? Colors.red : Colors.white,
                        size: Dimensions.iconSize24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: Dimensions.height10,
                  left: Dimensions.width25,
                  child: Row(
                    children: [
                      _buildFeatureItem(
                          Icons.chair_outlined, '$livingRooms Living'),
                      SizedBox(width: Dimensions.width10),
                      _buildFeatureItem(Icons.bathtub_outlined, '$baths Baths'),
                      SizedBox(width: Dimensions.width10),
                      _buildFeatureItem(Icons.bed_outlined, '$beds Beds'),
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
                        propertyFor,
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
                        location,
                        style: TextStyle(
                          fontSize: Dimensions.font15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    price,
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