import 'package:flutter/material.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<String>? autofillHints;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.autofillHints,

  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofillHints: autofillHints,
      controller: controller,
      showCursor: true,
      cursorColor: AppColors.blackColor.withOpacity(0.6),
      decoration: InputDecoration(
        alignLabelWithHint: false,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height15,
        ),
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle:
            TextStyle(color: AppColors.blackColor, fontSize: Dimensions.font14),
        hintStyle: TextStyle(
          color: AppColors.blackColor.withOpacity(0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          borderSide: BorderSide(
            width: Dimensions.width5 / Dimensions.width20,
            color: AppColors.blackColor.withOpacity(0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          borderSide: BorderSide(
            width: Dimensions.width5 / Dimensions.width20,
            color: AppColors.blackColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          borderSide: BorderSide(
            width: Dimensions.width5 / Dimensions.width20,
            color: AppColors.blackColor.withOpacity(0.4),
          ),
        ),
      ),

    );
  }
}
