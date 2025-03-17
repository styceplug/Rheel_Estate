import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rheel_estate/widgets/propertyImage.dart';
import 'package:rheel_estate/widgets/video_player_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/inquiries_controller.dart';
import '../../controllers/properties_controller.dart';
import '../../models/products_data.dart';
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
  late VideoPlayerController videoPlayerController;
  late PropertiesModel property;

  final PropertiesController propertiesController =
      Get.find<PropertiesController>();

  final InquiryController inquiryController =
      Get.find<InquiryController>();

  bool isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    property = Get.arguments;
    _tabController = TabController(length: 3, vsync: this);
    print("Received Property ID: ${property.id}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      property = Get.arguments;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    if (isVideoInitialized) {
      videoPlayerController.dispose();
    }
  }

  void initializeVideoPlayer(String videoUrl) {
    videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          isVideoInitialized = true;
        });
        videoPlayerController.play();
      });
  }

  void _recordInquiry(PropertiesModel property) async {
    String formattedDate =
        DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());

    final Map<String, dynamic> inquiry = {
      "property": property.toJson(),
      // Convert object to a JSON-compatible format
      "timestamp": formattedDate,
    };

    InquiryController inquiryController = Get.find<InquiryController>();
    inquiryController.addInquiry(inquiry);
  }

  void likeProperty() async {
    propertiesController.toggleFavorite(property);
  }

  String getPropertyType(int? propertyTypeValue) {
    switch (propertyTypeValue) {
      case 1:
        return 'Duplex';
      case 2:
        return 'Terrace';
      case 3:
        return 'Bungalow';
      case 4:
        return 'Apartment';
      case 5:
        return 'Commercial';
      case 6:
        return 'Carcass';
      case 7:
        return 'Land';
      case 8:
        return 'JV Land';
      default:
        return 'Unknown Property Type';
    }
  }

  @override
  Widget build(BuildContext context) {


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
                    Container(
                      alignment: Alignment.center,
                      height: Dimensions.height33,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.white),
                      child: IconButton(
                        icon: propertiesController.favorites
                                .any((fav) => fav.id == property.id)
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: Dimensions.iconSize20,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.black.withOpacity(0.6),
                                size: Dimensions.iconSize20,
                              ),
                        onPressed: likeProperty,
                      ),
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
                        /*background: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              child: CachedNetworkImage(
                                imageUrl: property.image.isNotEmpty
                                    ? property.image[0]
                                    : '',
                                width: double.maxFinite,
                                height: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // if(property.image.length>1) _buildPropertyImages(),
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
                        ),*/
                        background: PropertyImageSlider(images: property.image),


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
                              getPropertyType(property.propertyType),
                              // Using the fetched property type
                              style: TextStyle(
                                fontSize: Dimensions.font28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Iconsax.location,
                                    size: Dimensions.iconSize16),
                                SizedBox(width: Dimensions.width5),
                                Text(
                                  property.location,
                                  style: TextStyle(
                                    fontSize: Dimensions.font18,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        AppColors.blackColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₦ ${NumberFormat("#,##0", "en_US").format(property.price)}',
                                  style: TextStyle(
                                    fontSize: Dimensions.font25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: Dimensions.height10,
                                      width: Dimensions.width10,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: property.finance
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    SizedBox(width: Dimensions.width5),
                                    Text(
                                      'Finance:',
                                      style: TextStyle(
                                          fontSize: Dimensions.font15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                        width: Dimensions.width10 /
                                            Dimensions.width5),
                                    Text(property.finance ? 'True' : 'False'),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: Dimensions.height10),
                            _buildFeatureRow(context),
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
                            SizedBox(height: Dimensions.height10)
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
                  _buildDescriptionTab(property.description),
                  _buildFloorPlanTab(property.floorplan),
                  VirtualTourScreen(videoUrl: property.videoLink.first),
                ],
              ),
            ),
            _buildFloatingActionBar(property),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionTab(String description) {


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(fontSize: Dimensions.font16),
                ),
                SizedBox(height: Dimensions.height10),
                Text(
                  'Amenities: ${property.amenities.join(', ')}',
                  style: TextStyle(fontSize: Dimensions.font16),
                ),
              ],
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

  Widget _buildFloorPlanTab(List<String>? floorplans) {
    if (floorplans == null) {
      return Center(
        child: Text('No floor plan available'),
      );
    }
    if (floorplans.isEmpty) {
      return Center(
        child: Text('No floor plan available.'),
      );
    }

    return Padding(
      padding: EdgeInsets.all(Dimensions.width15),
      child: ListView.separated(
        itemCount: property.floorplan.length,
        separatorBuilder: (context, index) => SizedBox(height: Dimensions.height10),
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: property.floorplan[index],
            placeholder: (context, url) {
              // Show progress indicator only for the first image
              if (index == 0) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              } else {
                return SizedBox(); // Empty widget for other images
              }
            },
          );
        },
      ),
    );
  }


  Widget _buildFloatingActionBar(PropertiesModel property) {
    // Pre-typed messages
    final emailMessage = Uri.encodeComponent(
        'I am interested in the property at ${property.location} . Here are the details:\n'
        '- Property Type: ${getPropertyType(property.propertyType)}'
        '- Property ID: ${property.id}'
        '- Property Location: ${property.location}'
        '- Price: ${property.price}\n\n'
        'Please get back to me with more information.');
    final whatsappMessage = Uri.encodeComponent(
        'Hello, I am interested in the property at ${property.location}. Here are the details:\n'
        '- Property Type: ${getPropertyType(property.propertyType)}\n'
        '- Property ID: ${property.id}\n'
        '- Property Location: ${property.location}\n'
        '- Price: ${property.price}\n\n'
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
                  inquiryController.recordInquiry(property);
                  launchUrl(
                    Uri(
                      scheme: 'mailto',
                      path: 'hello@rheelestate.com',
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
                  inquiryController.recordInquiry(property);
                  launchUrl(Uri.parse(
                      'https://wa.me/2348099222223?text=$whatsappMessage'));
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

  Widget _buildFeatureRow(Map) {


    final beds = '${property.bedroom} Bed';
    final baths = '${property.bathroom} Bath';
    final livingRooms = '${property.livingRoom} Living Room';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFeatureIcon(Icons.bed, beds),
        SizedBox(width: Dimensions.width15),
        _buildFeatureIcon(Icons.bathtub, baths),
        SizedBox(width: Dimensions.width15),
        _buildFeatureIcon(Icons.chair, livingRooms),
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

  Widget _buildPropertyImages() {
    List<String> images = property.image;

    if (images.isEmpty) {
      return SizedBox(); // If there are no images, return an empty widget.
    }

    return Stack(
      children: [
        SizedBox(
          height: Dimensions.height20 * 10, // Adjust the height as needed.
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: Dimensions.width10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    width: double.maxFinite,
                    height: Dimensions.height20 * 10,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child:  CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child:  Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Add a scroll indicator on top of the images.
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.width5, right: Dimensions.width5),
                child: Container(
                  width: index == images.length - 1 ? 8 : 6,
                  // Adjust for the last dot.
                  height: 6,
                  decoration: BoxDecoration(
                    color: index == 0 ? AppColors.accentColor : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
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
