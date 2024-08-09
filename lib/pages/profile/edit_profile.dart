import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                            _buildProfileSettings(context),
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

  Widget _buildProfileSettings(BuildContext context) {
    return Column(
      children: [
        BaseDecoration.builTitleProfile(context, 'Configuración de tu cuenta'),
        _buildPersonalInformation(context),
        BaseDecoration.builTitleProfile(context, 'Actividad'),
        _buildActivity(context),
        BaseDecoration.builTitleProfile(context, 'Nuestras redes sociales'),
        _buildSocialNetworks(context),
        BaseDecoration.builTitleProfile(context, ''),
        _buildLogOut(context),
      ],
    );
  }

  Widget _buildPersonalInformation(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(43, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('mis datos personales se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(
                      context, 'Mis datos personales'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('se quiere cambiar contraseña');
                  },
                  child:
                      BaseDecoration.buildOption(context, 'Cambiar contraseña'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('terminos y condiciones se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(
                      context, 'Supervisión familiar'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('notificaciones se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(context, 'Notificaciones'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('terminos y condiciones se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(
                      context, 'Terminos y condiciones'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivity(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(43, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('metodo de pago se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(context, 'Metodo de pago'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
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
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('metodo de pago se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(context, 'Instagram'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('metodo de pago se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(context, 'Facebook'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('metodo de pago se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(context, 'Youtube'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
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
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    await authProvider.signOut();
                    Navigator.pushReplacementNamed(context, Routes.login);
                  },
                  child: BaseDecoration.buildOption(context, 'Cerrar sesión'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('metodo de pago se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(context, 'Eliminar cuenta'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
