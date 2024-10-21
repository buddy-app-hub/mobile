import 'package:intl/intl.dart';
import 'package:mobile/models/price.dart';

Price getEmptyPrice() {
  return Price(amount: 0, currencyId: 'ARS');
}

Price getPrice(double amount, String currencyId) {
  return Price(amount: amount, currencyId: currencyId);
}

String getCurrencySymbol(String currencyId) {
  switch (currencyId) {
    case 'ARS':
      return '\$';
    case 'USD':
      return 'US\$';
    default:
      return '';
  }
}


String getWalletPrice(Price price, String txType) {
  final String benefit = txType == 'deposit' ? '+' : '-';
  return '$benefit${getFormattedPrice(price)}';
}

String getFormattedPrice(Price price) {
  return '${getCurrencySymbol(price.currencyId)}${formatPrice(price.amount)}';
}


String formatPrice(double number) {
  NumberFormat formatter = NumberFormat('###.##');
  String formatted = formatter.format(number);

  if (formatted.endsWith('.00')) {
    formatted = formatted.substring(0, formatted.length - 3);
  }

  return formatted;
}