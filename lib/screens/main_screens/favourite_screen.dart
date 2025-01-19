import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/widgets/product_card.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../controllers/properties_controller.dart';
import '../../widgets/favourite_card.dart';

class FavouriteScreen extends StatelessWidget {
  final PropertiesController propertiesController = Get.find<PropertiesController>();

  FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        // Check if the favorites list is empty
        if (propertiesController.favorites.isEmpty) {
          return Center(
            child: Text(
              'No favorites added yet.',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: ListView.builder(
            itemCount: propertiesController.favorites.length,
            itemBuilder: (context, index) {
              final property = propertiesController.favorites[index];
              return InkWell(
                onTap: (){
                  Get.toNamed('/propertyDetails', arguments: {
                    'productImage': property['productImage'],
                    'propertyFor': property['propertyFor'],
                    'location': property['location'],
                    'price': property['price'],
                    'livingRooms': property['livingRooms'],
                    'baths': property['baths'],
                    'beds': property['beds'],
                    'description': property['description'],
                    'propertyType': property['propertyType'],
                    'floorplan': property['floorplan'],
                    'videoLink': property['videoLink'],
                    'updatedAt': property['updatedAt'],
                    'images': property['images'],
                    'agentEmail': 'hello@rheelestate.com',
                    'agentWhatsapp': '2348099222223',
                  });
                },
                child: ProductCard(
                  productImage: property['productImage'] ?? '',
                  propertyFor: property['propertyFor'] ?? '',
                  location: property['location'] ?? '',
                  price: property['price'] ?? '',
                  livingRooms: property['livingRooms'] ?? '0',
                  baths: property['baths'] ?? '0',
                  beds: property['beds'] ?? '0',
                  description: property['description'] ?? 'No description available.',
                  propertyType: property['propertyType'] ?? 'Unknown Type',
                  floorplan: property['floorplan'] ?? '',
                  videoLink: property['videoLink'] ?? '',
                  updatedAt: property['updatedAt'] ?? '',
                  images: property['images'] is String
                      ? (property['images'] as String).split(',')
                      : property['images'] is Iterable
                      ? List<String>.from(property['images'] as Iterable)
                      : [],
                  liked: true, // Favorites are always liked
                  onLike: (isLiked) {
                    if (isLiked) {
                      propertiesController.addFavorite(property);
                    } else {
                      propertiesController.removeFavorite(property);
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: Dimensions.height50 * 1.2,
      automaticallyImplyLeading: true,
      centerTitle: true,
      title: Text(
        'Favourites',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Dimensions.font22,
        ),
      ),
    );
  }
}