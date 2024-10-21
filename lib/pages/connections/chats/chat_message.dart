import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final String senderName;
  final Timestamp timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.senderName,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (!isUser)
          //   Text(
          //     senderName,
          //     style: ThemeTextStyle.titleSmallOnBackground(context),
          //   ),
          Container(
            decoration: BoxDecoration(
              color: isUser ? theme.primaryColor : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  child: Text(
                    text,
                    style: isUser
                        ? ThemeTextStyle.titleSmallOnPrimary(context)
                        : ThemeTextStyle.titleSmallOnBackground(context),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  getHourFromTimestamp(timestamp),
                  style: isUser
                      ? ThemeTextStyle.titleSmallerOnPrimary(context)
                      : ThemeTextStyle.titleSmallerOnBackground(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
