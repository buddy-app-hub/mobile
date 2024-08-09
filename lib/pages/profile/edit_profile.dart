import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';

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
        BaseDecoration.builTitleProfile(context, 'Información personal'),
        _buildPersonalInformation(context),
        BaseDecoration.builTitleProfile(context, 'Actividad'),
        _buildActivity(context),
        BaseDecoration.builTitleProfile(context, 'Configuración'),
        _buildSettings(context),
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
                    print('descripcrion e intereses se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(
                      context, 'Descripción e intereses'),
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
                    print('dispo horaria se quiere cambiar');
                  },
                  child: BaseDecoration.buildOption(
                      context, 'Disponibilidad horaria'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  print('supervision familiar se quiere cambiar');
                },
                child:
                    BaseDecoration.buildOption(context, 'Supervisión familiar'),
              ),
              BaseDecoration.buildOpacity(context),
            ],
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

  Widget _buildSettings(BuildContext context) {
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
                      context, 'Terminos y Condiciones'),
                ),
                BaseDecoration.buildOpacity(context),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  print('cerrar sesion se quiere cambiar');
                },
                child: BaseDecoration.buildOption(context, 'Cerrar sesión'),
              ),
              BaseDecoration.buildOpacity(context),
            ],
          ),
        ],
      ),
    );
  }
}
