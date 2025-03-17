import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/products_data.dart';

class InquiryController extends GetxController {
  final RxList<Map<String, dynamic>> inquiries = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInquiries(); // Load saved inquiries on app start
  }

  void recordInquiry(PropertiesModel property) {
    String formattedDate =
        DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());

    final Map<String, dynamic> inquiry = {
      "property": property.toJson(),
      "timestamp": formattedDate,
    };

    addInquiry(inquiry); // Add to list and save
  }

  void addInquiry(Map<String, dynamic> inquiry) async {
    inquiries.add(inquiry);
    _saveInquiries();
  }

  void _saveInquiries() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedInquiries = jsonEncode(inquiries);
    await prefs.setString('inquiries', encodedInquiries);
  }

  void _loadInquiries() async {
    final prefs = await SharedPreferences.getInstance();
    final storedInquiries = prefs.getString('inquiries');

    if (storedInquiries != null) {
      final decodedInquiries =
          List<Map<String, dynamic>>.from(jsonDecode(storedInquiries));

      inquiries.addAll(decodedInquiries);
    }
  }

  void clearInquiries() async {
    inquiries.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('inquiries');
  }

  void deleteInquiry(int index) async {
    if (index >= 0 && index < inquiries.length) {
      inquiries.removeAt(index);
      Get.snackbar(
        'Inquiries Removed',
        'Property removed from inquiries',
        backgroundColor: Colors.blue.withOpacity(0.8),
      );
      _saveInquiries();
    }
  }
}
