import 'dart:async';

import 'package:rheel_estate/data/repo/user_repo.dart';
import 'package:rheel_estate/models/user_model.dart';
import 'package:get/get.dart';


class UserController extends GetxController {
  final UserRepo userRepo;

  UserController({
    required this.userRepo,
  });

  Rx<UserModel?> user = Rx<UserModel?>(null);

  Future<void> saveUser(UserModel user) async {
    await userRepo.saveUser(user);
    this.user.value = user;
  }


  Future<void> loadUser() async {
    UserModel? loadedUser = await userRepo.getUser();
    if (loadedUser != null) {
      user.value = loadedUser;
    }
  }



}
