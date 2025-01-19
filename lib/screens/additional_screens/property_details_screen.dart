import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/inquiries_controller.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _recordInquiry(
      String propertyType, String propertyLocation, String propertyPrice, String propertyImage) {
    final inquiry = {
      'propertyType': propertyType,
      'propertyLocation': propertyLocation,
      'propertyPrice': propertyPrice,
      'propertyImage': propertyImage,
      'timestamp': DateTime.now().toString(),
    };
    // Save inquiry (you can use a state management solution or local storage here)
    Get.put(InquiryController()).addInquiry(inquiry);
  }

  String getPropertyType(String? propertyTypeValue) {
    switch (propertyTypeValue) {
      case '1':
        return 'Duplex Building';
      case '2':
        return 'Terrace Building';
      case '3':
        return 'Bungalow Building';
      case '4':
        return 'Apartment Building';
      case '5':
        return 'Commercial Building';
      case '6':
        return 'Carcass Building';
      case '7':
        return 'Land Building';
      case '8':
        return 'JV Land';
      default:
        return 'Unknown Building'; // Fallback for unmapped values
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final propertyType = getPropertyType(
        args?['propertyType']?.toString()); // Fetch property type
    final propertyLocation = args?['location'] ?? 'Property Location';
    final propertyPrice = args?['price'] ?? 'Price not specified';
    final propertyImage =
        args?['productImage'] ?? AppConstants.getPngAsset('placeholder');
    final description = args?['description'] ?? 'No description available.';
    final floorplan = args?['floorplan'];
    final videoLink = args?['videoLink'];
    final agentEmail = args?['agentEmail'] ?? 'hello@rheelestate.com';
    final whatsappNumber = args?['agentWhatsapp'] ?? '2348099222223';

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Stack(
          children: [
            NestedScrollView(
              physics: const ClampingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: Dimensions.height100 * 4.5,
                  pinned: true,
                  backgroundColor: AppColors.accentColor,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: AppColors.white),
                      onPressed: () {},
                    ),
                  ],
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final appBarHeight = Dimensions.height100 * 4.5;
                      final t = (1.0 -
                              (constraints.biggest.height - kToolbarHeight) /
                                  (appBarHeight - kToolbarHeight))
                          .clamp(0.0, 1.0);
                      return FlexibleSpaceBar(
                        title: Opacity(
                          opacity: t,
                          child: Text(
                            'Property Details',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: Dimensions.font18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              propertyImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                      AppConstants.getPngAsset('placeholder')),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PinnedHeaderDelegate(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radius45),
                        topRight: Radius.circular(Dimensions.radius45),
                      ),
                      child: Container(
                        color: AppColors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.height20),
                            Text(
                              propertyType, // Using the fetched property type
                              style: TextStyle(
                                fontSize: Dimensions.font28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              propertyLocation,
                              style: TextStyle(
                                fontSize: Dimensions.font18,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackColor.withOpacity(0.6),
                              ),
                            ),
                            SizedBox(height: Dimensions.height20),
                            Text(
                              propertyPrice,
                              style: TextStyle(
                                fontSize: Dimensions.font25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: Dimensions.height20),
                            _buildFeatureRow(args),
                            SizedBox(height: Dimensions.height20),
                            TabBar(
                              controller: _tabController,
                              indicatorColor: AppColors.blackColor,
                              labelColor: AppColors.blackColor,
                              unselectedLabelColor: Colors.grey,
                              tabs: const [
                                Tab(text: 'Description'),
                                Tab(text: 'Floor Plan'),
                                Tab(text: 'Virtual Tour'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildDescriptionTab(description),
                  _buildFloorPlanTab(floorplan),
                  _buildVirtualTourTab(videoLink),
                ],
              ),
            ),
            _buildFloatingActionBar(
              agentEmail,
              whatsappNumber,
              propertyType,
              propertyLocation,
              propertyPrice,
              propertyImage
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionTab(String description) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Text(
              description,
              style: TextStyle(fontSize: Dimensions.font16),
            ),
          ),
          SizedBox(height: Dimensions.height50),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20, vertical: Dimensions.height15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(2, 2),
                    blurRadius: Dimensions.radius20,
                  ),
                ]),
            child: _buildAgentInfo(),
          )
        ],
      ),
    );
  }

  Widget _buildFloorPlanTab(String? floorplan) {
    if (floorplan != null && floorplan.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.all(Dimensions.width15),
        child: Image.network(floorplan),
      );
    }
    return Center(child: Text('No floor plan available.'));
  }

  Widget _buildVirtualTourTab(String? videoLink) {
    if (videoLink != null && videoLink.isNotEmpty) {
      return Center(child: Text('Virtual Tour: $videoLink'));
    }
    return Center(child: Text('No virtual tour available.'));
  }

  Widget _buildFloatingActionBar(
    String email,
    String whatsappNumber,
    String propertyType,
    String propertyLocation,
    String propertyPrice,
      String propertyImage
  ) {
    // Pre-typed messages
    final emailMessage = Uri.encodeQueryComponent(
        'I am interested in the property at $propertyLocation. Here are the details:\n'
        '- Property Type: $propertyType\n'
        '- Price: $propertyPrice\n\n'
        'Please get back to me with more information.');
    final whatsappMessage = Uri.encodeComponent(
        'Hello, I am interested in the property at $propertyLocation. Here are the details:\n'
        '- Property Type: $propertyType\n'
        '- Price: $propertyPrice\n\n'
        'Can you please provide more information?');

    return Positioned(
      bottom: Dimensions.height20,
      left: Dimensions.width20,
      right: Dimensions.width20,
      child: Container(
        height: Dimensions.height67,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Email button
            Expanded(
              child: InkWell(
                onTap: () {
                 _recordInquiry(propertyType, propertyLocation, propertyPrice, propertyImage);
                  launchUrl(
                    Uri(
                      scheme: 'mailto',
                      path: email,
                      query: 'subject=Property Inquiry&body=$emailMessage',
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: AppColors.mainGradient,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius30),
                      bottomLeft: Radius.circular(Dimensions.radius30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mail_outline_rounded,
                          color: Colors.white, size: Dimensions.iconSize24),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        'Enquire',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // WhatsApp button
            Expanded(
              child: InkWell(
                onTap: () {
                  _recordInquiry(propertyType, propertyLocation, propertyPrice,propertyImage);
                  launchUrl(Uri.parse(
                      'https://wa.me/$whatsappNumber?text=$whatsappMessage'));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: AppColors.whatsappGradient,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radius30),
                      bottomRight: Radius.circular(Dimensions.radius30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.whatsapp,
                          color: Colors.white, size: Dimensions.iconSize24),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        'Enquire',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: Dimensions.height50,
              width: Dimensions.width50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppConstants.getPngAsset('logo')),
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RHEEL ESTATE',
                  style: TextStyle(
                      fontSize: Dimensions.font16, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Property Owner',
                  style: TextStyle(
                      fontSize: Dimensions.font14, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.agentProfile);
          },
          child: Text(
            'View Profile',
            style: TextStyle(
              color: AppColors.accentColor,
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFeatureRow(Map<String, dynamic>? args) {
    final beds = args?['beds']?.toString() ?? '0';
    final baths = args?['baths']?.toString() ?? '0';
    final livingRooms = args?['livingRooms']?.toString() ?? '0';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFeatureIcon(Icons.bed, '$beds Bed'),
        SizedBox(width: Dimensions.width15),
        _buildFeatureIcon(Icons.bathtub, '$baths Bath'),
        SizedBox(width: Dimensions.width15),
        _buildFeatureIcon(Icons.chair, '$livingRooms Living Room'),
      ],
    );
  }

  Widget _buildFeatureIcon(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: Dimensions.iconSize24, color: AppColors.accentColor),
        SizedBox(width: Dimensions.width10),
        Text(
          value,
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  PinnedHeaderDelegate({required this.child});

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  double get maxExtent => Dimensions.height100 * 2.56;

  @override
  double get minExtent => Dimensions.height100 * 2.56;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
