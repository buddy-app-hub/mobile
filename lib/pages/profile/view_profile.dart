import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/pages/connections/meetings/new_meeting.dart';
import 'package:mobile/pages/profile/profile_widgets.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/services/files_service.dart';
import 'package:mobile/widgets/base_decoration.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class ViewProfilePage extends StatefulWidget {
  final Connection connection;
  final String personID;
  final bool isBuddy; // Refiere al usuario actual

  const ViewProfilePage({required this.connection, required this.personID, required this.isBuddy});

  @override
  State<ViewProfilePage> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfilePage> {
  UserHelper userHelper = UserHelper();
  ElderService elderService = ElderService();
  BuddyService buddyService = BuddyService();
  final FilesService _filesService = FilesService();
  double globalRating = 0;
  String location = 'Argentina';
  String description = '';
  List<Interest> interest = List.empty();
  List<custom_time.TimeOfDay> availability = List.empty();
  int xpHours= 0;
  String personName = '';
  List<String?> _photoUrls = [];

  @override
  void initState() {
    super.initState();
    _loadUserPhotos();
    _loadExperienceHours();
    _fetchPersonName();
    _fetchPersonProfile();
  }

  Future<void> _loadExperienceHours() async {
    int? experience =
        await userHelper.fetchExperience(widget.personID, !widget.isBuddy);

    setState(() {
      xpHours = experience;
    });
  }

  Future<void> _loadUserPhotos() async {
    print("Cargando fotos");
    try {
      final List<String?> urls = await _filesService.getUserPhotos(widget.personID,
          !widget.isBuddy,
          this.context);
      setState(() {
        _photoUrls = urls;
        print("Fotos cargadas");
      });
    } catch (e) {
      print('Error loading photos: $e');
    }
  }


  Future<void> _fetchPersonName() async {
    final name = await userHelper.fetchProfileFullName(widget.personID, !widget.isBuddy); //isBuddy es el de la persona, tengo que mandar el de la conexion
    if (name.isEmpty) {
      setState(() {
        personName = 'Error fetching the name';
      });
    } else {
      setState(() {
        personName = name;
      });
    }
  }

  Future<void> _fetchPersonProfile() async {
    if (widget.isBuddy) {
      final profile = await elderService.getElder(widget.personID);
      if (profile != null) {
        setState(() {
          location = profile.personalData.address!.city;
          description = profile.elderProfile!.description!;
          interest = profile.elderProfile!.interests!;
          availability = profile.elderProfile!.availability!;
          globalRating = profile.elderProfile?.globalRating ?? 0.0;
        });
      } else {
        setState(() {
          description = 'No data available';
          interest = [];
          availability = [];
        });
      }
    } else {
      final profile = await buddyService.getBuddy(widget.personID);
      setState(() {
        location = profile.personalData.address!.city;
        description = profile.buddyProfile!.description!;
        interest = profile.buddyProfile!.interests!;
        availability = profile.buddyProfile!.availability!;
        globalRating = profile.buddyProfile?.globalRating ?? 0.0;
      });
    }
  }

  @override 
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
      
    return
    SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.isBuddy ? theme.colorScheme.primaryFixedDim : theme.colorScheme.tertiaryContainer,
          shadowColor: widget.isBuddy ? theme.colorScheme.primaryFixedDim : theme.colorScheme.tertiaryContainer,
          actions: [
          if (!widget.isBuddy)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewMeetingPage(connection: widget.connection, isBuddy: false)), //solo los elders pueden generar un nuevo encuentro
                );
              },
              icon: Icon(Icons.add, color: theme.colorScheme.onTertiaryContainer),
            ),
        ],
        ),
        backgroundColor: widget.isBuddy ? theme.colorScheme.primaryFixedDim : theme.colorScheme.tertiaryContainer,
        extendBody: true,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
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
              ],
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 310, 0, 0),
                child: Column(
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
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 5),
                            child: ProfileWidgets.buildProfileData(context, theme, personName, globalRating.toString(), xpHours, location, !widget.isBuddy),
                          ), //isBuddy es el de la persona, tengo que mandar el de la conexion
                          ProfileWidgets.buildProfileInfo(context, theme, widget.personID, false, !widget.isBuddy, globalRating, description, interest, availability), //isBuddy es el de la persona, tengo que mandar el de la conexion
                        ],
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
}