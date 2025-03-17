import 'package:flutter/material.dart';
import 'package:rheel_estate/controllers/auth_controller.dart';
import 'package:rheel_estate/controllers/banner_announcement_controller.dart';
import 'package:rheel_estate/helpers/dependencies.dart' as dep;
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:get/get.dart';
import 'controllers/inquiries_controller.dart';
import 'controllers/properties_controller.dart';
import 'controllers/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dep.init(); // Initialize dependencies
  } catch (e, stackTrace) {
    print("Dependency initialization error: $e");
    print(stackTrace);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_) {
      return GetBuilder<UserController>(builder: (_) {
        return GetBuilder<PropertiesController>(builder: (_) {
          return GetBuilder<InquiryController>(builder: (_) {
            return GetBuilder<BannerAnnouncementController>(builder: (_) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Rheel Estate App',
                theme: ThemeData(
                  primaryColor: AppColors.white,
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: AppColors.white,
                    secondary: AppColors.accentColor,
                  ),
                ),
                getPages: AppRoutes.routes,
                initialRoute: AppRoutes.splashScreen,
              );
            });
          });
        });
      });
    });
  }
}
