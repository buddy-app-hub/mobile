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
                padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
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
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(2, 0, 0, 1),
                                    child: _buildProfileInfo(context, theme),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildProfileInfo(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 6, 0),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/avatar.png',
              ),
            ),
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Container(
            width: 70,
            height: 71.3,
          ),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 40, 5),
              child: Text(
                'Pepe Argento',
                style: ThemeTextStyle.titleLargeOnBackground(context),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 3.3, 8.6, 3.3),
                  child: SizedBox(
                    width: 10.6,
                    height: 13.3,
                    child: SvgPicture.asset(
                      'assets/icons/iconLocation.svg',
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                ),
                Text(
                  'Buenos Aires',
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
                        TextSpan(text: '4.4 '),
                        TextSpan(
                          text: '(41 opiniones)',
                          style: ThemeTextStyle.titleSmallBright(context),
                        ),
                      ]),
                ),
              ],
            ),
          ],
        ),
      ],
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
