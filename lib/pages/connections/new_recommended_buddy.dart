import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/recommended_buddy.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/connections/meetings/onboard_new_connection.dart';
import 'package:mobile/pages/profile/profile_widgets.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/services/files_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewRecommendedBuddy extends StatefulWidget {
  @override
  _NewRecommendedBuddyState createState() => _NewRecommendedBuddyState();
}

class _NewRecommendedBuddyState extends State<NewRecommendedBuddy> {
  ConnectionService connectionService = ConnectionService();

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
      print("Cargando fotos");
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
        print("Fotos cargadas");
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
      print("Cambiando a siguiente buddy");
      currentBuddyIndex += 1;
    });

    if (recommendedBuddies!.length < currentBuddyIndex + 1) {
      print("No mas buddies");
      return;
    }
    _loadUserPhotos();
  }

  void _createConnection(BuildContext context) async {
    Connection newConnection = Connection(
      elderID: authProvider.user!.uid,
      buddyID: recommendedBuddies![currentBuddyIndex].buddy!.firebaseUID,
      meetings: List.empty(),
      creationDate: DateTime.now(),
    );
    print("Creando la conexión...");
    print(newConnection);

    await connectionService.createConnection(context, newConnection);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OnboardNewConnectionPage(connection: newConnection, buddy: recommendedBuddies![currentBuddyIndex].buddy!)),
    );
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
          textAlign: TextAlign.center,
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
              key: ValueKey<int>(currentBuddyIndex),
              children: [
                CarouselSlider(
                  items: _photoUrls.map((url) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: url != null
                          ? CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
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
                              _createConnection(context);
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
