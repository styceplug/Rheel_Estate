import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../utils/dimensions.dart';

class PropertyImageSlider extends StatefulWidget {
  final List<String> images;

  const PropertyImageSlider({Key? key, required this.images}) : super(key: key);

  @override
  _PropertyImageSliderState createState() => _PropertyImageSliderState();
}

class _PropertyImageSliderState extends State<PropertyImageSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentIndex < widget.images.length - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.jumpToPage(0); // Loop back to the first image
      }
    });
  }

  /*void _openImagePreview(int index) {
    PageController _pageController = PageController(initialPage: index);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8), // Dim background
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Fully transparent background
          insetPadding: EdgeInsets.zero, // Makes it fullscreen
          child: Stack(
            children: [
              // Image Viewer
              PhotoViewGallery.builder(
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                scrollPhysics: BouncingScrollPhysics(),
                itemCount: widget.images.length,
                builder: (context, i) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(widget.images[i]),
                    initialScale: PhotoViewComputedScale.contained,
                  );
                },
                pageController: _pageController,
              ),

              // Left Arrow (Previous)
              Positioned(
                left: 20,
                top: MediaQuery.of(context).size.height * 0.5 - 25,
                child: GestureDetector(
                  onTap: () {
                    if (_pageController.page! > 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Icon(Icons.chevron_left, size: 50, color: Colors.white),
                ),
              ),

              // Right Arrow (Next)
              Positioned(
                right: 20,
                top: MediaQuery.of(context).size.height * 0.5 - 25,
                child: GestureDetector(
                  onTap: () {
                    if (_pageController.page! < widget.images.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Icon(Icons.chevron_right, size: 50, color: Colors.white),
                ),
              ),

              // Close Button
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }*/

  void _openImagePreview(int index) {
    PageController _pageController = PageController(initialPage: index);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Fully transparent background
          insetPadding: EdgeInsets.zero, // Removes default padding
          child: Stack(
            children: [
              // Reduced Blur White Background
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Softer blur effect
                  child: Container(
                    color: Colors.white.withOpacity(0.2), // Light white overlay
                  ),
                ),
              ),

              // Full-Screen Image Preview with PageView Controller
              SizedBox.expand(
                child: PhotoViewGallery.builder(
                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                  scrollPhysics: BouncingScrollPhysics(),
                  itemCount: widget.images.length,
                  pageController: _pageController,
                  builder: (context, i) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: CachedNetworkImageProvider(widget.images[i]),
                      initialScale: PhotoViewComputedScale.contained,
                    );
                  },
                  onPageChanged: (i) {
                    index = i; // Update the current index
                  },
                ),
              ),

              // Navigation Arrows (Now they control the PageView)
              Positioned(
                left: Dimensions.width10*1.6,
                top: MediaQuery.of(context).size.height * 0.45,
                child: IconButton(
                  icon: Icon(Icons.chevron_left, size: Dimensions.iconSize30*1.4, color: Colors.white),
                  onPressed: () {
                    if (index > 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
              Positioned(
                right: Dimensions.width10*1.6,
                top: MediaQuery.of(context).size.height * 0.45,
                child: IconButton(
                  icon: Icon(Icons.chevron_right, size: Dimensions.iconSize30*1.4, color: Colors.white),
                  onPressed: () {
                    if (index < widget.images.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),

              // Close Button
              Positioned(
                top: Dimensions.height40,
                right: Dimensions.width20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: Dimensions.iconSize30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.images.isNotEmpty)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _autoScrollTimer?.cancel();
                },
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _openImagePreview(index);
                      },
                      child: Stack(children: [
                        CachedNetworkImage(
                          imageUrl: widget.images[index],
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: Colors.red),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ),
          // Gradient Overlay

          // Scroll Indicator (Dots)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
