import 'package:get/get.dart';

class InquiryController extends GetxController {
  final RxList<Map<String, String>> inquiries = <Map<String, String>>[].obs;

  void addInquiry(Map<String, String> inquiry) {
    inquiries.add(inquiry);
  }
}