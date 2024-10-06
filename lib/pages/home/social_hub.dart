import 'package:flutter/material.dart';
import 'package:mobile/models/user_data.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_card.dart';

class SocialHubPage extends StatelessWidget {

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  void _onSearchChanged(String query) {
    searchQuery = query;
    debugPrint('search $searchQuery');
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBody: true,
      extendBodyBehindAppBar: true, 
      resizeToAvoidBottomInset: false, 
      body: Stack (
        children: [
          SingleChildScrollView( // Hacer que el contenido sea desplazable verticalmente
            child: Padding (
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 10, 15),
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(
                          color: theme.colorScheme.outline,
                          width: 1.5, 
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          icon: Icon(Icons.search),
                          iconColor: theme.colorScheme.outline,
                          hintText: 'Buscar actividades',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          'Actividades',
                          style: ThemeTextStyle.titleMediumInverseSurface(context),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Column(
                      children: [
                        BaseCard(
                          title: 'Club de Lectura',
                          location: 'Buenos Aires', 
                          rate: '4.1', 
                          reviews: '10', 
                          time: 'Miercoles de 10.00 a 11.00',
                          description: 'Espacio grupal que busca fomentar la lectura...', 
                          image: 'assets/images/reading_club.png',
                        ),
                        BaseCard(
                          title: 'Taller de bordado',
                          location: 'Pilar', 
                          rate: '4.2', 
                          reviews: '8', 
                          time: 'Jueves de 17.00 a 18.30',
                          description: 'Este taller tiene como objetivo aprender y disfrutar del bordado en todas sus formas', 
                          image: 'assets/images/crafts.png',
                        ),
                        BaseCard(
                          title: 'Taller de velas',
                          location: 'Caballito', 
                          rate: '4.2', 
                          reviews: '18', 
                          time: 'Martes de 14.00 a 15.00',
                          description: 'Sumérgete en un mundo de aromas y luces, y aprende a crear velas que iluminarán tu hogar.', 
                          image: 'assets/images/candles.jpeg',
                        ),
                        BaseCard(
                          title: 'Taller de cerámica',
                          location: 'Villa Devoto', 
                          rate: '4.4', 
                          reviews: '15', 
                          time: 'Lunes de 17.00 a 18.00',
                          description: 'Moldea tu imaginación y crea piezas únicas en nuestro taller de cerámica...', 
                          image: 'assets/images/pottery.jpeg',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildUserDetails(UserData userData) {
    List<Widget> details = [];

    if (userData.buddy != null) {
      details.add(Text("User Type: Buddy"));
    } else if (userData.elder != null) {
      details.add(Text("User Type: Elder"));
    }

    userData.toJson().forEach((key, value) {
      if (value != null) {
        details.add(Text("$key: $value"));
      }
    });

    return details;
  }
}