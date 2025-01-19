
import 'package:flutter/material.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/app_constants.dart';

class ProfileImage extends StatelessWidget {
  final double size;

  const ProfileImage({super.key, required this.size});

  Future<Map<String, dynamic>?> _getUserMetadata() async {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.userMetadata;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserMetadata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: size,
            width: size,
            child: const CircularProgressIndicator(),
          );
        }

        final avatarUrl = snapshot.data?['avatar_url'];
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black.withOpacity(0.5),
              width: Dimensions.width5/Dimensions.width5,
            ),
          ),
          child: ClipOval(
            child: avatarUrl != null && avatarUrl.isNotEmpty
                ? Image.network(
              avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                AppConstants.getGifAsset('avatar'),
                fit: BoxFit.cover,
              ),
            )
                : Image.asset(
              AppConstants.getGifAsset('avatar'),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}