import 'package:flutter/material.dart';
import 'package:rheel_estate/auth/auth_gate.dart';
import 'package:rheel_estate/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rheel_estate/helpers/dependencies.dart' as dep;
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:get/get.dart';

import 'controllers/inquiries_controller.dart';
import 'controllers/properties_controller.dart';


Future<void> main() async {
  //supabase setup
  await Supabase.initialize(
      url: 'https://umfqnvnitnkjlxrvzcqt.supabase.co',
      anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVtZnFudm5pdG5ramx4cnZ6Y3F0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIwMDkzMDYsImV4cCI6MjAwNzU4NTMwNn0.szxlbURSr9LotiQcbSUVrlx4T3mTKTurQs10_ONjsgI');
  await dep.init();
  Get.put(PropertiesController());
  Get.put(InquiryController());
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const AuthGate(),
      title: 'Rheel Estate App',
      theme: ThemeData(
        primaryColor: AppColors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.white,
          secondary: AppColors.accentColor,
        ),
      ),
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.splashScreen,
    );
  }
}
