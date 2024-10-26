import 'package:flutter/material.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/payment_handshake.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/pages/connections/chats/chat_screen.dart';
import 'package:mobile/pages/payment/mercadopago.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/chat_service.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/services/payment_service.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/widgets/base_button.dart';

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
      : super(
            text: text,
            onPressed: onPressed,
            buttonStyle: buttonStyle,
            isDisabled: isDisabled,
            buttonTextStyle: buttonTextStyle,
            height: height,
            width: width,
            alignment: alignment,
            margin: margin,
            color: color);

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
            child: buildElevatedButtonWidget)
        : buildElevatedButtonWidget;
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
                  child: Text(text,
                      textAlign: TextAlign.center,
                      style: buttonTextStyle ??
                          TextStyle(
                            color: color,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                ),
                rightIcon ?? const SizedBox.shrink(),
              ],
            )),
      );
}

class ConfirmButton extends StatelessWidget {
  final bool isBuddy;
  final Meeting meeting;
  final Connection connection;

  ConfirmButton(
      {required this.isBuddy, required this.connection, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return BaseElevatedButton(
      text: 'Confirmar',
      buttonTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      buttonStyle: ThemeButtonStyle.primaryRoundedButtonStyle(context),
      onPressed: () async {
        final connectionService = ConnectionService();
        if (isBuddy) {
          meeting.isConfirmedByBuddy = true;
        } else {
          meeting.isConfirmedByElder = true;
        }
        await connectionService.updateMeetingOfConnection(
            context, connection, meeting);
        Navigator.pushNamed(context, Routes.splashScreen);
      },
      height: 40,
      width: 130,
    );
  }
}

class PaymentButton extends StatelessWidget {
  final Meeting meeting;
  final String connectionId;

  PaymentButton({required this.meeting, required this.connectionId});

  @override
  Widget build(BuildContext context) {
    return BaseElevatedButton(
      text: 'Pagar',
      buttonTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      buttonStyle: ThemeButtonStyle.primaryRoundedButtonStyle(context),
      onPressed: () async {
        final paymentService = PaymentService();
        PaymentHandshake? payment =
            await paymentService.getHandshake(connectionId, meeting.meetingID!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MercadoPagoScreen(url: payment.sandboxInitPoint),
          ),
        );
      },
      height: 40,
      width: 100,
    );
  }
}

class ChatButton extends StatelessWidget {
  final UserData currentUserData;
  final String connectedPersonID;
  final String connectedPersonName;

  ChatButton(
      {required this.currentUserData,
      required this.connectedPersonID,
      required this.connectedPersonName});

  @override
  Widget build(BuildContext context) {
    return BaseElevatedButton(
      text: 'Chat',
      buttonTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onTertiary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      buttonStyle: ThemeButtonStyle.tertiaryRoundedButtonStyle(context),
      onPressed: () async {
        final chatService = ChatService();
        final chatRoomId = await chatService.createChatRoom(
            connectedPersonName, connectedPersonID, currentUserData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatRoomId: chatRoomId),
          ),
        );
      },
      height: 40,
      width: 100,
    );
  }
}
