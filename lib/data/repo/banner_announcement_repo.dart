import 'package:get/get_connect/http/src/response/response.dart';
import 'package:rheel_estate/data/api/api_client.dart';
import 'package:rheel_estate/utils/app_constants.dart';

class BannerAnnouncementRepo {
  final ApiClient apiClient;

  BannerAnnouncementRepo({required this.apiClient});

  Future<Response> getBanners() async {
    return await apiClient.getData(AppConstants.GET_BANNERS);
  }

  Future<Response> getAnnouncement() async {
    return await apiClient.getData(AppConstants.GET_ANNOUNCEMENTS);
  }
}
