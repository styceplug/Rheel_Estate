import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/announcement_model.dart';
import '../../screens/auth_screens/reset_password.dart';
import '../repo/banner_announcement_repo.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //INITIALIZE
  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettingsIOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
        android: initSettingsAndroid, iOS: initSettingsIOS);

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final url = response.payload!;
          if (url.isNotEmpty) {
            launchUrl(Uri.parse(url)); // Open the announcement link
          }
        }
      },
    );

    _isInitialized = true;
  }

  //NOTIFICATION DETAILS SETUP
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          "daily_channel_id", "Daily Notification",
          importance: Importance.max, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
    );
  }

//SHOW NOTIFICATIONS

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? link,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "announcement_channel_id",
          "Announcements",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: link, // Store the redirect link
    );
  }


  Future<void> promptLatestAnnouncement() async {

    final bannerAnnouncementRepo = Get.find<BannerAnnouncementRepo>();
    try {
      isLoading;
      Response response = await bannerAnnouncementRepo.getAnnouncement();

      if (response.statusCode == 200) {
        var responseData = response.body;

        if (responseData["status"] == true && responseData["data"] != null) {
          Announcement latestAnnouncement = Announcement.fromJson(responseData["data"]);

          // Show the latest announcement as a notification
          await NotiService().showNotification(
            id: latestAnnouncement.id,
            title: "New Announcement",
            body: latestAnnouncement.announcementText,
            link: latestAnnouncement.redirectLink,
          );
        }
      }
    } finally {
      isLoading;
    }
  }

//ON NOTI TAP
}
