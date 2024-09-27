import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/pages/connections/meetings/new_meeting.dart';
import 'package:mobile/pages/profile/profile_widgets.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/widgets/base_decoration.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class ViewProfilePage extends StatefulWidget {
  final Connection connection;
  final String personID;
  final bool isBuddy;

  const ViewProfilePage({required this.connection, required this.personID, required this.isBuddy});

  @override
  State<ViewProfilePage> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfilePage> {
  UserHelper userHelper = UserHelper();
  String _profileImageUrl = '';
  String perseonName = '';
  ElderService elderService = ElderService();
  BuddyService buddyService = BuddyService();
  String description = '';
  List<Interest> interest = List.empty();
  List<custom_time.TimeOfDay> availability = List.empty();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _fetchPersonName();
    _fetchPersonProfile();
  }

  Future<void> _loadProfileImage() async {
    String? imageUrl =
        await userHelper.loadProfileImage(widget.personID);

    setState(() {
      _profileImageUrl = imageUrl;
    });
  }

  Future<void> _fetchPersonName() async {
    final name = await userHelper.fetchProfileFullName(widget.personID, widget.isBuddy);
    if (name.isEmpty) {
      setState(() {
        perseonName = 'Error fetching the name';
      });
    } else {
      setState(() {
        perseonName = name;
      });
    }
  }

  Future<void> _fetchPersonProfile() async {
    if (widget.isBuddy) {
      final profile = await elderService.getElder(widget.personID);
      if (profile != null) {
        setState(() {
          description = profile.elderProfile!.description!;
          interest = profile.elderProfile!.interests!;
          availability = profile.elderProfile!.availability!;
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
        description = profile.buddyProfile!.description!;
        interest = profile.buddyProfile!.interests!;
        availability = profile.buddyProfile!.availability!;
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
                  MaterialPageRoute(builder: (context) => NewMeetingPage(connection: widget.connection)),
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
            Center(
              child: ProfileWidgets.buildProfileData(context, theme, _profileImageUrl, perseonName, widget.isBuddy),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
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
                          ProfileWidgets.buildProfileInfo(context, theme, widget.isBuddy, description, interest, availability),
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