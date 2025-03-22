import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/controllers/banner_announcement_controller.dart';

import 'package:rheel_estate/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/properties_controller.dart';
import '../../models/products_data.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/dimensions.dart';
import '../../widgets/product_card.dart';
import '../../widgets/profileImage.dart';
import '../../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedLocation;
  List<dynamic> _filteredProperties = [];

  List<Map<String, dynamic>> properties = [];
  bool _isLoading = false;

  /*Future<void> refreshProperties() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await propertiesController.fetchProperties(
          propertiesController.properties); // Fetch the latest properties
    } catch (e) {
      debugPrint("Error refreshing properties: $e");
      Get.snackbar("Error", "Failed to refresh properties");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }*/

  Future<void> refreshProperties() async {
    if (!Get.isRegistered<PropertiesController>()) {
      debugPrint("PropertiesController not registered");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await propertiesController.fetchProperties(propertiesController.properties ?? []);
    } catch (e) {
      debugPrint("Error refreshing properties: $e");
      Get.snackbar("Error", "Failed to refresh properties");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  late ScrollController adsController;
  int _currentPage = 0;

  final PropertiesController propertiesController =
      Get.find<PropertiesController>();

  final BannerAnnouncementController bannerAnnouncementController =
      Get.find<BannerAnnouncementController>();

  @override
  void initState() {
    super.initState();
    adsController = ScrollController();
    refreshProperties();
    bannerAnnouncementController.getBanners().then((_) {
      _startAutoScroll();
    });
  }


  bool _isDisposed = false; // Track disposal state

  void _startAutoScroll() {
    if (!mounted || _isDisposed || bannerAnnouncementController.banners.isEmpty) return;

    double bannerWidth = MediaQuery.of(context).size.width * 0.8;

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted || _isDisposed) return; // Ensure widget is still active

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _isDisposed) return; // Prevent updates on unmounted widget

        setState(() {
          _currentPage = (_currentPage + 1) % bannerAnnouncementController.banners.length;
        });

        if (adsController.hasClients) {
          double newOffset = _currentPage * (bannerWidth + Dimensions.width10);
          adsController.animateTo(
            newOffset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }

        _startAutoScroll(); // Continue the loop
      });
    });
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark as disposed to stop further execution
    adsController.dispose(); // Dispose any controllers if necessary
    super.dispose();
  }

  void showRedirectDialog(String url) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        title: Text(
          "Confirm Exit",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Dimensions.font20,
          ),
        ),
        content: Text(
          "You are about to leave the app. Do you want to proceed?",
          style: TextStyle(fontSize: Dimensions.font14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Close dialog
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog
              final Uri uri = Uri.parse(url);
              if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                Get.snackbar(
                  "Error",
                  "Could not open the link",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text("Yes, Leave", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double bannerWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
      body: RefreshIndicator(
        color: AppColors.accentColor,
        onRefresh: refreshProperties,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MySearchBar(
                  hintText: "Search locations...",
                  onLocationSelected: (location, properties) {
                    setState(() {
                      _selectedLocation = location;
                      _filteredProperties = properties;
                    });
                  },
                ),
                SizedBox(height: Dimensions.height10),

                //ads
                SizedBox(
                  height: Dimensions.height20 * 10,
                  child: Obx(() {
                    if (bannerAnnouncementController.banners.isEmpty) {
                      return Center(
                        child: Container(
                          width: bannerWidth,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withOpacity(0.5),
                              width: Dimensions.width5 / Dimensions.width20,
                            ),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            image: DecorationImage(
                              image: AssetImage(
                                  AppConstants.getPngAsset('banner1')),
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: adsController,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: Dimensions.width10);
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: bannerAnnouncementController.banners.length,
                      itemBuilder: (context, index) {
                        final banner =
                            bannerAnnouncementController.banners[index];

                        if (banner.image.isEmpty)
                          return const SizedBox.shrink();

                        return Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.height10),
                          child: InkWell(
                            onTap: () => showRedirectDialog(banner.redirect),
                            child: Container(
                              width: bannerWidth,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.5),
                                  width: Dimensions.width5 / Dimensions.width20,
                                ),
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                child: CachedNetworkImage(
                                  imageUrl: banner.image,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                SizedBox(height: Dimensions.height10),
                SizedBox(
                  child: Obx(() {
                    int totalBanners =
                        bannerAnnouncementController.banners.length;
                    if (totalBanners == 0)
                      return const SizedBox.shrink(); // Hide if no banners

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        totalBanners,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: _currentPage == index ? 12.0 : 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? AppColors.accentColor // Active dot color
                                : Colors.grey, // Inactive dot color
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: Dimensions.height20),
                //props
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Top Properties',
                        style: TextStyle(
                          fontSize: Dimensions.font18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF2931C),
                        ),
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
                          color: const Color(0xFFFb6b6b),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height20),
                SizedBox(
                  height: Dimensions.height20 * 15.6,
                  child: Obx(() {
                    if (propertiesController.properties.isEmpty && _isLoading) {
                      return const Center(
                          child: CircularProgressIndicator()); // Show loader
                    }

                    List<PropertiesModel> properties =
                        propertiesController.properties;
                    return ListView.separated(
                      separatorBuilder: (_, __) {
                        return SizedBox(width: Dimensions.width15);
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        PropertiesModel property = properties[index];
                        return ProductCard(property: property);
                      },
                    );
                  }),
                ),
                SizedBox(height: Dimensions.height50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
