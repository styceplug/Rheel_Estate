import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rheel_estate/screens/guest_screens/guest_favourite_screen.dart';
import 'package:rheel_estate/screens/guest_screens/guest_inquiries_screen.dart';

import 'package:rheel_estate/screens/main_screens/home_screen.dart';

import 'package:rheel_estate/screens/main_screens/profile_screen.dart';
import 'package:rheel_estate/utils/colors.dart';
import 'package:rheel_estate/utils/dimensions.dart';


class GuestFloatingBar extends StatefulWidget {
  const GuestFloatingBar({super.key});

  @override
  State<GuestFloatingBar> createState() => _GuestFloatingBarState();
}

class _GuestFloatingBarState extends State<GuestFloatingBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const GuestFavouriteScreen(),
    const GuestInquiriesScreen(),
    const ProfileScreen(),
  ];

  final List<String> screenName = [
    'Home',
    'guestFavourite',
    'guestInquiries',
    'Profile',
  ];





  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],

      /// Display the currently selected screen
      body: Stack(
        children: [
          _screens[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Navigation bar background
                Positioned(
                  bottom: Dimensions.height24,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
                    height: Dimensions.height70,
                    decoration: BoxDecoration(
                      gradient: AppColors.mainGradient,
                      borderRadius: BorderRadius.circular(Dimensions.radius45),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: Dimensions.radius10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Iconsax.home, 0),
                        _buildNavItem(Iconsax.heart, 1),
                        _buildNavItem(Iconsax.clipboard_close, 2),
                        _buildNavItem(Iconsax.user, 3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Inactive icon widget
  Widget _buildNavItem(IconData icon, int index) {
    bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(8.0),
        decoration: isActive
            ? const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // Background for active tab
        )
            : null,
        // Transparent background for inactive tabs
        child: Icon(
          icon,
          size: Dimensions.iconSize24,
          color: isActive ? const Color(0xFF016D54) : Colors.white,
        ),
      ),
    );
  }
}
