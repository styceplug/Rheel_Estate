import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/widgets/profileImage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../helpers/products_data.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/dimensions.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _properties = [];
  bool _isLoading = false;

  Future<void> _fetchPropertiesByLocation(String location) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<dynamic> response = await Supabase.instance.client
          .from('properties')
          .select('*')
          .eq('location', location);

      setState(() {
        _properties = response.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      debugPrint('Error fetching properties: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  late PageController adsController;
  int _currentPage = 0;
  late Future<List<Properties>> _propertiesFuture;

  final PropertiesController propertiesController =
      Get.find<PropertiesController>();

  @override
  void initState() {
    super.initState();
    adsController = PageController();
    _propertiesFuture = fetchProperties();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    adsController.dispose();
    super.dispose();
  }

  Future<List<Properties>> fetchProperties() async {
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
      debugPrint('Error fetching properties: $e');
      throw Exception('Failed to fetch properties');
    }
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && adsController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % 3; // Assuming 3 banners
        });
        try {
          adsController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } catch (e) {
          debugPrint("Error animating to page: $e");
        }
        _startAutoScroll();
      }
    });
  }

  Future<Map<String, dynamic>?> _getUserMetadata() async {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.userMetadata;
  }

  @override
  Widget build(BuildContext context) {
    double bannerWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Dimensions.height50 * 1.7,
        centerTitle: true,
        leadingWidth: Dimensions.width70,
        automaticallyImplyLeading: false,
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
        leading: Row(
          children: [
            SizedBox(width: Dimensions.width20),
            ProfileImage(size: Dimensions.height43)
          ],
        ),
        actions: [
          InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.bookAppointment);
              },
              child: Icon(Icons.add_circle_outline,
                  size: Dimensions.iconSize30, color: AppColors.accentColor)),
          SizedBox(width: Dimensions.width20),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height10,
          ),
          child: Column(
            children: [
              MySearchBar(
                hintText: 'Search by Location',
                onLocationSelected: _fetchPropertiesByLocation,
              ),
              SizedBox(height: Dimensions.height20),
              SizedBox(
                height: Dimensions.height20 * 10,
                child: PageView(
                  controller: adsController,
                  children: [
                    for (var i = 1; i <= 3; i++)
                      Container(
                        width: bannerWidth,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.5),
                            width: Dimensions.width5 / Dimensions.width20,
                          ),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              AppConstants.getPngAsset('banner$i'),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Properties',
                    style: TextStyle(
                      fontSize: Dimensions.font18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xfffc2931c),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.seeAllPropertiesScreen);
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xfff6b6b6b),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height30),
              SizedBox(
                height: Dimensions.height20 * 15.6,
                child: FutureBuilder<List<Properties>>(
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
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: properties.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: Dimensions.width20),
                      itemBuilder: (context, index) {
                        final property = properties[index];
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
