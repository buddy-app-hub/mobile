import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/profile/settings.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthSessionProvider>(context);
    final name = authProvider.isBuddy
        ? '${authProvider.userData!.buddy!.firstName} ${authProvider.userData!.buddy!.lastName}'
        : '${authProvider.userData!.elder!.firstName} ${authProvider.userData!.elder!.lastName}';
    final registrationDate = authProvider.isBuddy
        ? DateFormat('MMM yyyy')
            .format(authProvider.userData!.buddy!.registrationDate)
        : DateFormat('MMM yyyy')
            .format(authProvider.userData!.elder!.registrationDate);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
          // COLUMN THAT WILL CONTAIN THE PROFILE
          Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    "https://media.diariouno.com.ar/p/46001b6b2986d60fca9c73571135ca64/adjuntos/298/imagenes/009/381/0009381866/1200x0/smart/julian-1jpg.jpg"),
              ),
              SizedBox(height: 10),
              Text(
                name,
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
                      SizedBox(width: 4), // Espacio entre el icono y el texto
                      Text(
                        registrationDate,
                        style: TextStyle(
                          color: theme
                              .textTheme.bodyLarge?.color, // Color del texto
                          fontWeight: FontWeight
                              .bold, // Puedes ajustar el grosor del texto
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
          Row(
            children: const [
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
                "(1/5)",
                style: TextStyle(
                  color: Colors.blue,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(6, (index) {
              return Expanded(
                child: Container(
                  height: 7,
                  margin: EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: index == 0 ? Colors.blue : Colors.black12,
                  ),
                ),
              );
            }),
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
                    shadowColor: Colors.black12,
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
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(card.buttonText),
                          )
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
          ...List.generate(
            customListTiles.length,
            (index) {
              final tile = customListTiles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black12,
                  child: ListTile(
                    leading: Icon(tile.icon),
                    title: Text(tile.title),
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
}

class ProfileCompletionCard {
  final String title;
  final String buttonText;
  final IconData icon;
  ProfileCompletionCard({
    required this.title,
    required this.buttonText,
    required this.icon,
  });
}

List<ProfileCompletionCard> profileCompletionCards = [
  ProfileCompletionCard(
    title: "Cargá tu foto de perfil",
    icon: Icons.photo_camera,
    buttonText: "Cargar",
  ),
  ProfileCompletionCard(
    title: "Completá tu biografía",
    icon: Icons.edit_document,
    buttonText: "Completar",
  ),
  ProfileCompletionCard(
    title: "Completá tus album de fotos",
    icon: Icons.photo_album,
    buttonText: "Cargar",
  ),
  ProfileCompletionCard(
    title: "Cargá tu video introductorio",
    icon: Icons.video_camera_back,
    buttonText: "Cargar",
  ),
  ProfileCompletionCard(
    title: "Aplicá para ser Buddy",
    icon: Icons.arrow_upward,
    buttonText: "Enviar",
  ),
];

class CustomListTile {
  final IconData icon;
  final String title;
  CustomListTile({
    required this.icon,
    required this.title,
  });
}

List<CustomListTile> customListTiles = [
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
    icon: Icons.video_collection,
    title: "Video introductorio",
  ),
  CustomListTile(
    icon: Icons.airplane_ticket_outlined,
    title: "Intereses",
  ),
  CustomListTile(
    title: "Datos de trabajo y/o estudio",
    icon: Icons.work,
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
