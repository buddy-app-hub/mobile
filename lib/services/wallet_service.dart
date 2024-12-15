import 'package:mobile/models/price.dart';
import 'package:mobile/models/transaction.dart';
import 'package:mobile/models/wallet.dart';
import 'package:mobile/services/payment_api_service.dart';

class WalletService {
  Future<Wallet> getWallet(String id) async {
    var response = await PaymentApiService.get(
      endpoint: "/wallets/$id",
    );

    print(response);

    return Wallet.fromJson(response);
  }

  Future<Wallet> withdraw(String id, Price price) async {
    var response = await PaymentApiService.post(
      endpoint: "/wallets/$id/transactions",
      body: {
        "amount": price.amount,
        "currency": price.currencyId,
        "description": "Retiro",
        "payment_id": "withdrawal",
        "status": "pending",
        "type": "withdraw",
      },
    );

    print(response);

    return Wallet.fromJson(response);
  }

  Future<Wallet> updateTransactions(String id, List<Tx> transactions) async {
    var response = await PaymentApiService.put(
      endpoint: "/wallets/$id",
      body: {
        "transactions": transactions,
      },
    );

    print(response);

    return Wallet.fromJson(response);
  }
}
