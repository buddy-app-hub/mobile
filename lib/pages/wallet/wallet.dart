import 'package:flutter/material.dart';
import 'package:mobile/models/price.dart';
import 'package:mobile/models/transaction.dart';
import 'package:mobile/models/wallet.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/wallet_service.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/format_date.dart';
import 'package:mobile/utils/price_helper.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatefulWidget {
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  WalletService walletService = WalletService();
  List<Tx> transactions = List.empty();
  Price balance = getEmptyPrice();
  Price total = getEmptyPrice();

  @override
  void initState() {
    super.initState();
    _fetchWallet();
  }

  Future<void> _fetchWallet() async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);

    final Wallet wallet =
        await walletService.getWallet(authProvider.userData!.buddy!.walletId!);

    if (wallet != null) {
      wallet.transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        transactions = wallet.transactions;
        total = wallet.total != null ? wallet.total! : getEmptyPrice();
        balance = wallet.balance != null ? wallet.balance! : getEmptyPrice();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.colorScheme.primaryContainer,
        appBar: AppBar(
          title: Text("Billetera"),
          backgroundColor: theme.colorScheme.primaryContainer,
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              _fetchWallet();
            },
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: theme.colorScheme.primaryContainer,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(getFormattedPrice(balance),
                                    style: ThemeTextStyle
                                        .titleXLargeOnBackground700(context)),
                              ],
                            ),
                            Text(
                              "Saldo disponible",
                              style:
                                  ThemeTextStyle.titleMediumOnPrimaryContainer(
                                      context),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            RichText(
                              text: TextSpan(
                                style: ThemeTextStyle
                                    .titleMediumOnPrimaryContainer(context),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: getWalletPrice(total, 'deposit'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.lightGreen),
                                  ),
                                  TextSpan(text: ' desde que eres Buddy'),
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 16),
                                child: BaseElevatedButton(
                                  text: "Retirar dinero",
                                  buttonStyle:
                                      ThemeButtonStyle.primaryButtonStyle(
                                          context),
                                  buttonTextStyle:
                                      ThemeTextStyle.titleLargeOnPrimary(
                                          context),
                                  onPressed: () =>
                                      showWithdrawBottomSheet(context),
                                ))
                          ],
                        ),
                      ),
                      DraggableScrollableSheet(
                        builder: (context, scrollController) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(243, 245, 248, 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 32),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Últimos movimientos",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 24,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),

                                  //Container for buttons
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.15),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 4.5)
                                              ]),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Text(
                                            "Todo",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Colors.grey[900]),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.15),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 4.5)
                                              ]),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Row(
                                            children: <Widget>[
                                              CircleAvatar(
                                                radius: 8,
                                                backgroundColor: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "Ingresos",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    color: Colors.grey[900]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.15),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 4.5)
                                              ]),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Row(
                                            children: <Widget>[
                                              CircleAvatar(
                                                radius: 8,
                                                backgroundColor: Colors.orange,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "Retiros",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    color: Colors.grey[900]),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 16,
                                  ),

                                  _buildTransactionList(context, transactions)
                                          .isEmpty
                                      ? _zeroTransactions(context)
                                      : Column(
                                          children: _buildTransactionList(
                                              context, transactions),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                        initialChildSize: 0.65,
                        minChildSize: 0.65,
                        maxChildSize: 0.85,
                      )
                    ],
                  ),
                ))));
  }

  Future<void> showWithdrawBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: getBottomSheetWidgets(),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> getBottomSheetWidgets() {
    if (balance.amount <= 0) {
      return <Widget>[
        const Text(
          'No tienes saldo disponible para retirar',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
      ];
    }

    bool pendingWithdrawal(Tx tx) =>
        tx.type == 'withdraw' && tx.status == 'pending';

    if (transactions.any(pendingWithdrawal)) {
      return <Widget>[
        const Text(
          'Ya tienes un retiro en proceso',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        const Text(
          'Normalmente tiene una demora de 48 a 96 horas hábiles',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        ),
      ];
    }
    return <Widget>[
      const Text(
        'Solicitar el retiro de dinero',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
      ),
      const Text(
        'Depositaremos en el CBU que nos proporcionaste el saldo disponible que tengas hasta la fecha.',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      const SizedBox(
        height: 24,
      ),
      const Text(
        'Normalmente tiene una demora de 48 a 96 horas hábiles',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
      BaseElevatedButton(
        text: "Solicitar retiro",
        buttonStyle: ThemeButtonStyle.primaryButtonStyle(context),
        buttonTextStyle: ThemeTextStyle.titleLargeOnPrimary(context),
        onPressed: _withdraw,
      ),
    ];
  }

  Future<void> _withdraw() async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);
    try {
      await walletService.withdraw(
          authProvider.userData!.buddy!.walletId!, balance);
      await _fetchWallet();
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }
}

Widget _transactionCard(
    BuildContext context,
    String title,
    String? subtitle,
    Color? subtitleColor,
    String amount,
    String date,
    String type,
    String status) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.all(Radius.circular(18))),
          padding: EdgeInsets.all(12),
          child: Icon(
            type == 'withdraw' ? Icons.attach_money_sharp : Icons.date_range,
            color: Colors.lightBlue[900],
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[900]),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: subtitleColor),
                ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            if (status != 'canceled')
              Text(
                amount,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color:
                        type == 'withdraw' ? Colors.orange : Colors.lightGreen),
              ),
            Text(
              date,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    ),
  );
}

List<Widget> _buildTransactionList(
    BuildContext context, List<Tx> transactions) {
  List<Widget> transactionCards = [];
  for (Tx tx in transactions) {
    transactionCards.add(_transactionCard(
        context,
        tx.description,
        getTxSubtitle(tx.status),
        getTxSubtitleColor(tx.status),
        getWalletPrice(getPrice(tx.amount, tx.currencyId), tx.type),
        formatDateWallet(tx.createdAt),
        tx.type,
        tx.status));
  }
  return transactionCards;
}

Widget _zeroTransactions(BuildContext context) {
  return Center(
      child: Text(
    "No hay transacciones",
    style: TextStyle(color: Colors.grey[500], fontSize: 16),
  ));
}

String? getTxSubtitle(String status) {
  switch (status) {
    case 'pending':
      return 'Pendiente';
    case 'canceled':
      return 'Cancelado';
    default:
      return null;
  }
}

Color? getTxSubtitleColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.grey[500];
    case 'canceled':
      return Colors.red[500];
    default:
      return null;
  }
}
