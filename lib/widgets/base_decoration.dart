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

  static Container builTitleProfile(BuildContext context, String title) {
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
                color: Theme.of(context).iconTheme.color, // Color del ícono
                size: 16, // Tamaño del ícono
              ),
              SizedBox(width: 8), // Espacio entre el ícono y el texto
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
}
