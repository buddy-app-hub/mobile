import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/emoji_interest.dart';
import 'package:mobile/utils/format_date.dart';

class BaseDecoration {
  static BoxDecoration boxCurveLR(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    );
  }

  static BoxDecoration boxCurveRight(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(160),
      ),
    );
  }

  static BoxDecoration boxCurveLeft(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(160),
      ),
    );
  }

  static Widget buildPaddingField(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        text,
        style: ThemeTextStyle.titleMediumOnBackground(context),
      ),
    );
  }

  static BoxDecoration boxLineOpacity(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static Container buildTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.fromLTRB(28, 30, 5, 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: ThemeTextStyle.titleLargePrimary700(context),
        ),
      ),
    );
  }

  static Container buildTitleProfile(BuildContext context, String title, bool isBuddy) {
    return Container(
      margin: EdgeInsets.fromLTRB(28, 30, 5, 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: isBuddy ? ThemeTextStyle.titleLargePrimary700(context) : ThemeTextStyle.titleLargeTertiary700(context),
        ),
      ),
    );
  }

  static Widget buildTag(BuildContext context, String tag, ThemeData theme) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 4.5, 0),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(32),
        color: theme.colorScheme.primary.withOpacity(0.05),
      ),
      padding: EdgeInsets.fromLTRB(11, 7, 11.3, 7),
      child: Text(
        tag,
        style: ThemeTextStyle.itemLargeOnBackground(context),
      ),
    );
  }

  static Widget buildInterestTag(BuildContext context, Interest interest, bool isBuddy, ThemeData theme) {
    final emoji = getEmojiInterest(interest.name);
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 4.5, 0),
      decoration: BoxDecoration(
        border: Border.all(color: isBuddy ? theme.colorScheme.primary : theme.colorScheme.tertiary),
        borderRadius: BorderRadius.circular(32),
        color: isBuddy ? theme.colorScheme.primary.withOpacity(0.05) : theme.colorScheme.tertiary.withOpacity(0.05),
      ),
      padding: EdgeInsets.fromLTRB(11, 7, 11.3, 7),
      child: Text(
        '$emoji ${interest.name}',
        style: ThemeTextStyle.itemLargeOnBackground(context),
      ),
    );
  }

  static Widget buildAvailabilityTag(BuildContext context, custom_time.TimeOfDay availability, bool isBuddy, ThemeData theme) {
    String startHour = intToTime(availability.from);
    String endHour = intToTime(availability.to);
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 4.5, 0),
      decoration: BoxDecoration(
        border: Border.all(color: isBuddy ? theme.colorScheme.primary : theme.colorScheme.tertiary),
        borderRadius: BorderRadius.circular(32),
        color: isBuddy ? theme.colorScheme.primary.withOpacity(0.05) : theme.colorScheme.tertiary.withOpacity(0.05),
      ),
      padding: EdgeInsets.fromLTRB(11, 7, 11.3, 7),
      child: Text(
        '📅 ${availability.dayOfWeek} de $startHour a $endHour',
        style: ThemeTextStyle.itemLargeOnBackground(context),
      ),
    );
  }

  static Widget buildEditableInterestTag(BuildContext context, Interest interest, ThemeData theme, void Function(Interest) onDelete) {
    final emoji = getEmojiInterest(interest.name);
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(32),
        color: theme.colorScheme.primary.withOpacity(0.05),
      ),
      padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$emoji ${interest.name}',
            style: ThemeTextStyle.itemLargeOnBackground(context),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 18.0,
            onPressed: () => onDelete(interest),
          ),
        ],
      ),
    );
  }

  static Widget buildEditableAvailabilityTag(BuildContext context, custom_time.TimeOfDay availability, ThemeData theme, void Function(custom_time.TimeOfDay) onDelete) {
    String startHour = intToTime(availability.from);
    String endHour = intToTime(availability.to);
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(32),
        color: theme.colorScheme.primary.withOpacity(0.05),
      ),
      padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '📅 ${availability.dayOfWeek} de $startHour a $endHour',
            style: ThemeTextStyle.itemLargeOnBackground(context),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 18.0,
            onPressed: () => onDelete(availability),
          ),
        ],
      ),
    );
  }

  static Widget buildOption(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0.5, 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: ThemeTextStyle.itemLargeOnBackground(context),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 4.1, 0, 5),
            width: 7.9,
            height: 12.9,
            child: SizedBox(
              width: 7.9,
              height: 12.9,
              child: SvgPicture.asset(
                'assets/icons/rightArrow.svg',
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildOptionWithIcon(
      BuildContext context, IconData icon, String text) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0.5, 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).iconTheme.color,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                text,
                style: ThemeTextStyle.itemLargeOnBackground(context),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 4.1, 0, 5),
            width: 7.9,
            height: 12.9,
            child: SizedBox(
              width: 7.9,
              height: 12.9,
              child: SvgPicture.asset(
                'assets/icons/rightArrow.svg',
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Opacity buildOpacity(BuildContext context) {
    return Opacity(
      opacity: 0.08,
      child: Container(
        decoration: BaseDecoration.boxLineOpacity(context),
        child: SizedBox(
          width: 343.5,
          height: 1,
        ),
      ),
    );
  }

  static FlashyTabBarItem buildNavbarIconItem(BuildContext context, String text, Icon icon) {
    return FlashyTabBarItem(
      icon: icon,
      title: Text(text),
      activeColor: Theme.of(context).colorScheme.primary,
      inactiveColor: Theme.of(context).colorScheme.outline,
    ); 
  }

  static Widget buildRowLocationReview(BuildContext context, String location, String rate, String reviews) {
    return Row(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(4, 3.3, 6, 3.3),
              child: SizedBox(
                width: 10.6,
                height: 13.3,
                child: SvgPicture.asset(
                  'assets/icons/iconLocation.svg',
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            Text(
              location,
              style: ThemeTextStyle.titleSmallBright(context),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(7, 3.3, 1.6, 3.3),
              child: SizedBox(
                width: 10.6,
                height: 13.3,
                child: SvgPicture.asset(
                  'assets/icons/star.svg',
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Color(0xFFFFCD1A),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(text: rate),
                  TextSpan(
                    text: ' ($reviews)', //TODO saque el opiniones porque seguia con overflow, se lo puede contener en un wrap quizas o dejarlo asis
                    style: ThemeTextStyle.titleSmallBright(context),
                  ),
              ]),
            ),
          ],
        ),
      ],
    ); 
  }

  static Row buildRowLocation(BuildContext context, String location) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 3.3, 8.6, 3.3),
          child: SizedBox(
            width: 10.6,
            height: 13.3,
            child: SvgPicture.asset(
              'assets/icons/iconLocation.svg',
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
        Text(
          location,
          style: ThemeTextStyle.titleSmallBright(context),
        ),
      ],
    ); 
  }

  static Widget buildConnectionProfile(BuildContext context, String imagePath, String name) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(imagePath),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: 80,
          height: 90,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  static Widget buildChatlist(BuildContext context) {
    final chatData = [
      {
        'pictureName': 'avatarBuddy.jpeg',
        'lastMessage': 'Hey there!',
        'isNew': true,
      },
      {
        'pictureName': 'avatarBuddy.jpeg',
        'lastMessage': 'How are you?',
        'isNew': false,
      },
      {
        'pictureName': 'avatarBuddy.jpeg',
        'lastMessage': 'Lets hang out',
        'isNew': false,
      },
    ];

    return ListView.builder(
      itemCount: chatData.length,
      itemBuilder: (context, index) {
        final chat = chatData[index];
        return ListTile(
          // leading: CircleAvatar(
          //   backgroundImage: AssetImage('assets/images/${chat['pictureName']}'),
          // ),
          title: Text(chat['lastMessage'] as String),
          trailing: chat['isNew'] as bool ? const Icon(Icons.circle, size: 10) : null,
        );
      },
    );
  }
}
