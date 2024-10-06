import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';

class BaseCard extends StatelessWidget {
  final String title;
  final String location;
  final String rate;
  final String reviews;
  final String time;
  final String description;
  final String image;

  const BaseCard({
    super.key,
    required this.title,
    required this.location,
    required this.rate,
    required this.reviews,
    required this.time,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        color: theme.colorScheme.secondaryContainer,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: theme.colorScheme.primaryContainer,
          onTap: () {
            debugPrint('Item tapped.');
          },
          child: SizedBox(
            width: 375,
            height: 175,
            child: _buildItemInfo(context, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildItemInfo(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                image,
              ),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: 90,
          height: 155,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(6, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ThemeTextStyle.titleMediumOnBackground(context),
                ),
                BaseDecoration.buildRowLocationReview(context, location, rate, reviews),
                Text(
                  '📅 $time',
                  style: ThemeTextStyle.titleSmallOnBackground(context),
                ),
                Text(
                  description, //limit description
                  style: ThemeTextStyle.titleSmallOnBackground(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}