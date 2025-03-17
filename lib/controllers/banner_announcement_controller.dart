import 'package:get/get.dart';
import 'package:rheel_estate/data/repo/banner_announcement_repo.dart';
import 'package:rheel_estate/models/banner_model.dart';

import '../data/services/noti_service.dart';
import '../models/announcement_model.dart';

class BannerAnnouncementController extends GetxController {
  final BannerAnnouncementRepo bannerAnnouncementRepo;

  BannerAnnouncementController({required this.bannerAnnouncementRepo});

  var banners = [].obs;
  var announcements = [].obs;
  var isLoading = false.obs;

  Future<void> getBanners() async {
    try {
      isLoading(true);
      Response response = await bannerAnnouncementRepo.getBanners();
      if (response.statusCode == 200) {
        var data = response.body; // This is a Map<String, dynamic>
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          List<dynamic> bannerList = data['data']; // Extract the list
          banners.value = bannerList.map((e) => BannerModel.fromJson(e)).toList();
        } else {
          print("Unexpected response format: $data");
        }
      }
    } catch (e) {
      print("Error fetching banners: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> getAnnouncements() async {
    try {
      isLoading(true);
      Response response = await bannerAnnouncementRepo.getAnnouncement();

      if (response.statusCode == 200) {
        var responseData = response.body;

        if (responseData["status"] == true && responseData["data"] is List) {
          List<Announcement> newAnnouncements = (responseData["data"] as List)
              .map((item) => Announcement.fromJson(item))
              .toList();

          if (newAnnouncements.isNotEmpty) {
            final latestAnnouncement = newAnnouncements.first;
            await NotiService().showNotification(
              id: latestAnnouncement.id,
              title: "New Announcement",
              body: latestAnnouncement.announcementText,
              link: latestAnnouncement.redirectLink, // Pass link for deep linking
            );
          }

          announcements.value = newAnnouncements; // Store announcements
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
