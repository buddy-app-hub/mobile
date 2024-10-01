import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile/models/recommended_buddy.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/profile/profile_widgets.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/files_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class NewRecommendedBuddy extends StatefulWidget {
  @override
  _NewRecommendedBuddyState createState() => _NewRecommendedBuddyState();
}

class _NewRecommendedBuddyState extends State<NewRecommendedBuddy> {
  List<RecommendedBuddy>? recommendedBuddies;
  int currentBuddyIndex = 0;
  late AuthSessionProvider authProvider;
  List<String?> _photoUrls = [];
  final FilesService _filesService = FilesService();
  bool _photosLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRecommendedBuddies();
  }

  Future<void> _fetchRecommendedBuddies() async {
    authProvider =
        Provider.of<AuthSessionProvider>(this.context, listen: false);

    BuddyService buddyService = BuddyService();
    try {
      List<RecommendedBuddy> rb =
          await buddyService.getRecommendedBuddies(authProvider.userData!);
      setState(() {
        recommendedBuddies = rb;
        _loadUserPhotos(); // Cargamos las fotos después de obtener las recomendaciones
      });
    } catch (error) {
      print("Error fetching recommended buddies: $error");
      setState(() {
        recommendedBuddies = [];
      });
    }
  }

  Future<void> _loadUserPhotos() async {
    if (recommendedBuddies == null || recommendedBuddies!.isEmpty) {
      print("No recommended buddies available to load photos.");
      return;
    }

    setState(() {
      _photosLoading = true;
    });

    try {
      final List<String?> urls = await _filesService.getUserPhotos(
          recommendedBuddies![currentBuddyIndex].buddy!.firebaseUID,
          true,
          this.context);
      setState(() {
        _photoUrls = urls;
        _photosLoading = false;
      });
    } catch (e) {
      setState(() {
        _photosLoading = false;
      });
      print('Error loading photos: $e');
    }
  }

  void _changeToNextBuddy() async {
    setState(() {
      currentBuddyIndex += 1;
    });

    if (recommendedBuddies!.length > currentBuddyIndex + 1) {
      return;
    }
    _loadUserPhotos();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (recommendedBuddies == null || _photosLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (recommendedBuddies!.isEmpty ||
        currentBuddyIndex >= recommendedBuddies!.length) {
      return Center(
        child: Text(
          'No hay buddies recomendados disponibles en este momento.\n\nIntentá más tarde !',
          textAlign: TextAlign.center, // Centra cada línea de texto
          style: ThemeTextStyle.titleMediumOnPrimaryContainer(
            context,
          ),
        ),
      );
    }

    final RecommendedBuddy recommendedBuddy =
        recommendedBuddies![currentBuddyIndex];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text('Conocé tu posible nuevo',
              style: ThemeTextStyle.titleMediumOnPrimaryContainer(
                context,
              )),
          Text('Buddy',
              style: ThemeTextStyle.titleLargeOnPrimaryFixed(
                context,
              )),
          SizedBox(height: 20),

          AnimatedSwitcher(
            duration: Duration(milliseconds: 1000),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Column(
              key: ValueKey<int>(
                  currentBuddyIndex),
              children: [
                CarouselSlider(
                  items: _photoUrls.map((url) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: url != null
                          ? Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Icon(Icons.error);
                              },
                            )
                          : null,
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
                SizedBox(height: 20),
                Container(
                  decoration: BaseDecoration.boxCurveLR(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          children: [
                            Text(
                              '${recommendedBuddy.buddy!.personalData.firstName} ${recommendedBuddy.buddy!.personalData.lastName}, ${recommendedBuddy.buddy!.personalData.age}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ProfileWidgets.buildRowLocationReviewProfile(
                                context,
                                true,
                                'A ${recommendedBuddy.distanceToKM} km',
                                recommendedBuddy
                                        .buddy!.buddyProfile?.globalRating
                                        ?.toString() ??
                                    '0',
                                '23' // TODO: sacar hardcodeo
                                ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              _changeToNextBuddy();
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
                              // TODO: abrir modal para gestionar primer encuentro
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Conectar',
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      ProfileWidgets.buildProfileInfo(
                        context,
                        theme,
                        true,
                        recommendedBuddy.buddy!.buddyProfile!.description!,
                        recommendedBuddy.buddy!.buddyProfile!.interests!,
                        recommendedBuddy.buddy!.buddyProfile!.availability!,
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
}
