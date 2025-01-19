import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../helpers/products_data.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/product_card.dart';

class SeeAllProperties extends StatefulWidget {
  const SeeAllProperties({super.key});

  @override
  State<SeeAllProperties> createState() => _SeeAllPropertiesState();
}

final PropertiesController propertiesController =
Get.find<PropertiesController>();

class _SeeAllPropertiesState extends State<SeeAllProperties> {
  String selectedFilter = 'All';
  late Future<List<Properties>> _propertiesFuture;
  List<Properties> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _propertiesFuture = fetchProducts();
  }

  Future<List<Properties>> fetchProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('properties')
          .select('*')
          .order('created_at', ascending: false);

      final data = response as List;
      return data
          .map((item) => Properties.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching products: $e');
      throw Exception('Failed to fetch products');
    }
  }

  void selectFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        toolbarHeight: Dimensions.height50 * 1.2,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Container(
          height: Dimensions.height10 * 15,
          width: Dimensions.width10 * 15,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AppConstants.getPngAsset('logo'),
              ),
            ),
          ),
        ),
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
      ),
      body: FutureBuilder<List<Properties>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0A2F1E),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No properties found.'));
          }

          final properties = snapshot.data!;
          if (selectedFilter == 'All') {
            filteredProducts = properties;
          } else if (selectedFilter == 'For Sale') {
            filteredProducts = properties
                .where((product) => product.propertyFor == 'For Sale')
                .toList();
          } else if (selectedFilter == 'To Lease') {
            filteredProducts = properties
                .where((product) => product.propertyFor == 'To Lease')
                .toList();
          }

          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: Dimensions.height20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFilterOption('All'),
                    _buildFilterOption('For Sale'),
                    _buildFilterOption('To Lease'),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20),
                  child: filteredProducts.isEmpty
                      ? Center(
                    child: Text(
                      'No properties available in this category.',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        color: Colors.grey,
                      ),
                    ),
                  )
                      : SizedBox(
                    height: Dimensions.height20 * 16,
                    child: ListView.separated(
                      itemCount: filteredProducts.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: Dimensions.height20),
                      itemBuilder: (context, index) {
                        final property = filteredProducts[index];
                        return ProductCard(
                          productImage: property.image.first,
                          propertyFor: property.propertyFor,
                          location: property.address1,
                          price: '₦${property.price}',
                          livingRooms: property.livingRoom.toString(),
                          baths: property.bathroom.toString(),
                          beds: property.bedroom.toString(),
                          description: property.description,
                          propertyType: property.propertyType,
                          floorplan: property.floorplan ?? '',
                          videoLink: property.videoLink ?? '',
                          updatedAt: property.updatedAt ?? '',
                          images: property.image,
                          liked: propertiesController.favorites.any((fav) =>
                          fav['productImage'] == property.image.first),
                          onLike: (isLiked) {
                            final propertyData = {
                              'productImage': property.image.isNotEmpty
                                  ? property.image.first
                                  : '',
                              'propertyFor': property.propertyFor,
                              'location': property.address1,
                              'price': '₦${property.price}',
                              'livingRooms': '${property.livingRoom}',
                              'baths': '${property.bathroom}',
                              'beds': '${property.bedroom}',
                            };

                            if (isLiked) {
                              propertiesController.addFavorite(propertyData);
                            } else {
                              propertiesController.removeFavorite(propertyData);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterOption(String filter) {
    final bool isActive = selectedFilter == filter;

    return GestureDetector(
      onTap: () => selectFilter(filter),
      child: Container(
        alignment: Alignment.center,
        height: Dimensions.height10 * 3.5,
        width: Dimensions.width10 * 9,
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.mainGradient : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: isActive
              ? null
              : Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: Dimensions.width5 / Dimensions.width20,
          ),
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black.withOpacity(0.6),
            fontSize: Dimensions.font15,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
