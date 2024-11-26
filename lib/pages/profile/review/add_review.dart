import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/models/buddy.dart';
import 'package:mobile/models/connection.dart';
import 'package:mobile/models/meeting.dart';
import 'package:mobile/models/payment.dart';
import 'package:mobile/models/review.dart';
import 'package:mobile/models/transaction.dart';
import 'package:mobile/models/wallet.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/connection_service.dart';
import 'package:mobile/services/payment_service.dart';
import 'package:mobile/services/wallet_service.dart';
import 'package:mobile/theme/theme_text_style.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key, required this.isBuddy, required this.connection, required this.meeting, required this.personID, required this.personName});

  final bool isBuddy;
  final Connection connection;
  final Meeting meeting;
  final String personID;
  final String personName;
  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final buddyService = BuddyService();
  final connectionService = ConnectionService();
  final paymentService = PaymentService();
  final walletService = WalletService();
  late TextEditingController _commentController;
  double _rating = 3;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  Future<void> _submitReview() async {
    print('Rating: $_rating, Comment: ${_commentController.text}');
    Review review = Review(rating: _rating, comment: _commentController.text);

    if (_rating > 0 && _commentController.text.isNotEmpty) {
      if (widget.isBuddy) {
        widget.meeting.buddyReviewForElder = review;
      } else {
        widget.meeting.elderReviewForBuddy = review;
        print('Elder Rating: ${widget.meeting.elderReviewForBuddy}');
      }

      await connectionService.updateMeetingOfConnection(context, widget.connection, widget.meeting);

      if (!widget.isBuddy) { // mark payment as finish
        final List<Future<Object>> fetchers = [
          buddyService.getBuddy(widget.personID).then((b) => b.walletId!), // [0] => String walletId
          paymentService.getAll(widget.connection.id)
          .then((p) => Set.from(
            p.where((p) => p.connectionId == widget.connection.id)
            .map((tx) => tx.id)
          )), // [1] => Set<String> paymentIds
        ];

        final List<Object> results = await Future.wait(fetchers);
        String walletId = results[0] as String;
        Set<String> paymentsFromElder = results[1] as Set<String>;

        // Buddy bud = await buddyService.getBuddy(widget.personID);
        // List<Payment> payments = await paymentService.getAll(widget.connection.id);
        // Set<String> paymentsFromElder = Set.from(
        //   payments
        //   .where((p) => p.connectionId == widget.connection.id)
        //   .map((tx) => tx.id)
        // );

        Wallet wallet = await walletService.getWallet(walletId);
        int idxTx = wallet.transactions.lastIndexWhere((tx) => "pending" == tx.status && paymentsFromElder.contains(tx.paymentId));
        Tx oldTx = wallet.transactions[idxTx];
        wallet.transactions[idxTx] = Tx(
          paymentId: oldTx.paymentId,
          status: 'approved',
          type: oldTx.type,
          description: oldTx.description,
          amount: oldTx.amount,
          currencyId: oldTx.currencyId,
          createdAt: oldTx.createdAt,
          updatedAt: oldTx.updatedAt,
        );

        await walletService.updateTransactions(walletId, wallet.transactions);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calificación enviada.')),
      );
      Navigator.pushNamed(context, Routes.splashScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos para enviar tu calificación.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 28, 20),
                child: Text(
                  'Calificar encuentro',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 18),
                child: Text(
                  'Califica a ${widget.personName}.',
                  style: ThemeTextStyle.titleInfoSmallOutline(context),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 18),
                child: Center(
                  child: RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star_rate_rounded,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 18),
                child: Text(
                  'Contanos un poco más sobre cómo fue ${widget.meeting.activity.toLowerCase()} con ${widget.personName}.',
                  style: ThemeTextStyle.titleInfoSmallOutline(context),
                  textAlign: TextAlign.left,
                ),
              ),
              TextField(
                controller: _commentController,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Escribe tu opinión aquí...',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: ElevatedButton(
          onPressed: () {
            _submitReview();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            backgroundColor: theme.colorScheme.inversePrimary,
          ),
          child: Text(
            'Enviar',
            style:
                TextStyle(color: theme.colorScheme.onPrimaryContainer, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
