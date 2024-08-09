import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/theme/theme_text_style.dart';

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
    return Padding (
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

  static Container buildTitleProfile(BuildContext context, String title) {
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

  static Row buildRowLocationReview(BuildContext context, String location, String rate, String reviews) {
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
                text: ' ($reviews opiniones)',
                style: ThemeTextStyle.titleSmallBright(context),
              ),
          ]),
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
}