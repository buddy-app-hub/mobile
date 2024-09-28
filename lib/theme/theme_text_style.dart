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

  static TextStyle titleLargeTertiary700(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onTertiaryFixedVariant,
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

  static TextStyle titleSmallOnError(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onError,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleSmallOnPrimary(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleSmallOnBackground(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 15,
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

  static TextStyle titleSmallerOnBackground(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleSmallerOnPrimary(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleMediumOnBackground(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleMediumOnPrimaryContainer(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      fontSize: 18,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle titleLargeOnBackground(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle titleLargeOnPrimaryFixed(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryFixed,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle titleLargeOnTertiaryContainer(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onTertiaryContainer,
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

  static TextStyle itemSmallOnBackground(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      height: 1.3,
      letterSpacing: 0.1,
      color: Theme.of(context).colorScheme.onSurface,
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

  static TextStyle titleSmallsSecondaryContainer(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onSecondaryContainer,
      fontFamily: 'Comfortaa', //TODO: fix font family para reviews
    );
  }

  static TextStyle titleSmallsTertiaryFixedVariant(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onTertiaryFixedVariant,
      fontFamily: 'Comfortaa', //TODO: fix font family para reviews
    );
  }


  static TextStyle titleMediumInverseSurface(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 18,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle titleMediumInverseSurfaceTheme(ThemeData theme) {
    return TextStyle(
      color: theme.colorScheme.onSurface,
      fontSize: 18,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle titleSmallOnTertiaryContainer(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onTertiaryContainer,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleSmallOutline(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.outline,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even
    );
  }
}