// lib/widgets/user_avatar.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({
    Key? key,
    this.avatarUrl,
    this.size = 40,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.grey[300],
        child: avatarUrl != null
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: avatarUrl!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.person),
                ),
              )
            : Icon(Icons.person, size: size * 0.6),
      ),
    );
  }
}