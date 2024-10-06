import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSettings(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Column(
      children: [
        BaseDecoration.buildTitle(context, 'Configuración de tu cuenta'),
        _buildPersonalInformation(context),
        BaseDecoration.buildTitle(context, 'Actividad'),
        _buildActivity(context),
        BaseDecoration.buildTitle(context, 'Nuestras redes sociales'),
        _buildSocialNetworks(context),
        BaseDecoration.buildTitle(context, ''),
        _buildLogOut(context),
      ],
    );
  }

  Widget _buildPersonalInformation(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);

    return Container(
      margin: EdgeInsets.fromLTRB(43, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsRow(
              context, 'Mis datos personales', true, Icons.person, () => {}),
          _buildSettingsRow(
              context, 'Cambiar contraseña', true, Icons.lock, () => {}),
          _buildSettingsRow(context, 'Supervisión familiar',
              authProvider.isElder, Icons.supervisor_account, () => {}),
          _buildSettingsRow(
              context, 'Notificaciones', true, Icons.notifications, () => {}),
          _buildSettingsRow(
              context, 'Términos y condiciones', true, Icons.article, () => {}),
        ],
      ),
    );
  }

  Widget _buildActivity(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);

    return Container(
      margin: EdgeInsets.fromLTRB(43, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsRow(context, 'Método de pago', authProvider.isElder,
              Icons.payment, () => {}),
          _buildSettingsRow(context, 'Método de cobro', authProvider.isBuddy,
              Icons.attach_money, () => {}),
          _buildSettingsRow(context, 'Tips para ser un buen Buddy',
              authProvider.isBuddy, Icons.lightbulb, () => {}),
          _buildSettingsRow(context, 'Tips para ser un buen Mayor',
              authProvider.isElder, Icons.emoji_people, () => {}),
        ],
      ),
    );
  }

  Widget _buildSocialNetworks(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(43, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsRow(
              context, 'Instagram', true, Icons.camera_alt, () => {}),
          _buildSettingsRow(
              context, 'Facebook', true, Icons.facebook, () => {}),
          _buildSettingsRow(
              context, 'Youtube', true, Icons.video_library, () => {}),
        ],
      ),
    );
  }

  Widget _buildLogOut(BuildContext context) {
    final authProvider = Provider.of<AuthSessionProvider>(context);

    return Container(
      margin: EdgeInsets.fromLTRB(43, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsRow(context, 'Cerrar sesión', true, Icons.logout,
              () async {
            await authProvider.signOut();
            Navigator.pushReplacementNamed(context, Routes.login);
          }),
          _buildSettingsRow(
              context, 'Eliminar cuenta', true, Icons.delete, () => {}),
        ],
      ),
    );
  }

  Container _buildSettingsRow(BuildContext context, String title,
      bool showToUser, IconData icon, Function callback) {
    return showToUser
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    callback();
                  },
                  child:
                      BaseDecoration.buildOptionWithIcon(context, icon, title),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          )
        : Container();
  }
}
