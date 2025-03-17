import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/widgets/product_card.dart';
import '../../models/products_data.dart';

import '../../utils/dimensions.dart';
import '../../controllers/properties_controller.dart';


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
          child: ListView.separated(
            separatorBuilder: (context, index ) => SizedBox(height: Dimensions.height10),
            itemCount: propertiesController.favorites.length,
            itemBuilder: (context, index) {
              PropertiesModel property = propertiesController.favorites[index];
              return InkWell(
                onTap: (){
                  // Get.toNamed('/propertyDetails');
                  print(property.id);
                },

                child: ProductCard(property: property),
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