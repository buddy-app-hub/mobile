import 'package:flutter/material.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/widgets/base_button.dart';
import 'package:path/path.dart';


BaseElevatedButton buildNextMeetingButton(BuildContext context, UserData userData, VoidCallback onPressed) {
  return BaseElevatedButton(
    text: 'Chat',
    buttonTextStyle: TextStyle(
      color: Theme.of(context).colorScheme.onTertiary,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    buttonStyle: ThemeButtonStyle.tertiaryRoundedButtonStyle(context),
    onPressed: onPressed,
    height: 40,
    width: 100,
  );
}

BaseElevatedButton buildNewEventButton(BuildContext context, bool isBuddy, Meeting meeting, VoidCallback onPressed) {
  String buttonText;
  bool buttonDisabled = false;
  double buttonSize = 150;
  if (isBuddy && meeting.isConfirmedByBuddy && !meeting.isConfirmedByElder) {
    buttonText = 'Esperando confirmación';
    buttonDisabled = true;
  } else if (!isBuddy && !meeting.isConfirmedByBuddy && meeting.isConfirmedByElder) {
    buttonText = 'Esperando confirmación';
    buttonDisabled = true;
  } else {
    buttonText = 'Confirmar';
  }

  return BaseElevatedButton(
    text: buttonText,
    buttonTextStyle: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    buttonStyle: ThemeButtonStyle.primaryRoundedButtonStyle(context),
    onPressed: onPressed,
    isDisabled: buttonDisabled,
    height: 40,
    width: buttonSize,
  );
}


class BaseElevatedButton extends BaseButton {
  BaseElevatedButton(
    {Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    Color? color,
    required String text})
    : super (
      text: text,
      onPressed: onPressed,
      buttonStyle: buttonStyle,
      isDisabled: isDisabled,
      buttonTextStyle: buttonTextStyle,
      height: height,
      width: width,
      alignment: alignment,
      margin: margin,
      color: color
    );

    final BoxDecoration? decoration;
    final Widget? leftIcon;
    final Widget? rightIcon;
    Color? color;

    @override
    Widget build(BuildContext context) {
      color ??= Theme.of(context).colorScheme.onSurface;
      return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget
        ) : buildElevatedButtonWidget;
    }

    Widget get buildElevatedButtonWidget => Container(
      height: this.height ?? 50,
      width: this.width ?? double.maxFinite,
      margin: margin,
      decoration: decoration,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isDisabled ?? false ? null : onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leftIcon ?? const SizedBox.shrink(),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: buttonTextStyle ?? TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
            rightIcon ?? const SizedBox.shrink(),
          ],
        )
      ),
    );
}