import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rheel_estate/controllers/properties_controller.dart';
import 'package:video_player/video_player.dart';

class VirtualTourScreen extends StatefulWidget {
  final String? videoUrl;

  const VirtualTourScreen({Key? key, this.videoUrl}) : super(key: key);

  @override
  _VirtualTourScreenState createState() => _VirtualTourScreenState();
}

class _VirtualTourScreenState extends State<VirtualTourScreen> {
  late VideoPlayerController _controller;
  bool isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    printVideoUrl(); // Print URL for debugging

    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      _controller = VideoPlayerController.network(widget.videoUrl!)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              isVideoInitialized = true;
            });
          }
          _controller.play(); // Auto-play the video
        });
    }
  }


  PropertiesController property = Get.find<PropertiesController>();


  void printVideoUrl() {
    print('Raw video_upload data: ${widget.videoUrl}');

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Adjust as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: isVideoInitialized
          ? ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              if (!_controller.value.isPlaying)
                const Icon(
                  Icons.play_circle_outline,
                  size: 50,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      )
          : const Center(
        child: CircularProgressIndicator(
          color: Colors.blue, // Replace with AppColors.accentColor if needed
        ),
      ),
    );
  }
}