import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

List<String> userInterests = ['🍃 Naturaleza', '🏝 Viajar', '✍🏻 Literatura', '🙂 Conocer gente', '💪 Gym & Fitness'];
List<String> userDisponibility = ['📅 Lunes de 15.00 a 16.00', '📅 Miercoles de 10.00 a 11.00'];

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePagePageState();
}

class _ViewProfilePagePageState extends State<ViewProfilePage> {

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
                  Image.asset('assets/images/buddyProfile.jpeg', fit: BoxFit.cover),
                  Image.asset('assets/images/buddyProfile2.jpeg', fit: BoxFit.cover),
                  Image.asset('assets/images/buddyProfile3.jpeg', fit: BoxFit.cover),
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
                    Container(
                      decoration: BaseDecoration.boxCurveLR(context),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                            _buildProfileSettings(context, theme),
                            Container(
                              margin: EdgeInsets.fromLTRB(28, 25, 28, 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: _buildVolverButton(context),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: _buildConnectButton(context),
                                ),
                              ],),
                            )
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
                'assets/images/avatarBuddy.jpeg',
              ),
            ),
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: SizedBox(
            width: 70,
            height: 71.3,
          ),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 40, 5),
              child: Text(
                'Ana Rodriguez',
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

  Widget _buildProfileSettings(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        BaseDecoration.builTitleProfile(context, 'Sobre este buddy'),
        _buildPersonalInformation(context),
        BaseDecoration.builTitleProfile(context, 'Intereses'),
        _buildInterests(context, theme),
        BaseDecoration.builTitleProfile(context, 'Disponibilidad horaria'),
        _buildDisponibility(context, theme),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseDecoration.builTitleProfile(context, 'Opiniones'),
            Container(
              margin: EdgeInsets.fromLTRB(0, 25, 28, 0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                onPressed: () {
                  print('veo rewiews');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const Reviews()),
                  // );
                },
                child: Text(
                  "Ver más",
                  style: ThemeTextStyle.titleSmallBright(context),
                )),
              ),
            )
          ],
        ),
        _buildReviews(context, theme),
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
            margin: EdgeInsets.fromLTRB(0, 0, 1, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0.5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded (
                        child: Container(
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tortor ac leo lorem nisl. Viverra vulputate sodales quis et dui, lacus. Iaculis eu egestas leo egestas vel. Ultrices ut magna nulla facilisi commodo enim, orci feugiat pharetra. Id sagittis, ullamcorper turpis ultrices platea pharetra.',
                            style: ThemeTextStyle.itemLargeOnBackground(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterests(BuildContext context, ThemeData theme) {
    return Container(
      margin: EdgeInsets.fromLTRB(28, 0, 28, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0.5, 0),
                  child: Wrap(
                    spacing: 2.0,
                    runSpacing: 10.0,
                    children: userInterests.map((tag) => BaseDecoration.buildTag(context, tag, theme)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisponibility(BuildContext context, theme) {
    return Container(
      margin: EdgeInsets.fromLTRB(28, 0, 28, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0.5, 0),
                  child: Wrap(
                    spacing: 2.0,
                    runSpacing: 10.0,
                    children: userDisponibility.map((day) => BaseDecoration.buildTag(context, day, theme)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews(BuildContext context, theme) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 28, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 18.3, 85),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/avatar.png',
                ),
              ),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: SizedBox(
            width: 45,
            height: 45,
          ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 2.9, 8.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
                        child: SizedBox(
                          width: 152.5,
                          child: Text(
                            'Pepe Argento',
                            style: ThemeTextStyle.itemLargeOnBackground(context),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text(
                          '23 Nov 2023',
                          style: ThemeTextStyle.itemLargeOnBackground(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16.3),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 117,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                              ),
                            ),
                          ),
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                              ),
                            ),
                          ),
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                              ),
                            ),
                          ),
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                              ),
                            ),
                          ),
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                                color: theme.colorScheme.secondary.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
                  style: ThemeTextStyle.itemLargeOnBackground(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildConnectButton(BuildContext context) {
    return BaseElevatedButton (
      text: "Conectar",
      buttonTextStyle:
        TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      // margin: EdgeInsets. symmetric(horizontal: 36),
      buttonStyle: ThemeButtonStyle.primaryButtonStyle(context),
      onPressed: () => {
        print('voy al chat ?')
      },
      height: 50,
      width: 140,
    );
  }

  Widget _buildVolverButton(BuildContext context) {
    return BaseElevatedButton (
      text: "Volver",
      buttonTextStyle:
        TextStyle(
          color: Theme.of(context).colorScheme.onTertiary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      // margin: EdgeInsets. symmetric(horizontal: 30),
      buttonStyle: ThemeButtonStyle.outlineButtonStyle(context),
      onPressed: () => {
        print('voy devuelta a la lista ?')
      },
      height: 50,
      width: 140,
    );
  }

}