import 'package:duma_health/afripay/afripay_client.dart';

class Afripay {
  static final Afripay _instance = Afripay._internal();
  static AfripayClient? _afripayClient;

  factory Afripay() {
    return _instance;
  }

  Afripay._internal();

  static AfripayClient? getAfripayClient() {
    return _afripayClient;
  }

  static void setAfripayClient(AfripayClient afripayClient) {
    _afripayClient = afripayClient;
  }
}
