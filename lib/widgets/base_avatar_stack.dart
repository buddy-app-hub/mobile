import 'package:flutter/material.dart';

class BaseAvatarStack extends StatelessWidget {
  final List<String> avatars;

  const BaseAvatarStack({Key? key, required this.avatars}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: avatars.asMap().entries.map((entry) {
        final index = entry.key;
        final avatarUrl = entry.value;
        return Positioned(
          right: index * 35.0,
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(avatarUrl),
          ),
        );
      }).toList(),
    );
  }
}
