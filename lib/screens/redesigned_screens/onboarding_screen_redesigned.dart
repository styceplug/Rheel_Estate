import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/routes/routes.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:rheel_estate/utils/dimensions.dart';

class OnboardingScreenRedesigned extends StatefulWidget {
  const OnboardingScreenRedesigned({super.key});

  @override
  State<OnboardingScreenRedesigned> createState() =>
      _OnboardingScreenRedesignedState();
}

class _OnboardingScreenRedesignedState extends State<OnboardingScreenRedesigned>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final Timer _timer;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  List<String> images = [
    AppConstants.getPngAsset('onBoardBg1'),
    AppConstants.getPngAsset('onBoardBg2'),
    AppConstants.getPngAsset('onBoardBg3'),
  ];

  List<Map<String, String>> texts = [
    {
      'title': 'Perfect Choice',
      'subtitle': 'for your future',
      'description': 'Buy or lease with absolute peace\nof mind',
    },
    {
      'title': 'No Hassle',
      'subtitle': 'with Rheel',
      'description': 'We are the only bridge between you\nand the property owner.',
    },
    {
      'title': 'Discounts',
      'subtitle': 'the Rheel way',
      'description': 'Get a discount on any property\npurchased with us',
    },
  ];



  @override
  void initState() {
    super.initState();

    // Auto-scroll logic
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentPage < images.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _timer.cancel();
      }
    });

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Animation speed
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start slightly below
      end: Offset.zero, // Slide up into position
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant OnboardingScreenRedesigned oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A2F1E),
      body: SizedBox(
        width: Dimensions.screenWidth,
        height: Dimensions.screenHeight,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: _CustomPageViewScrollPhysics(
                isOnLastPage: _currentPage == images.length - 1,
              ),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _animationController.reset();
                  _animationController.forward();
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(images[index]),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: Dimensions.height50 * 1.2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with animation
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          texts[_currentPage]['title']!,
                          style: TextStyle(
                            fontSize: Dimensions.font30 * 1.65,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle with animation
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          texts[_currentPage]['subtitle']!,
                          style: TextStyle(
                            fontSize: Dimensions.font30 * 1.5,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Description with animation
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          texts[_currentPage]['description']!,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Dimensions.height30),
                    SizedBox(
                      width: Dimensions.screenWidth,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                images.length - 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimensions.font17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: List.generate(images.length, (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width5),
                                child: _currentPage == index
                                    ? CircleAvatar(
                                  radius: Dimensions.width10,
                                  backgroundColor: Colors.white,
                                )
                                    : Container(
                                  width: Dimensions.width20,
                                  height: Dimensions.width5,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius:
                                    BorderRadius.circular(5),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: _currentPage == images.length - 1
                                ? () {
                              Get.offAllNamed(AppRoutes.loginScreen);
                            }
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width25,
                                  vertical: Dimensions.height15),
                              decoration: BoxDecoration(
                                color: _currentPage == images.length - 1
                                    ? Colors.white
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius30),
                              ),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: _currentPage == images.length - 1
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: Dimensions.font17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.width40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CustomPageViewScrollPhysics extends ScrollPhysics {
  final bool isOnLastPage;

  const _CustomPageViewScrollPhysics({required this.isOnLastPage, super.parent});

  @override
  _CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _CustomPageViewScrollPhysics(
      isOnLastPage: isOnLastPage,
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (isOnLastPage && offset < 0) {
      return offset; // Allow scrolling left
    } else if (isOnLastPage && offset > 0) {
      return 0.0; // Prevent scrolling right
    }
    return offset;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }
}