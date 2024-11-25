import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/payment/pay.dart';
import 'package:mobile/pages/profile/complete_profile/identity_verification.dart';
import 'package:mobile/pages/profile/edit_profile/edit_availability.dart';
import 'package:mobile/pages/profile/edit_profile/edit_biography.dart';
import 'package:mobile/pages/profile/edit_profile/edit_interests.dart';
import 'package:mobile/pages/profile/edit_profile/edit_photos.dart';
import 'package:mobile/pages/profile/edit_profile/edit_profile_image.dart';
import 'package:mobile/pages/profile/edit_profile/edit_video.dart';
import 'package:mobile/pages/profile/settings/edit_address.dart';
import 'package:mobile/pages/wallet/wallet.dart';
import 'package:mobile/pages/profile/edit_profile/settings.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/files_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

UserHelper userHelper = UserHelper();

class MyProfilePage extends StatefulWidget {
  final TabController tabController;
  final Function(int) updateSelectedIndex;
  const MyProfilePage({super.key, required this.tabController, required this.updateSelectedIndex});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool isLoading = true;

  late AuthSessionProvider authProvider;
  final FilesService _filesService = FilesService();
  BuddyService buddyService = BuddyService();
  final EditProfileImageBottomSheet _bottomSheet =
      EditProfileImageBottomSheet();
  final List<ProfileCompletionCard> profileCompletionCards = [];
  int profileCompletedProgress = 0;
  bool isBuddy = false;
  bool isUserIdentityUploaded = false;
  bool isIdentityVerified = false;
  bool isBiographyCompleted = false;
  bool isAddressCompleted = false;
  bool isPhotoAlbumCompleted = false;
  bool isInterestCompleted = false;
  bool isAvailabilityCompleted = false;
  bool isIntroVideoUploaded = false;
  bool isBuddyApplicationCompleted = false;
  String? _profileImageUrl;

  bool isBuddyProfileComplete = false;
  bool isElderProfileComplete = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);

    authProvider.addListener(
        _onAuthProviderChange); // Escuchamos los cambios que hayan en el user

    Future.wait([
      _loadUserIdentity(),
      _loadProfileImage(),
      _updateProfileState(),
    ]).then((_) {
      _loadProfileCompletion();
      setState(() {
        isLoading = false;
      });
    });
  }

  void _onAuthProviderChange() {
    if (authProvider.user != null) {
      _loadUserIdentity();
      _updateProfileState();
      _loadProfileCompletion();
    }
  }
  
  @override
  void dispose() {
    authProvider.removeListener(_onAuthProviderChange);
    super.dispose();
  }

  Future<void> _updateProfileState() async {
    print("Actualizando estado del perfil");
    bool hasVideoURL =
        await userHelper.isIntroVideoUploaded(context, authProvider.userData!);

    setState(() {
      isBuddy = authProvider.userData!.buddy != null;
      isIdentityVerified =
          userHelper.isUserIdentityVerified(authProvider.userData!);
      isBiographyCompleted =
          userHelper.isUserBiographyCompleted(authProvider.userData!);
      isAddressCompleted =
          userHelper.isUserAddressCompleted(authProvider.userData!);
      isPhotoAlbumCompleted =
          userHelper.isUserPhotoAlbumCompleted(authProvider.userData!);
      isInterestCompleted =
          userHelper.isUserInterestCompleted(authProvider.userData!);
      isAvailabilityCompleted =
          userHelper.isUserAvailabilityCompleted(authProvider.userData!);
      isIntroVideoUploaded = hasVideoURL;
      isBuddyApplicationCompleted =
          userHelper.isUserBuddyApplicationCompleted(authProvider.userData!);

      isBuddyProfileComplete = isIdentityVerified &&
          isBiographyCompleted &&
          isAddressCompleted &&
          isPhotoAlbumCompleted &&
          isInterestCompleted &&
          isAvailabilityCompleted &&
          isIntroVideoUploaded &&
          _profileImageUrl != null &&
          _profileImageUrl != "";

      // Logica tambien presente en userHelper.isElderProfileComplete()
      isElderProfileComplete = isBiographyCompleted &&
          isAddressCompleted &&
          isPhotoAlbumCompleted &&
          isInterestCompleted &&
          isAvailabilityCompleted &&
          _profileImageUrl != null &&
          _profileImageUrl != "";
    });
  }

  Future<void> _loadUserIdentity() async {
    try {
      Map<String, String?> urlsMap =
          await _filesService.getCurrentUserDocuments(context);
      bool _isUserIdentityUploaded = true;
      for (String key in urlsMap.keys) {
        if (urlsMap[key] == null) {
          _isUserIdentityUploaded = false;
        }
      }
      setState(() {
        isUserIdentityUploaded = _isUserIdentityUploaded;
        _loadProfileCompletion();
      });
    } catch (e) {
      setState(() {
        isUserIdentityUploaded = false;
        _loadProfileCompletion();
      });
    }
  }

  Future<void> _loadProfileImage() async {
    try {
      String? imageUrl =
          await _filesService.getProfileImageUrl(authProvider.user!.uid);
      setState(() {
        _profileImageUrl = imageUrl;
      });
    } catch (e) {
      print('Error al cargar la imagen de perfil: $e');
    }
  }

  void _loadProfileCompletion() {
    profileCompletionCards.clear();

    if (isBuddy) {
      profileCompletionCards.add(
        ProfileCompletionCard(
          title: "Verificar identidad",
          completed: isIdentityVerified,
          icon: Icons.verified_user_rounded,
          button: ElevatedButton(
            onPressed: isUserIdentityUploaded
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IdentityVerificationPage(
                          tabController: widget.tabController, 
                          updateSelectedIndex: widget.updateSelectedIndex,
                        )
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              disabledBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isUserIdentityUploaded ? "Te estamos validando..." : "Cargar",
            ),
          ),
        ),
      );
    }
    profileCompletionCards.add(ProfileCompletionCard(
        title: "Cargá tu foto de perfil",
        completed: _profileImageUrl != null && _profileImageUrl != "",
        icon: Icons.photo_camera_rounded,
        button: ElevatedButton(
          onPressed: () {
            _bottomSheet.show(context, _loadProfileImage);
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Cargar"),
        )));
    profileCompletionCards.add(ProfileCompletionCard(
        title: "Completá tu biografía",
        completed: isBiographyCompleted,
        icon: Icons.edit_document,
        button: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditBiographyPage(
                        isEdit: false,
                        tabController: widget.tabController, 
                        updateSelectedIndex: widget.updateSelectedIndex,
                      )),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Completar"),
        )));
    profileCompletionCards.add(ProfileCompletionCard(
        title: "Completá tu domicilio",
        completed: isAddressCompleted,
        icon: Icons.edit_document,
        button: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditAddressPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Completar"),
        )));
    profileCompletionCards.add(ProfileCompletionCard(
      title: "Completá tu album de fotos",
      completed: isPhotoAlbumCompleted,
      icon: Icons.photo_album,
      button: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditPhotosPage(
              tabController: widget.tabController, 
              updateSelectedIndex: widget.updateSelectedIndex,
            )),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text("Cargar"),
      )));
    profileCompletionCards.add(ProfileCompletionCard(
      title: "Completá tus intereses",
      completed: isInterestCompleted,
      icon: Icons.favorite_rounded,
      button: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditInterestsPage(
              tabController: widget.tabController, 
              updateSelectedIndex: widget.updateSelectedIndex,
            )),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text("Cargar"),
      )));
    profileCompletionCards.add(ProfileCompletionCard(
      title: "Completá tu disponibilidad horaria",
      completed: isAvailabilityCompleted,
      icon: Icons.schedule_rounded,
      button: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditAvailabilityPage(
              tabController: widget.tabController, 
              updateSelectedIndex: widget.updateSelectedIndex,
            )),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text("Cargar"),
      )));
    if (isBuddy) {
      profileCompletionCards.add(ProfileCompletionCard(
          title: "Cargá tu video introductorio",
          completed: isIntroVideoUploaded,
          icon: Icons.video_camera_back_rounded,
          button: ElevatedButton(
            onPressed: () async {
              // Esperamos el valor retornado por EditVideoPage
              final videoUploaded = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditVideoPage(
                  tabController: widget.tabController, 
                  updateSelectedIndex: widget.updateSelectedIndex,
                )),
              );

              // Si el video fue cargado, actualizamos el estado
              if (videoUploaded == true) {
                setState(() {
                  isIntroVideoUploaded = true;
                  _loadProfileCompletion();
                });
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Cargar"),
          )));
    }
    if (isBuddy) {
      bool isUnderReview =
          authProvider.userData!.buddy!.isApplicationToBeBuddyUnderReview;
      profileCompletionCards.add(ProfileCompletionCard(
          title: "Aplicá para ser Buddy",
          completed: isBuddyApplicationCompleted,
          icon: Icons.arrow_upward_rounded,
          button: ElevatedButton(
            onPressed: isBuddyProfileComplete &&
                    !isBuddyApplicationCompleted &&
                    !isUnderReview // Si el perfil esta completo y todavia no fue aprobado como Buddy, puede submittear la aplicacion
                ? () async {
                    await buddyService.sendBuddyApplication(context);
                    showBuddyApplicationDialog(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              isUnderReview
                  ? "Estamos revisando tu perfil"
                  : (isBuddyProfileComplete && !isBuddyApplicationCompleted
                      ? "Postularme"
                      : "Completá tu perfil antes"),
              textAlign: TextAlign.center,
            ),
          )));
    }
    profileCompletionCards.sort((a, b) => !a.completed
        ? 0
        : b.completed
            ? 0
            : 1);
    setState(() {
      profileCompletedProgress =
          profileCompletionCards.where((p) => p.completed).length;
    });

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registrationDate = authProvider.isBuddy
        ? DateFormat('MMM yyyy')
            .format(authProvider.userData!.buddy!.registrationDate)
        : DateFormat('MMM yyyy')
            .format(authProvider.userData!.elder!.registrationDate);

    final settingsToShow =
        authProvider.isBuddy ? customListTilesBuddy : customListTilesElder;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SettingsPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset(0.0, 0.0);
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.settings_rounded),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Muestra el indicador de carga centrado
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImageUrl != null
                              ? CachedNetworkImageProvider(
                                  _profileImageUrl!,
                                )
                              : AssetImage('assets/images/default_user.jpg')
                                  as ImageProvider,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              _bottomSheet.show(context, _loadProfileImage);
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.edit,
                                  color: theme.iconTheme.color),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${authProvider.personalData.firstName} ${authProvider.personalData.lastName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        authProvider.isBuddy
                            ? buildBuddyChip(
                                context,
                                theme,
                                isBuddyApplicationCompleted,
                                authProvider.userData!.buddy!
                                    .isApplicationToBeBuddyUnderReview)
                            : buildElderChip(context, theme),
                        SizedBox(width: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: theme.iconTheme.color,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              registrationDate,
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 25),
                QuickProfileSummary(
                  userID: authProvider.user!.uid,
                  isBuddy: isBuddy,
                ),
                const SizedBox(height: 25),
                if (profileCompletedProgress != profileCompletionCards.length)
                  _showCompletionCards(),
                ...List.generate(
                  settingsToShow.length,
                  (index) {
                    final tile = settingsToShow[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Card(
                        elevation: 4,
                        shadowColor: Colors.black12,
                        child: ListTile(
                          leading: Icon(tile.icon),
                          title: Text(tile.title),
                          onTap: () async =>
                              await _handleTileTap(context, tile.title),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
    );
  }

  Widget buildBuddyChip(BuildContext context, ThemeData theme,
          bool isBuddyApproved, bool isUnderReview) =>
      Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Buddy',
              style: TextStyle(
                color: theme.colorScheme.onTertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            isBuddyApproved
                ? Icon(
                    Icons.check_circle,
                    color: const Color.fromARGB(255, 100, 165, 219),
                    size: 20,
                  )
                : isUnderReview
                    ? Icon(
                        Icons.pending,
                        color: const Color.fromARGB(255, 201, 218, 92),
                        size: 20,
                      )
                    : Icon(
                        Icons.error_outline,
                        color: const Color.fromARGB(255, 205, 124, 62),
                        size: 20,
                      ),
          ],
        ),
        backgroundColor: theme.colorScheme.tertiary,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      );

  Widget buildElderChip(BuildContext context, ThemeData theme) => Chip(
        label: Text(
          'Mayor',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      );

  Future<void> _handleTileTap(BuildContext context, String title) async {
    Widget? targetPage;
    bool isVideoEdited = false;

    switch (title) {
      case 'Pagar suscripción':
        targetPage = PaymentPage();
      case 'Billetera':
        targetPage = WalletPage();
      case 'Disponibilidad horaria':
        targetPage = EditAvailabilityPage(
          tabController: widget.tabController, 
          updateSelectedIndex: widget.updateSelectedIndex,
        );
      case 'Biografia':
        targetPage = EditBiographyPage(
          isEdit: true,
          tabController: widget.tabController, 
          updateSelectedIndex: widget.updateSelectedIndex,
        );
      case 'Fotos':
        targetPage = EditPhotosPage(
          tabController: widget.tabController, 
          updateSelectedIndex: widget.updateSelectedIndex,
        );
      case 'Video introductorio':
        targetPage = EditVideoPage(
          tabController: widget.tabController, 
          updateSelectedIndex: widget.updateSelectedIndex,
        );
        isVideoEdited = true;
      case 'Intereses':
        targetPage = EditInterestsPage(
          tabController: widget.tabController, 
          updateSelectedIndex: widget.updateSelectedIndex,
        );
      case 'Datos de trabajo y/o estudio':
        targetPage = null;
    }
    if (targetPage != null && isVideoEdited) {
      // Esperamos el valor retornado por EditVideoPage
      final videoUploaded = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditVideoPage(
          tabController: widget.tabController, 
          updateSelectedIndex: widget.updateSelectedIndex,
        )),
      );

      // Si el video fue cargado, actualizamos el estado
      if (videoUploaded == true) {
        setState(() {
          isIntroVideoUploaded = true;
          _loadProfileCompletion();
        });
      }
    } else if (targetPage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetPage!),
      );
    }
  }

  Widget _showCompletionCards() {
    return Consumer<AuthSessionProvider>(
        builder: (context, authProvider, child) {
      return Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  "Completá tu perfil",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "($profileCompletedProgress/${profileCompletionCards.length})",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ...List.generate(profileCompletedProgress, (index) {
                return Expanded(
                  child: Container(
                    height: 7,
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                );
              }),
              ...List.generate(
                  profileCompletionCards.length - profileCompletedProgress,
                  (index) {
                return Expanded(
                  child: Container(
                    height: 7,
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceDim,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final card = profileCompletionCards[index];
                return SizedBox(
                  width: 160,
                  child: Card(
                    shadowColor: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(
                            card.icon,
                            size: 30,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            card.title,
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          card.completed
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                )
                              : card.button,
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  const Padding(padding: EdgeInsets.only(right: 5)),
              itemCount: profileCompletionCards.length,
            ),
          ),
          const SizedBox(height: 35),
        ],
      );
    });
  }
}

class ProfileCompletionCard {
  final String title;
  final bool completed;
  final ElevatedButton button;
  final IconData icon;
  ProfileCompletionCard({
    required this.title,
    required this.completed,
    required this.button,
    required this.icon,
  });
}

class CustomListTile {
  final IconData icon;
  final String title;
  CustomListTile({
    required this.icon,
    required this.title,
  });
}

List<CustomListTile> customListTilesBuddy = [
  CustomListTile(
    icon: Icons.payment,
    title: "Billetera",
  ),
  CustomListTile(
    icon: Icons.schedule,
    title: "Disponibilidad horaria",
  ),
  CustomListTile(
    icon: Icons.text_snippet,
    title: "Biografia",
  ),
  CustomListTile(
    icon: Icons.photo,
    title: "Fotos",
  ),
  CustomListTile(
    icon: Icons.video_camera_back,
    title: "Video introductorio",
  ),
  CustomListTile(
    icon: Icons.favorite,
    title: "Intereses",
  ),
  CustomListTile(
    icon: Icons.work,
    title: "Datos de trabajo y/o estudio",
  ),
];

List<CustomListTile> customListTilesElder = [
  CustomListTile(
    icon: Icons.payment,
    title: "Pagar suscripción",
  ),
  CustomListTile(
    icon: Icons.schedule,
    title: "Disponibilidad horaria",
  ),
  CustomListTile(
    icon: Icons.text_snippet,
    title: "Biografia",
  ),
  CustomListTile(
    icon: Icons.photo,
    title: "Fotos",
  ),
  CustomListTile(
    icon: Icons.favorite,
    title: "Intereses",
  ),
];

class QuickProfileSummary extends StatelessWidget {
  final String userID;
  final bool isBuddy;

  QuickProfileSummary({required this.userID, required this.isBuddy});

  Future<List<int>> fetchMeetingsInfo() async {
    return await Future.wait([
      userHelper.fetchExperience(userID, isBuddy),
      userHelper.fetchTotalMeetings(userID, isBuddy),
      userHelper.fetchTotalConnections(userID, isBuddy),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: fetchMeetingsInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error');
        } else {
          final totalHours = snapshot.data![0];
          final totalMeetings = snapshot.data![1];
          final totalConnections = snapshot.data![2];
          final experience = totalMeetings != 1 ? 'encuentros' : 'encuentro';
          final connection = totalConnections != 1 ? 'conexiones' : 'conexión';
          final hoursText = '$totalHours hrs';

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildButton(context, hoursText, 'de compañía'),
              buildDivider(),
              buildButton(context, totalMeetings.toString(), experience),
              buildDivider(),
              buildButton(context, totalConnections.toString(), connection),
            ],
          );
        }
      },
    );
  }

  Widget buildDivider() => SizedBox(
        height: 34,
        width: 20,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

void showBuddyApplicationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Aplicaste para ser Buddy!\n\nEstamos considerando tu perfil. En menos de 48hs vas a tener una respuesta.\n\nGracias!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              label: Text('Cerrar'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
