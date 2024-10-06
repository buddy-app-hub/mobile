import 'package:flutter/material.dart';

class ThemeButtonStyle {
  static ButtonStyle primaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Theme.of(context).colorScheme.onBackground,
      elevation: 2,
    );
  }

  static ButtonStyle secondaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Theme.of(context).colorScheme.onBackground,
      elevation: 2,
    );
  }

  static ButtonStyle tertiaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Theme.of(context).colorScheme.onBackground,
      elevation: 2,
    );
  }

  static ButtonStyle outlineButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.outline,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Theme.of(context).colorScheme.outlineVariant,
      elevation: 2,
    );
  }

  static ButtonStyle googleButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
    );
  }

  static ButtonStyle backgroundButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Theme.of(context).colorScheme.onBackground,
      elevation: 2,
    );
  }

  static ButtonStyle tertiaryRoundedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      shadowColor: Theme.of(context).colorScheme.shadow,
      elevation: 1,
    );
  }

  static ButtonStyle primaryRoundedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      disabledBackgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      shadowColor: Theme.of(context).colorScheme.shadow,
      elevation: 1,
    );
  }

  static ButtonStyle disabledRoundedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      shadowColor: Theme.of(context).colorScheme.shadow,
      elevation: 1,
    );
  }

  static ButtonStyle get none => ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    elevation: MaterialStateProperty.all<double>(0),
  );
}