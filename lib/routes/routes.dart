

import 'package:get/get.dart';
import 'package:rheel_estate/auth/auth_gate.dart';
import 'package:rheel_estate/screens/additional_screens/about_us.dart';
import 'package:rheel_estate/screens/additional_screens/agent_profile.dart';
import 'package:rheel_estate/screens/additional_screens/book_appointment.dart';
import 'package:rheel_estate/screens/additional_screens/faq_screen.dart';
import 'package:rheel_estate/screens/additional_screens/privacy_policy.dart';
import 'package:rheel_estate/screens/additional_screens/property_details_screen.dart';
import 'package:rheel_estate/screens/additional_screens/see_all_properties.dart';
import 'package:rheel_estate/screens/additional_screens/term_and_conditions.dart';
import 'package:rheel_estate/screens/auth_screens/login_screen.dart';
import 'package:rheel_estate/screens/auth_screens/signup_screen.dart';
import 'package:rheel_estate/screens/guest_screens/guest_favourite_screen.dart';
import 'package:rheel_estate/screens/guest_screens/guest_inquiries_screen.dart';
import 'package:rheel_estate/screens/main_screens/favourite_screen.dart';
import 'package:rheel_estate/screens/redesigned_screens/onboarding_screen_redesigned.dart';
import 'package:rheel_estate/screens/redesigned_screens/property_details_screen_redesigned.dart';
import 'package:rheel_estate/screens/splash_onboard/onboarding_screen.dart';
import 'package:rheel_estate/widgets/floating_bar.dart';
import 'package:rheel_estate/widgets/guest_floating_bar.dart';

import '../main.dart';
import '../screens/main_screens/home_screen.dart';
import '../screens/splash_onboard/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String onboardingScreen = '/onboarding-screen';
  static const String signupScreen = '/signup-screen';
  static const String homeScreen = '/home-screen';
  static const String favouriteScreen = '/favourite-screen';
  static const String floatingBar = '/floating-bar';
  static const String seeAllPropertiesScreen = '/see-all-properties-screen';
  static const String propertyDetailsScreen = '/property-details-screen';
  static const String authGate = '/auth-gate';
  static const String faqScreen = '/faq-screen';
  static const String aboutUs = '/about-us';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String guestFavouriteScreen = '/guest-favourite-screen';
  static const String guestInquiriesScreen = '/guest-inquiries-screen';
  static const String guestFloatingBar = '/guest-floating-bar';
  static const String agentProfile = '/agent-profile';
  static const String bookAppointment = '/book-appointment';
  static const String onboardingScreenRedesigned = '/onboarding-screen-redesigned';
  static const String propertyDetailsScreenRedesigned = '/property-details-screen-redesigned';



  static final routes = [
    /*GetPage(
      name: homeScreen,
      page: () {
        final int startingPage = Get.arguments as int;
        return HomeScreen(
          home: startingPage,
        );
      },
      transition: Transition.fadeIn,
    ),*/
    GetPage(
      name: splashScreen,
      page: () {
        return const SplashScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: loginScreen,
      page: () {
        return const LoginScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboardingScreen,
      page: () {
        return const OnboardingScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signupScreen,
      page: () {
        return const SignupScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: homeScreen,
      page: () {
        return const HomeScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: favouriteScreen,
      page: () {
        return  FavouriteScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: floatingBar,
      page: () {
        return const FloatingBar();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: seeAllPropertiesScreen,
      page: () {
        return const SeeAllProperties();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/propertyDetails',
      page: () => const PropertyDetailsScreen(),
    ),
    GetPage(
      name: authGate,
      page: () {
        return const AuthGate();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: faqScreen,
      page: () {
        return const FaqScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: aboutUs,
      page: () {
        return const AboutUs();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: privacyPolicy,
      page: () {
        return const PrivacyPolicy();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: termsAndConditions,
      page: () {
        return const TermAndConditions();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: guestFavouriteScreen,
      page: () {
        return const GuestFavouriteScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: guestInquiriesScreen,
      page: () {
        return const GuestInquiriesScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: guestFloatingBar,
      page: () {
        return const GuestFloatingBar();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: agentProfile,
      page: () {
        return const AgentProfile();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bookAppointment,
      page: () {
        return const BookAppointment();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboardingScreenRedesigned,
      page: () {
        return const OnboardingScreenRedesigned();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: propertyDetailsScreenRedesigned,
      page: () {
        return const PropertyDetailsScreenRedesigned();
      },
      transition: Transition.fadeIn,
    ),

  ];
}



