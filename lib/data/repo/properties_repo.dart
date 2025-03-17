import 'package:rheel_estate/data/api/api_client.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertiesRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  PropertiesRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> getProperties() async {
    return await apiClient.getData(AppConstants.GET_PROPERTIES);
  }

  Future<Response> getAnnouncement() async {
    return await apiClient.getData(AppConstants.GET_ANNOUNCEMENTS);
  }

  Future<Response> getBanners(String sellerId) async {
    return await apiClient.getData(AppConstants.GET_BANNERS);
  }

}
