import 'package:flutter/material.dart';
import 'package:rheel_estate/controllers/properties_controller.dart';
import 'package:rheel_estate/models/products_data.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import 'package:rheel_estate/widgets/app_bar.dart';
import 'package:rheel_estate/widgets/product_card.dart';

class SearchListScreen extends StatefulWidget {
  List<PropertiesModel> properties;

  SearchListScreen({super.key, required this.properties});

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('Search Results'),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: ListView.separated(
          separatorBuilder: (context, index)=> SizedBox(height: Dimensions.height10),
          itemCount: widget.properties.length,
          itemBuilder: (context, index){
            PropertiesModel property = widget.properties[index];
            return ProductCard(property: property);
          },
        ),
      ),
    );
  }
}
