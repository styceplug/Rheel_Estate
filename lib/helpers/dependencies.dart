import 'package:rheel_estate/controllers/auth_controller.dart';
import 'package:rheel_estate/controllers/banner_announcement_controller.dart';
import 'package:rheel_estate/controllers/inquiries_controller.dart';
import 'package:rheel_estate/controllers/properties_controller.dart';
import 'package:rheel_estate/controllers/user_controller.dart';
import 'package:rheel_estate/data/api/api_client.dart';
import 'package:rheel_estate/data/repo/auth_repo.dart';
import 'package:rheel_estate/data/repo/banner_announcement_repo.dart';
import 'package:rheel_estate/data/repo/properties_repo.dart';
import 'package:rheel_estate/data/repo/user_repo.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  //api clients
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  //repos
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => UserRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      PropertiesRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => BannerAnnouncementRepo(apiClient: Get.find()));

  //controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => PropertiesController(propertiesRepo: Get.find()));
  Get.lazyPut(() => InquiryController());
  Get.lazyPut(() => BannerAnnouncementController(bannerAnnouncementRepo: Get.find()));
}


