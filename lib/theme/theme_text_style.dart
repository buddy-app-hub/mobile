import 'package:flutter/material.dart';

extension on TextStyle {
  TextStyle get comfortaa {
    return copyWith(
      fontFamily: 'Comfortaa',
    );
  }
}

class ThemeTextStyle {

  static TextStyle titleLargePrimary700(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w700,
      fontSize: 18,
      height: 1.3,
      letterSpacing: 0.1,
    );
  }

  static TextStyle titleLargeOnPrimary(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle titleXLargeOnBackground700(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: 44,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleLargeSecondary700(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.w700,
      fontSize: 18,
      height: 1.3,
      letterSpacing: 0.1,
    );
  }

  static TextStyle titleLargeGoogle(BuildContext context) {
    return TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w700,
      fontSize: 18,
      height: 1.3,
      letterSpacing: 0.1,
    );
  }

  static TextStyle titleSmallPrimary(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleSmallOnPrimary(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleSmallOnBackground(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleSmallOnSecondary(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 14,
    fontWeight: FontWeight.w500,
    );
  }

  static TextStyle titleMediumOnBackground(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: 20,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleLargeOnBackground(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle itemLargeOnBackground(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.3,
      letterSpacing: 0.1,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle titleSmallBright(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.tertiary,
      fontFamily: 'Comfortaa', //TODO: fix font family para reviews
    );
  }
}