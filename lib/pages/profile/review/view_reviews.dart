import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/helper/user_helper.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/review.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';

class ViewReviewsPage extends StatefulWidget {
  const ViewReviewsPage({super.key, required this.isBuddy, required this.personID,});

  final bool isBuddy;
  final String personID;
  @override
  _ViewReviewsPageState createState() => _ViewReviewsPageState();
}

class _ViewReviewsPageState extends State<ViewReviewsPage> {
  UserHelper userHelper = UserHelper();
  final connectionService = ConnectionService();
  String personName = '';
  Map<Meeting, Review> _meetings = {};

  @override
  void initState() {
    super.initState();
    _fetchPersonName();
    _fetchMeetings();
  }

  Future<void> _fetchMeetings() async {
    Map<Meeting, Review> meetings = await userHelper.fetchReviews(widget.personID, widget.isBuddy);
    setState(() {
      _meetings = meetings;
    });
  }

  Future<void> _fetchPersonName() async {
    print(widget.isBuddy);
    final name = await userHelper.fetchProfileFullName(widget.personID, widget.isBuddy);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 28, 20),
                child: Text(
                  'Ver opiniones de $personName',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ),
              if (_meetings.isNotEmpty)
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _meetings.entries.map((entry) {
                        Meeting meeting = entry.key;
                        Review review = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: buildReviews(context, theme, getMeetingDate(meeting.schedule.date), review),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              if (_meetings.isEmpty)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(80),
                    child: Text(
                      "No hay opiniones.",
                      style: ThemeTextStyle.itemLargeOnBackground(context),
                    )
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReviews(BuildContext context, ThemeData theme, String date, Review review) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 18, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                        initialRating: review.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemSize: 22,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.01),
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rate_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                       Container(
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text(
                          date,
                          style: ThemeTextStyle.titleSmallBright(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  review.comment,
                  style: ThemeTextStyle.titleSmallOnBackground(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}