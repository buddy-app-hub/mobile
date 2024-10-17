import 'package:mobile/models/payment.dart';
import 'package:mobile/models/payment_handshake.dart';
import 'package:mobile/services/payment_api_service.dart';

class PaymentService {
  Future<PaymentHandshake> getHandshake(
    String connectionId,
    ) async {
    var response = await PaymentApiService.get(
      endpoint: "/payments/init?connection_id=$connectionId",
    );

    print(response);

    return PaymentHandshake.fromJson(response);
  }

  Future<Payment> create(
    String description,
    String walletId,
    String paymentOrderId,
    String connectionId) async {
    var response = await PaymentApiService.post(
      endpoint: "/payments?description=$description&wallet_id=$walletId",
      body: {
        "amount": 5000,
        "currency_id": "ARS",
        "connection_id": connectionId,
        "payment_order_id": paymentOrderId,
      },
    );

    print(response);

    return Payment.fromJson(response);
  }
}
