import 'package:rheel_estate/data/repo/auth_repo.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repo/auth_repo.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo,
  });}

