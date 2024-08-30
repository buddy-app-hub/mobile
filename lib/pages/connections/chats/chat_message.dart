import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;
  final String senderName;
  final Timestamp timestamp;

  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.senderName,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (!isMe)
          //   Text(
          //     senderName,
          //     style: ThemeTextStyle.titleSmallOnBackground(context),
          //   ),
          Container(
            decoration: BoxDecoration(
              color: isMe ? theme.primaryColor : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  text,
                  style: isMe ? ThemeTextStyle.titleSmallOnPrimary(context) : ThemeTextStyle.titleSmallOnBackground(context),
                ),
                SizedBox(width: 16),
                Text(
                  getHourFromTimestamp(timestamp),
                  style: isMe ? ThemeTextStyle.titleSmallerOnPrimary(context) : ThemeTextStyle.titleSmallerOnBackground(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}