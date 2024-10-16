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
}
