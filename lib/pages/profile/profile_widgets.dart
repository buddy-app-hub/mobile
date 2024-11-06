import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/review.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/pages/profile/review/view_reviews.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:mobile/widgets/video_player_widget.dart';

class ProfileWidgets {
  static Widget buildProfileData(
    BuildContext context,
    ThemeData theme,
    String personName,
    String globalRating,
    int xpHours,
    String location,
    bool isBuddy, // Refiere no al usuario actual sino a la conexion
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        children: [
          Center(
            // margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text(
              personName,
              style: ThemeTextStyle.titleXLargeOnPrimaryFixed(context),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileWidgets.buildRowLocationReviewProfile(context,
                  isBuddy, location, globalRating.toString(), xpHours),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildProfileInfo(
      BuildContext context,
      ThemeData theme,
      String personID,
      bool newBuddy,
      bool isBuddy, // Refiere no al usuario actual sino a la conexion
      double globalRating,
      String description,
      List<Interest> interest,
      List<custom_time.TimeOfDay> availability) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 45),
      child: Column(
        children: [
          BaseDecoration.buildTitleProfile(
              context,
              newBuddy ? 'Sobre este buddy' :
              isBuddy ? 'Sobre este buddy' : 'Sobre este adulto mayor',
              newBuddy,
              isBuddy),
          buildPersonalInformation(context, description),
          SizedBox(
            height: 20,
          ),
          if (isBuddy) VideoPlayerWidget(userId: personID),
          BaseDecoration.buildTitleProfile(context, 'Intereses', newBuddy, isBuddy),
          buildInterests(context, theme, interest, newBuddy, isBuddy),
          BaseDecoration.buildTitleProfile(
              context, 'Disponibilidad horaria', newBuddy, isBuddy),
          buildAvailability(context, theme, availability, newBuddy, isBuddy),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BaseDecoration.buildTitleProfile(
                    context,
                    newBuddy ? 'Opiniones sobre el buddy' :
                    isBuddy
                        ? 'Opiniones sobre el buddy'
                        : 'Opiniones sobre el adulto mayor',
                    newBuddy,
                    isBuddy),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 8, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      print('veo rewiews');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewReviewsPage(
                            isBuddy: isBuddy,
                            personID: personID,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Ver todos",
                      style: ThemeTextStyle.titleSmallBright(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          buildReviewsSummary(context, theme, newBuddy, isBuddy, personID, globalRating),
        ],
      ),
    );
  }

  static Widget buildPersonalInformation(
      BuildContext context, String description) {
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

  static Widget buildInterests(BuildContext context, ThemeData theme,
      List<Interest> interests, bool newBuddy, bool isBuddy) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: interests.isNotEmpty
          ? Wrap(
              alignment: WrapAlignment.center,
              spacing: 4.0,
              runSpacing: 8.0,
              children: interests
                  .map((tag) => BaseDecoration.buildInterestTag(
                      context, tag, newBuddy, isBuddy, theme))
                  .toList(),
            )
          : Container(),
    );
  }

  static Widget buildAvailability(BuildContext context, ThemeData theme,
      List<custom_time.TimeOfDay> availability, bool newBuddy, bool isBuddy) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 4.0,
        runSpacing: 8.0,
        children: availability
            .map((day) => BaseDecoration.buildAvailabilityTag(
                context, day, newBuddy, isBuddy, theme))
            .toList(),
      ),
    );
  }

  static Future<int> fetchRatingCount(bool isBuddy, String personID) async {
    UserHelper userHelper = UserHelper();
    Map<Meeting, Review> reviews =
        await userHelper.fetchReviews(personID, isBuddy);
    return reviews.length;
  }

  static Widget buildReviewsSummary(BuildContext context, ThemeData theme, bool newBuddy,
      bool isBuddy, String personID, double globalRating) {
    return FutureBuilder<int>(
      future: fetchRatingCount(isBuddy, personID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading ratings'));
        } else {
          int ratingCount = snapshot.data ?? 0;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 66),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    globalRating.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 52,
                      height: 1.2,
                      letterSpacing: 0.1,
                      color: newBuddy ? Theme.of(context).colorScheme.primary : isBuddy ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                        initialRating: globalRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemSize: 27,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.5),
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rate_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      if (ratingCount != 0)
                        Text(
                          "$ratingCount calificaciones",
                          style: ThemeTextStyle.titleMediumInverseSurfaceTheme(
                              theme),
                          textAlign: TextAlign.start,
                        ),
                      if (ratingCount == 0)
                        Text(
                          "No hay calificaciones",
                          style: ThemeTextStyle.titleSmallerOnSurface(context),
                          textAlign: TextAlign.start,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  static Widget buildRowLocationReviewProfile(BuildContext context,
      bool isBuddy, String location, String rate, int xpHours) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 3.3, 6, 3.3),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        'assets/icons/iconLocation.svg',
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Text(
                    location,
                    style: TextStyle(
                      color: isBuddy
                          ? Theme.of(context).colorScheme.onSecondaryContainer
                          : Theme.of(context)
                              .colorScheme
                              .onTertiaryFixedVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 3.3, 3, 3.3),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        'assets/icons/star.svg',
                        color: const Color.fromARGB(255, 230, 207, 8),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(
                          color: isBuddy
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .onTertiaryFixedVariant,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(text: rate),
                        ]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(4, 3.3, 6, 3.3),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    'assets/icons/eventavailable.svg',
                    color: Colors.blue,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Comfortaa',
                    color: isBuddy
                        ? Theme.of(context).colorScheme.onSecondaryContainer
                        : Theme.of(context).colorScheme.onTertiaryFixedVariant,
                    fontSize: 16, // Tamaño para xpHours
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    if (xpHours > 0)
                    TextSpan(
                        text: '$xpHours hs ', // Texto principal
                        style: TextStyle(
                          fontFamily: 'Comfortaa',
                        )),
                    TextSpan(
                      text: xpHours < 1 ? 'En busca de su primer encuentro.' : xpHours > 1 ? 'de experiencias' : 'de experiencia', // Texto más pequeño
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 15, // Tamaño de fuente más pequeño
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
