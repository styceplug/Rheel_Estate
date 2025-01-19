

import 'package:flutter/material.dart';
import 'package:rheel_estate/screens/auth_screens/login_screen.dart';
import 'package:rheel_estate/screens/main_screens/home_screen.dart';
import 'package:rheel_estate/widgets/floating_bar.dart';
import 'package:rheel_estate/widgets/guest_floating_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      // Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Handle auth state changes
        final authState = snapshot.data;

        if (authState == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final session = authState.session;

          if (session != null) {
            // Check if email is present
            final email = session.user?.email;

            if (email == null || email.isEmpty) {
              // Handle case when email is missing
              return const GuestFloatingBar();
            } else {
              // Handle authenticated state
              return const FloatingBar();
            }
          } else {
            // User is not signed in
            return const LoginScreen();
          }
        }
      },
    );
  }
}
