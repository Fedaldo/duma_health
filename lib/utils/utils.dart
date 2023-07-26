import 'package:intl/intl.dart';

class Utils {
  static bool checkConnectionError(e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('HandshakeException')) {
      return true;
    } else {
      return false;
    }
  }

  static String formatPrice(String value) {
    if(value == "null"){
      return "0";
    }
    double amountInDouble = double.parse(value);
    String formatAmount = NumberFormat().format(amountInDouble);
    return formatAmount;
  }

  static String dateFormat(DateTime value) {
    return DateFormat("yyyy-MM-dd").format(value);
  }

  static String getStatus(int value) {
    switch (value) {
      case 1:
        return "Pending";
      case 2:
        return "Confirmed";
      default:
        return "Canceled";
    }
  }
}
