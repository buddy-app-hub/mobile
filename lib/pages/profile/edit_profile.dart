import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile/widgets/base_decoration.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return 
    SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        extendBody: true,
        extendBodyBehindAppBar: true, 
        resizeToAvoidBottomInset: false, 
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: -15,
              height: 530,
              child: CarouselSlider(
                items: [
                  Image.asset('assets/images/adultProfile.jpeg', fit: BoxFit.cover),
                  Image.asset('assets/images/adultProfile2.jpeg', fit: BoxFit.cover),
                  Image.asset('assets/images/adultProfile3.jpeg', fit: BoxFit.cover),
                  ],
                options: CarouselOptions(
                  aspectRatio: 9/45,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
                ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 375, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.fromLTRB(28, 0, 28, 20),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(32),
                    //     color: Color(0xFFCED78D),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Color(0x33270158),
                    //         offset: Offset(0, 4),
                    //         blurRadius: 12.5,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      decoration: BaseDecoration.boxCurveLR(context),
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
            BaseDecoration.buildRowLocationReview(context, 'Buenos Aires', '4.4', '20'),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileSettings(BuildContext context) {
    return Column(
      children: [
        BaseDecoration.buildTitleProfile(context, 'Información personal'),
        _buildPersonalInformation(context),
        BaseDecoration.buildTitleProfile(context, 'Actividad'),
        _buildActivity(context),
        BaseDecoration.buildTitleProfile(context, 'Configuración'),
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
                  child: BaseDecoration.buildOption(context, 'Mis datos personales'),
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
                  child: BaseDecoration.buildOption(context, 'Cambiar contraseña'),
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
                  child: BaseDecoration.buildOption(context, 'Descripción e intereses'),
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
                  child: BaseDecoration.buildOption(context, 'Disponibilidad horaria'),
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
                child: BaseDecoration.buildOption(context, 'Supervisión familiar'),
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
                    print('se quiere cerrar sesion');
                  },
                  child: BaseDecoration.buildOption(context, 'Cerrar sesión'),
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