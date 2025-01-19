import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertiesController extends GetxController{

  final favorites = <Map<String, String>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }
/*
  void addFavorite(Map<String, String> product) {
    if (!favorites.any((fav) => fav['productImage'] == product['productImage'])) {
    favorites.add(product);
    _saveFavorites();

    Get.snackbar(
      "Added to Favorites",
      "${product['location']} has been added to your favorites.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(Icons.favorite,color: Colors.white,),
      duration: const Duration(seconds: 2),
    );
    } else {
      Get.snackbar(
        "Already in Favorites",
        "${product['location']} is already in your favorites.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.info, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    }
  }*/

  void addFavorite(Map<String, String> product) {
    if (!favorites.any((fav) => fav['productImage'] == product['productImage'])) {
      // Ensure all required fields are included
      favorites.add({
        'productImage': product['productImage'] ?? '',
        'propertyFor': product['propertyFor'] ?? '',
        'location': product['location'] ?? '',
        'price': product['price'] ?? '',
        'livingRooms': product['livingRooms'] ?? '0',
        'baths': product['baths'] ?? '0',
        'beds': product['beds'] ?? '0',
        'description': product['description'] ?? 'No description available.',
        'propertyType': product['propertyType'] ?? 'Unknown Type',
        'floorplan': product['floorplan'] ?? '',
        'videoLink': product['videoLink'] ?? '',
        'updatedAt': product['updatedAt'] ?? '',
        'images': jsonEncode(product['images'] ?? []),
      });
      _saveFavorites();

      Get.snackbar(
        "Added to Favorites",
        "${product['location']} has been added to your favorites.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.favorite, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        "Already in Favorites",
        "${product['location']} is already in your favorites.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.info, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removeFavorite(Map<String, String> product) {
    favorites.removeWhere((p) => p['productImage'] == product['productImage']);
    _saveFavorites();

    Get.snackbar(
      "Removed from Favorites",
      "${product['location']} has been removed from your favorites.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(Icons.delete_forever,color: Colors.white,),
      duration: const Duration(seconds: 2),
    );
  }

  /*void _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedFavorites = jsonEncode(favorites);
    await prefs.setString('favorites', encodedFavorites);
  }*/
  void _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedFavorites = jsonEncode(favorites.map((fav) {
      final updatedFav = Map<String, dynamic>.from(fav);
      updatedFav['images'] = jsonEncode(updatedFav['images']);
      return updatedFav;
    }).toList());
    await prefs.setString('favorites', encodedFavorites);
  }

  /*void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedFavorites = prefs.getString('favorites');
    if (encodedFavorites != null) {
      final decodedFavorites = List<Map<String, String>>.from(
        jsonDecode(encodedFavorites).map((item) => Map<String, String>.from(item)),
      );
      favorites.addAll(decodedFavorites);
    }
    isLoading.value = false;
  }*/
  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedFavorites = prefs.getString('favorites');
    if (encodedFavorites != null) {
      final decodedFavorites = List<Map<String, dynamic>>.from(
        jsonDecode(encodedFavorites),
      );
      favorites.addAll(
        decodedFavorites.map((item) => Map<String, String>.from(item)),
      );
    }
    isLoading.value = false;
  }
}

