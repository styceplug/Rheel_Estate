import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class PropertyDetailsScreenRedesigned extends StatefulWidget {
  const PropertyDetailsScreenRedesigned({super.key});

  @override
  State<PropertyDetailsScreenRedesigned> createState() =>
      _PropertyDetailsScreenRedesignedState();
}

class _PropertyDetailsScreenRedesignedState
    extends State<PropertyDetailsScreenRedesigned>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: Dimensions.height100 * 4.9,
              pinned: true,
              backgroundColor: AppColors.accentColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: AppColors.white),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final double appBarHeight = Dimensions.height100 * 4.9;
                  final double t = (1.0 -
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
                        Image.asset(
                          AppConstants.getPngAsset('property1'),
                          fit: BoxFit.cover,
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
                    topLeft: Radius.circular(
                        Dimensions.radius45 + Dimensions.radius5),
                    topRight: Radius.circular(
                        Dimensions.radius45 + Dimensions.radius5),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            Dimensions.radius45 + Dimensions.radius5),
                        topRight: Radius.circular(
                            Dimensions.radius45 + Dimensions.radius5),
                      ),
                      color: AppColors.white,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: Dimensions.height20),
                        Text(
                          'Classic Apartment',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: Dimensions.font28,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'New Boston',
                          style: TextStyle(
                            fontSize: Dimensions.font18,
                            fontFamily: 'Poppins',
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildFeatureIcon('bed', '3'),
                            SizedBox(width: Dimensions.width30),
                            _buildFeatureIcon('bath', '2'),
                            SizedBox(width: Dimensions.width30),
                            _buildFeatureIcon('living-room', '5'),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),
                        Text(
                          'N 1,135,000.00',
                          style: TextStyle(
                            fontSize: Dimensions.font25,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),
                        TabBar(
                          controller: _tabController,
                          indicatorColor: AppColors.blackColor,
                          labelColor: AppColors.blackColor,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
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
              // Description Tab
              Container(
                height: Dimensions.height100 * 3,
                width: Dimensions.screenWidth,
                margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: _buildDescriptionTab(),
              ),

              // Floor Plan Tab
              Container(
                height: Dimensions.height100 * 3,
                width: Dimensions.screenWidth,
                margin: EdgeInsets.all(Dimensions.width15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AppConstants.getPngAsset('property3'),
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),

              // Virtual Tour Tab
              Center(
                child: Icon(Icons.videocam, size: Dimensions.height100),
              ),
            ],
          ),
        ),
          Positioned(
            bottom: Dimensions.height40,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Container(
              height: Dimensions.height67,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Slightly transparent background
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Subtle shadow for floating effect
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
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
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Handle WhatsApp enquiry action
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
          ),
      ]
      ),

    );
  }

  Widget _buildDescriptionTab() {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width15),
      child: Column(
        children: [
          Text(
            'This luxurious builder floor is strategically located at Boston. '
            'The apartment comes with all modern facilities. The house features '
            'wooden cabinets & modular fittings in the kitchen. See More.',
            style: TextStyle(
              fontSize: Dimensions.font15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: Dimensions.height50),
          _buildAgentInfo()
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(String assetName, String value) {
    return Row(
      children: [
        Container(
          height: Dimensions.height20,
          width: Dimensions.width20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppConstants.getPngAsset(assetName)),
            ),
          ),
        ),
        SizedBox(width: Dimensions.width10),
        Text(
          value,
          style: TextStyle(
            fontSize: Dimensions.font18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
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
                    image: AssetImage(AppConstants.getPngAsset('logo')))),
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
              )
            ],
          ),
        ],
      ),
      InkWell(
        onTap: (){
          Get.toNamed(AppRoutes.agentProfile);
        },
        child: Text(
          'View Profile',
          style: TextStyle(
              color: AppColors.accentColor,
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w600),
        ),
      )
    ],
  );
}

class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  PinnedHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => Dimensions.height100 * 2.56; // Match content height
  @override
  double get minExtent =>
      Dimensions.height100 * 2.56; // Same as maxExtent for fixed height

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // Optimize performance by rebuilding only when necessary
  }
}
