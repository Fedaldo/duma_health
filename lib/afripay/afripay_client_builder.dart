import 'package:duma_health/afripay/afripay.dart';
import 'package:duma_health/afripay/afripay_client.dart';

class AfripayClientBuilder {
  String? _appId, _appSecret, _accessToken, _appReturnUrl;

  AfripayClientBuilder();

  static AfripayClientBuilder newBuilder() {
    return AfripayClientBuilder();
  }

  AfripayClientBuilder setAppReturnUrl(String appReturnUrl) {
    _appReturnUrl = appReturnUrl;
    return this;
  }

  AfripayClientBuilder setAppId(String appId) {
    _appId = appId;
    return this;
  }

  AfripayClientBuilder setAppSecret(String appSecret) {
    _appSecret = appSecret;
    return this;
  }

  AfripayClientBuilder setToken(String token) {
    _accessToken = token;
    return this;
  }

  AfripayClient? build() {
    Afripay.setAfripayClient(
      AfripayClient(
        appId: _appId,
        appSecret: _appSecret,
        appReturnUrl: _appReturnUrl,
        accessToken: _accessToken,
      ),
    );
    return Afripay.getAfripayClient();
  }
}
