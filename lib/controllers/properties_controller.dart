import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/data/repo/properties_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/products_data.dart';

class PropertiesController extends GetxController {
  final PropertiesRepo propertiesRepo;

  PropertiesController({
    required this.propertiesRepo,
  });

  final favorites = <PropertiesModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
    fetchProperties(properties);
  }

  RxList<PropertiesModel> properties = <PropertiesModel>[].obs;

  Future<void> fetchProperties(List<PropertiesModel> list) async {
    try {
      Response response = await propertiesRepo.getProperties();

      if (response.statusCode == 200) {
        final status = response.body['status'];

        var result = response.body;

        if (status == true) {
          var catData = result['data'];

          properties.value = (catData as List)
              .map((propertiesJson) => PropertiesModel.fromJson(propertiesJson))
              .toList();

          update();
        }
      }
    } catch (e, s) {
      print('Fetch Property Exception: $e stacktrace $s');
    }
  }

  void toggleFavorite(PropertiesModel property) async {
    // Check if the product is already in favorites
    bool isFavorite = favorites.any((fav) => fav.id == property.id);

    if (isFavorite) {
      // If the product is already in favorites, remove it
      removeFavorite(property);
    } else {
      // If the product is not in favorites, add it
      addFavorite(property);
    }
  }

  void addFavorite(PropertiesModel property) {
    favorites.add(property); // Directly add the map to the favorites list
    _saveFavorites();

    Get.snackbar(
      "Added to Favorites",
      "${property.location} has been added to your favorites.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(Icons.favorite, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
    update();
  }

  void _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
   /* final encodedFavorites = jsonEncode(favorites.map((fav) {
      final updatedFav = Map<String, dynamic>.from(fav.toJson());
      updatedFav['id'] = jsonEncode(updatedFav['id']);
      return updatedFav;
    }).toList());*/
    final encodedFavorites = jsonEncode(favorites.map((fav) => fav.toJson()).toList());
    await prefs.setString('favorites', encodedFavorites);
    print("Saved favorites: $encodedFavorites");
  }

  /*void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedFavorites = prefs.getString('favorites');
    if (encodedFavorites != null) {
      final decodedFavorites = List<Map<String, dynamic>>.from(
        jsonDecode(encodedFavorites),
      );
      favorites.addAll(
        decodedFavorites.map((item) => PropertiesModel.fromJson(item)),
      );
    }
    isLoading.value = false;
    update();
  }*/

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedFavorites = prefs.getString('favorites');

    print("Loaded favorites from storage: $encodedFavorites"); // Debugging

    if (encodedFavorites != null) {
      final decodedFavorites = List<Map<String, dynamic>>.from(
        jsonDecode(encodedFavorites),
      );

      favorites.clear(); // ✅ Clear list before loading data

      favorites.addAll(
        decodedFavorites.map((item) => PropertiesModel.fromJson(item)),
      );
    }
    isLoading.value = false;
    update();
  }

  void removeFavorite(PropertiesModel property) {
    favorites.removeWhere((p) => p.id == property.id);

    Get.snackbar(
      "Removed from Favorites",
      "${property.location} has been removed from your favorites.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(
        Icons.delete_forever,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 2),
    );
    update();
  }
}
