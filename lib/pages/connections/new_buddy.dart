import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/profile/profile_widgets.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:provider/provider.dart';

class NewBuddy extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/images/buddyProfile.jpeg',
    'assets/images/buddyProfile2.jpeg',
    'assets/images/buddyProfile3.jpeg'
  ];

  final String buddyName = 'Juan Pérez';
  final int buddyAge = 20;
  final double buddyRating = 4.5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

return Stack(
      children: [
        Center(
          child: Column(
            children: [
            SizedBox(height: 10,),
              CarouselSlider(
                items: imageUrls.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      url,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 300,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  scrollPhysics: BouncingScrollPhysics(),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 330, 0, 0),
            child: 
              Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BaseDecoration.boxCurveLR(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          '$buddyName, $buddyAge',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Acción para ver otro Buddy
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              backgroundColor: Colors.grey[300],
                            ),
                            child: Text(
                              'Ver otro Buddy',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 20),

                          ElevatedButton(
                            onPressed: () {
                              // Acción para conectar con el Buddy
                            },
                            child: Text('Conectar'),
                          ),
                        ],
                      ),
                      ProfileWidgets.buildProfileInfo(
                        context,
                        theme,
                        true,
                        authProvider.userData!.elder!.elderProfile!.description!,
                        authProvider.userData!.elder!.elderProfile!.interests!,
                        authProvider.userData!.elder!.elderProfile!.availability!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
