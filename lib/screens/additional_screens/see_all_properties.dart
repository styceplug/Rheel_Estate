import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/properties_controller.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/product_card.dart';

class SeeAllProperties extends StatefulWidget {
  const SeeAllProperties({super.key});

  @override
  State<SeeAllProperties> createState() => _SeeAllPropertiesState();
}

class _SeeAllPropertiesState extends State<SeeAllProperties> {
  final PropertiesController propertiesController = Get.find<PropertiesController>();
  String selectedFilter = 'All';
  bool isLoading = false;

  Future<void> refreshProperties() async {
    setState(() {
      isLoading = true;
    });

    try {
      await propertiesController.fetchProperties(
          propertiesController.properties); // Fetch the latest properties
    } catch (e) {
      debugPrint("Error refreshing properties: $e");
      Get.snackbar("Error", "Failed to refresh properties");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  void initState() {
    super.initState();
    propertiesController.fetchProperties(propertiesController.properties);
    refreshProperties();
  }

  void _selectFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (propertiesController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0A2F1E)),
          );
        }

        final properties = selectedFilter == 'All'
            ? propertiesController.properties
            : propertiesController.properties
            .where((property) => _getPropertyFilter(property.propertyFor) == selectedFilter)
            .toList();

        return Column(
          children: [
            _buildFilterOptions(),
            Expanded(
              child: properties.isEmpty
                  ? const Center(child: Text('No properties found.'))
                  : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                itemCount: properties.length,
                separatorBuilder: (_, __) => SizedBox(height: Dimensions.height20),
                itemBuilder: (context, index) {
                  return ProductCard(property: properties[index]);
                },
              ),
            ),
            SizedBox(height: Dimensions.height30)
          ],
        );
      }),
    );
  }

  // This method maps the filter option to the correct database value
  String _getPropertyFilter(String propertyFor) {
    switch (propertyFor) {
      case 'Sell':
        return 'For Sale';
      case 'Lease':
        return 'To Lease';
      default:
        return 'All';
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      toolbarHeight: Dimensions.height50 * 1.2,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Container(
        height: Dimensions.height10 * 15,
        width: Dimensions.width10 * 15,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppConstants.getPngAsset('logo'))),
        ),
      ),
      leading: InkWell(
        onTap: () => Get.back(),
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
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.height20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFilterOption('All'),
          _buildFilterOption('For Sale'),
          _buildFilterOption('To Lease'),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String filter) {
    final bool isActive = selectedFilter == filter;
    return GestureDetector(
      onTap: () => _selectFilter(filter),
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
              : Border.all(color: Colors.grey.withOpacity(0.5), width: Dimensions.width5 / Dimensions.width20),
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