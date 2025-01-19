import 'package:get/get.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    Get.offAllNamed(AppRoutes.loginScreen); // Navigate back to login screen
  }

  // Check if user is signed in
  bool isUserLoggedIn() {
    return _supabase.auth.currentSession != null;
  }

  // Get current user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    return session?.user?.email;
  }
}
