import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';

class ProfileWidgets {
  static Widget buildProfileData(BuildContext context, ThemeData theme, String profileImageUrl, String personName, bool isBuddy) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: profileImageUrl.isEmpty
              ? AssetImage('assets/images/default_user.jpg')
              : NetworkImage(profileImageUrl) as ImageProvider,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                personName,
                style: isBuddy
                    ? ThemeTextStyle.titleLargeOnPrimaryFixed(context)
                    : ThemeTextStyle.titleLargeOnTertiaryContainer(context),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BaseDecoration.buildRowLocationReviewProfile(
                        context, isBuddy, 'Buenos Aires', '4.4', '41'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildProfileInfo(BuildContext context, ThemeData theme, bool isBuddy, String description, List<Interest> interest, List<custom_time.TimeOfDay> availability) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 45),
      child: Column(
        children: [
          BaseDecoration.buildTitleProfile(context, isBuddy ? 'Sobre este adulto mayor' : 'Sobre este buddy', isBuddy),
          buildPersonalInformation(context, description),
          BaseDecoration.buildTitleProfile(context, 'Intereses', isBuddy),
          buildInterests(context, theme, interest, isBuddy),
          BaseDecoration.buildTitleProfile(context, 'Disponibilidad horaria', isBuddy),
          buildAvailability(context, theme, availability, isBuddy),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseDecoration.buildTitleProfile(context, 'Opiniones', isBuddy),
              Container(
                margin: EdgeInsets.fromLTRB(0, 25, 28, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      print('veo rewiews');
                      // Navegación a la página de opiniones.
                    },
                    child: Text(
                      "Ver más",
                      style: ThemeTextStyle.titleSmallBright(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          buildReviews(context, theme),
        ],
      ),
    );
  }

  static Widget buildPersonalInformation(BuildContext context, String description) {
    return Container(
      margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 0),
            child: Text(
              description,
              style: ThemeTextStyle.itemLargeOnBackground(context),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildInterests(BuildContext context, ThemeData theme, List<Interest> interests, bool isBuddy) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: interests.isNotEmpty
          ? Wrap(
              alignment: WrapAlignment.center,
              spacing: 4.0,
              runSpacing: 8.0,
              children: interests
                  .map((tag) => BaseDecoration.buildInterestTag(context, tag, isBuddy, theme))
                  .toList(),
            )
          : Container(),
    );
  }

  static Widget buildAvailability(BuildContext context, ThemeData theme, List<custom_time.TimeOfDay> availability, bool isBuddy) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 4.0,
        runSpacing: 8.0,
        children: availability
            .map((day) => BaseDecoration.buildAvailabilityTag(context, day, isBuddy, theme))
            .toList(),
      ),
    );
  }

  static Widget buildReviews(BuildContext context, ThemeData theme) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 28, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 18.3, 85),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/default_user.jpg',
                ),
              ),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: SizedBox(
              width: 45,
              height: 45,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 2.9, 8.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
                        child: SizedBox(
                          width: 152.5,
                          child: Text(
                            'Pepe Argento',
                            style: ThemeTextStyle.itemLargeOnBackground(context),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text(
                          '23 Nov 2023',
                          style: ThemeTextStyle.itemSmallOnBackground(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16.3),
                  child: Row(
                    children: [
                      for (int i = 0; i < 5; i++)
                        SvgPicture.asset(
                          'assets/icons/star.svg',
                          color: i < 4
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.secondary.withOpacity(0.5),
                        ),
                    ],
                  ),
                ),
                Text(
                  'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
