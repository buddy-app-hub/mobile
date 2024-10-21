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
import 'package:mobile/pages/wallet/wallet.dart';
import 'package:mobile/pages/profile/edit_profile/settings.dart';
import 'package:mobile/services/files_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

UserHelper userHelper = UserHelper();

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late AuthSessionProvider authProvider;
  String? _profileImageUrl;
  final FilesService _filesService = FilesService();
  final EditProfileImageBottomSheet _bottomSheet =
      EditProfileImageBottomSheet();
  final List<ProfileCompletionCard> profileCompletionCards = [];
  int profileCompletedProgress = 0;
  bool? isBuddy;
  bool? isProfileImageUploaded;
  bool? isIdentityVerified;
  bool? isBiographyCompleted;
  bool? isPhotoAlbumCompleted;
  bool? isIntroVideoUploaded;
  bool? isBuddyApplicationCompleted;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    _loadProfileImage();
    setState(() {
      isBuddy = authProvider.userData!.buddy != null;
      isIdentityVerified = userHelper.isUserIdentityVerified(authProvider.userData!);
      isBiographyCompleted = userHelper.isUserBiographyCompleted(authProvider.userData!);
      isPhotoAlbumCompleted = userHelper.isUserPhotoAlbumCompleted(authProvider.userData!);
      isIntroVideoUploaded = userHelper.isIntroVideoUploaded(authProvider.userData!);
      isBuddyApplicationCompleted = userHelper.isUserBuddyApplicationCompleted(authProvider.userData!);
    });
  }

  Future<void> _loadProfileImage() async {
    try {
      String? imageUrl = await _filesService.getProfileImageUrl(authProvider.user!.uid);
      Map<String, String?> urlsMap = await _filesService.getCurrentUserDocuments(context);
      bool isUserIdentityUploaded = true;
      for (String key in urlsMap.keys) {
        if (urlsMap[key] == null) {
          isUserIdentityUploaded = false;
        }
      }
      setState(() {
        _profileImageUrl = imageUrl;
        isProfileImageUploaded = _profileImageUrl != null;
        isIdentityVerified = isUserIdentityUploaded;
        _loadProfileCompletion();
      });
    } catch (e) {
      setState(() {
        isProfileImageUploaded = false;
        isIdentityVerified = false;
        _loadProfileCompletion();
      });
      print('Error al cargar la imagen de perfil: $e');
    }
  }

  void _loadProfileCompletion() {
    profileCompletionCards.clear();
    
    if (isBuddy!) {
      profileCompletionCards.add(ProfileCompletionCard(
        title: "Verificar identidad",
        completed: isIdentityVerified!,
        icon: Icons.verified_user_rounded,
        button: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IdentityVerificationPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Enviar"),
        )
      ));
      if (isBuddy!) {
        profileCompletionCards.add(ProfileCompletionCard(
          title: "Cargá tu foto de perfil",
          completed: isProfileImageUploaded ?? false,
          icon: Icons.photo_camera_rounded,
          button: ElevatedButton(
            onPressed: () {
              _bottomSheet.show(context, _loadProfileImage);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Cargar"),
          )
        ));
      }
      profileCompletionCards.add(ProfileCompletionCard(
        title: "Completá tu biografía",
        completed: isBiographyCompleted!,
        icon: Icons.edit_document,
        button: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditBiographyPage(isEdit: false,)),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Completar"),
        )
      ));
      profileCompletionCards.add(ProfileCompletionCard(
        title: "Completá tu album de fotos",
        completed: isPhotoAlbumCompleted!,
        icon: Icons.photo_album,
        button: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditPhotosPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Cargar"),
        )
      ));
      if (isBuddy!) {
        profileCompletionCards.add(ProfileCompletionCard(
          title: "Cargá tu video introductorio",
          completed: isIntroVideoUploaded!,
          icon: Icons.video_camera_back_rounded,
          button: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfilePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Cargar"),
          )
        ));
      }
      if (isBuddy!) {
        profileCompletionCards.add(ProfileCompletionCard(
          title: "Aplicá para ser Buddy",
          completed: isBuddyApplicationCompleted!,
          icon: Icons.arrow_upward_rounded,
          button: ElevatedButton(
            onPressed: () {
              
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Enviar"),
          )
        ));
      }
    }
    setState(() {
      profileCompletedProgress = profileCompletionCards.where((p) => p.completed).length;
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

    final settingsToShow = authProvider.isBuddy ? customListTilesBuddy : customListTilesElder;

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
      body: ListView(
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
                        child: Icon(Icons.edit, color: theme.iconTheme.color),
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
                      ? buildBuddyChip(context, theme)
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
          QuickProfileSummary(),
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
                    onTap: () => _handleTileTap(context, tile.title),
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

  Widget buildBuddyChip(BuildContext context, ThemeData theme) => Chip(
        label: Text(
          'Buddy',
          style: TextStyle(
            color: theme.colorScheme.onTertiary,
            fontWeight: FontWeight.bold,
          ),
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

  void _handleTileTap(BuildContext context, String title) {
    Widget? targetPage;

    switch (title) {
      case 'Pagar suscripción':
        targetPage = PaymentPage();
      case 'Billetera':
        targetPage = WalletPage();
      case 'Disponibilidad horaria':
        targetPage = EditAvailabilityPage();
      case 'Biografia':
        targetPage = EditBiographyPage(isEdit: true,);
      case 'Fotos':
        targetPage = EditPhotosPage();
      case 'Video introductorio':
        targetPage = MyProfilePage();
      case 'Intereses':
        targetPage = EditInterestsPage();
      case 'Datos de trabajo y/o estudio':
        targetPage = MyProfilePage();
    }

    if (targetPage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetPage!),
      );
    }
  }

  Widget _showCompletionCards() {
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
            ...List.generate(profileCompletionCards.length - profileCompletedProgress, (index) {
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
                        if (!card.completed)
                          card.button,
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
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, '4h 30m', 'de compañía'),
          buildDivider(),
          buildButton(context, '3', 'experiencias'),
          buildDivider(),
          buildButton(context, '31', 'seguidores'),
        ],
      );
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
