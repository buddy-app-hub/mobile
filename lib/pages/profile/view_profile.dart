import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/interest.dart';
import 'package:mobile/models/time_of_day.dart' as custom_time;
import 'package:mobile/pages/connections/meetings/new_meeting.dart';
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
                  MaterialPageRoute(builder: (context) => NewMeetingPage(connection: widget.connection, isBuddy: widget.isBuddy)),
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
              child: _buildProfileData(context, theme),
            ),
            // todo determinar si vamos a uar el carrousel o no
            // Positioned(
            //   left: 0,
            //   right: 0,
            //   top: -15,
            //   height: 530,
            //   child: CarouselSlider(
            //     items: [
            //       Image.asset('assets/images/buddyProfile.jpeg', fit: BoxFit.cover),
            //       Image.asset('assets/images/buddyProfile2.jpeg', fit: BoxFit.cover),
            //       Image.asset('assets/images/buddyProfile3.jpeg', fit: BoxFit.cover),
            //       ],
            //     options: CarouselOptions(
            //       aspectRatio: 9/45,
            //       viewportFraction: 1,
            //       initialPage: 0,
            //       enableInfiniteScroll: true,
            //       autoPlay: true,
            //       autoPlayInterval: Duration(seconds: 4),
            //       autoPlayCurve: Curves.fastOutSlowIn,
            //     ),
            //   ),
            // ),
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
                          _buildProfileInfo(context, theme),
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

  Widget _buildProfileData(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _profileImageUrl.isEmpty
            ? AssetImage('assets/images/default_user.jpg')
            : NetworkImage(_profileImageUrl)
                as ImageProvider,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                perseonName,
                style: widget.isBuddy ? ThemeTextStyle.titleLargeOnPrimaryFixed(context) : ThemeTextStyle.titleLargeOnTertiaryContainer(context),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BaseDecoration.buildRowLocationReviewProfile(context, widget.isBuddy, 'Buenos Aires', '4.4', '41'),
                  ],
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context, ThemeData theme) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 45),
      child: Column(
        children: [
          BaseDecoration.buildTitleProfile(context, widget.isBuddy ? 'Sobre este adulto mayor' : 'Sobre este buddy', widget.isBuddy),
          _buildPersonalInformation(context),
          BaseDecoration.buildTitleProfile(context, 'Intereses', widget.isBuddy),
          _buildInterests(context, theme),
          BaseDecoration.buildTitleProfile(context, 'Disponibilidad horaria', widget.isBuddy),
          _buildAvailability(context, theme),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseDecoration.buildTitleProfile(context, 'Opiniones', widget.isBuddy),
              Container(
                margin: EdgeInsets.fromLTRB(0, 25, 28, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                  onPressed: () {
                    print('veo rewiews');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const Reviews()),
                    // );
                  },
                  child: Text(
                    "Ver más",
                    style: ThemeTextStyle.titleSmallBright(context),
                  )),
                ),
              )
            ],
          ),
          _buildReviews(context, theme),
        ],
      ),
    );
  }

  Widget _buildPersonalInformation(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0.5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded (
                        child: Text(
                          description,
                          style: ThemeTextStyle.itemLargeOnBackground(context),
                        ),
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

  Widget _buildInterests(BuildContext context, ThemeData theme) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (interest.isNotEmpty)
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0.5, 0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4.0,
                  runSpacing: 8.0,
                  children: interest.map((tag) => BaseDecoration.buildInterestTag(context, tag, widget.isBuddy, theme)).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailability(BuildContext context, theme) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 1, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0.5, 0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4.0,
                    runSpacing: 8.0,
                    children: availability.map((day) => BaseDecoration.buildAvailabilityTag(context, day, widget.isBuddy, theme)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews(BuildContext context, theme) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 28, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(28, 0, 18.3, 85),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/default_user.jpg',
                ),
              ),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: SizedBox(
            width: 45,
            height: 45,
          ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 2.9, 8.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
                        child: SizedBox(
                          width: 152.5,
                          child: Text(
                            'Pepe Argento',
                            style: ThemeTextStyle.itemLargeOnBackground(context),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text(
                          '23 Nov 2023',
                          style: ThemeTextStyle.itemSmallOnBackground(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16.3),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 117,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                              ),
                            ),
                          ),
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                              ),
                            ),
                          ),
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                              ),
                            ),
                          ),
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                              ),
                            ),
                          ),
                          Container(
                            width: 16.1,
                            height: 14,
                            child: SizedBox(
                              width: 16.1,
                              height: 13.4,
                              child: SvgPicture.asset(
                                'assets/icons/star.svg',
                                color: theme.colorScheme.secondary.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
                  style: ThemeTextStyle.itemLargeOnBackground(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}