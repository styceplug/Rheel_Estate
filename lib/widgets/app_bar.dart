import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:rheel_estate/routes/routes.dart";

import "../utils/colors.dart";
import "../utils/dimensions.dart";

AppBar buildAppBar(String title, ) {
  return AppBar(
    leading: InkWell(
      onTap: () {
        Get.offNamed(AppRoutes.floatingBar);
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
    toolbarHeight: Dimensions.height50 * 1.3,
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(
      title,
      style:
          TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.font22),
    ),
  );
}
