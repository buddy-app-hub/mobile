import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BaseAvatarStack extends StatelessWidget {
  final List<String> avatars;
  final double spacing;
  final double parentContainerHeight;

  const BaseAvatarStack({Key? key, required this.avatars, this.spacing = 50.0, this.parentContainerHeight = 60.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (avatars.length - 1) * spacing + parentContainerHeight,
      child: Stack(
        alignment: Alignment.centerRight,
        children: avatars.asMap().entries.map((entry) {
          final index = entry.key;
          final avatarUrl = entry.value;
          return Positioned(
            right: index * spacing,
            child: CircleAvatar(
              radius: parentContainerHeight / 2,
              backgroundImage: avatarUrl.isEmpty
                  ? const AssetImage('assets/images/default_user.jpg')
                  : CachedNetworkImageProvider(avatarUrl) as ImageProvider,
            ),
          );
        }).toList(),
      ),
    );
  }
}
