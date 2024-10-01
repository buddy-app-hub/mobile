import 'package:flutter/material.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChooseUserPage extends StatefulWidget {
  @override
  _ChooseUserPageState createState() => _ChooseUserPageState();
}
class _ChooseUserPageState extends State<ChooseUserPage> {
   @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    PageController _pageController = PageController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SmoothPageIndicator(    
            controller: _pageController,   
            count:  3,    
            effect:  WormEffect(
              activeDotColor: theme.colorScheme.onPrimaryFixedVariant,
              dotColor: theme.colorScheme.outlineVariant,
            ),   
            onDotClicked: (index){    
            }
          )    
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (index) {
              // setState(() {
              //   _currentPage = index;
              // });
            },
            itemBuilder: (context, index) {
              return Center(
                child: _createUserDescription(context, theme, index)
              );
            },
          ),
          
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: ElevatedButton(
          onPressed: () {
            _chosenUser(context, _pageController);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            backgroundColor: theme.colorScheme.inversePrimary,
          ),
          child: Text(
            'Elegir',
            style:
                TextStyle(color: theme.colorScheme.onPrimaryContainer, fontSize: 20),
          ),
        ),
      ),
    );
  }

  _chosenUser(context, PageController controller) {
    if (controller.page == 0) {
      Navigator.pushNamed(context, Routes.wantBuddyForMyself);
    } else if (controller.page == 1) {
      Navigator.pushNamed(context, Routes.wantBuddyForLovedOne);
    } else if (controller.page == 2) {
      Navigator.pushNamed(context, Routes.beBuddy);
    }
  }

  Widget _createUserDescription(BuildContext context, ThemeData theme, int index) {
    if (index == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(28, 30, 28, 10),
            child: Text(
              'Quiero un buddy para mi',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 40),
            child: Text(
              'Quiero que mi ser querido sea acompañado de jóvenes con los que comparta experiencias divertidas, a fin de socializar el estar acompañado cuando yo no esté con él.',
              style: ThemeTextStyle.titleSmallOutline(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    } else if (index == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(28, 30, 28, 10),
            child: Text(
              'Quiero un buddy para un ser querido',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 40),
            child: Text(
              'Quiero realizar actividades y compartir experiencias con personas de otras generaciones, estableciendo amistades que van más allá de la edad.',
              style: ThemeTextStyle.titleSmallOutline(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(28, 30, 28, 10),
            child: Text(
              'Quiero ser buddy',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 40),
            child: Text(
              'Quiero combatir la soledad compartiendo momentos únicos junto a adultos mayores, generando un impacto positivo y obteniendo un ingreso económico.',
              style: ThemeTextStyle.titleSmallOutline(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
  }
}
