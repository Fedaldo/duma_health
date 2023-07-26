import 'package:duma_health/afripay/afripay_data.dart';
import 'package:duma_health/utils/enumeration.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AfripayClient {
  String? id, secret, token;
  static String? backReturnUrl;

  AfripayClient({appId, appSecret, accessToken, appReturnUrl}) {
    id = appId;
    secret = appSecret;
    token = accessToken;
    backReturnUrl = appReturnUrl;
  }

  String buildDataString(String? userData) {
    StringBuffer builder = StringBuffer();
    if (userData != null) builder.write(userData);
    builder.write(userData == null ? "" : "&" "comment=");
    builder.write("&client_token=${token!}");
    builder.write("&app_id=${id!}");
    builder.write("&app_secret=${secret!}");
    builder.write("&access_token=${token!}");
    builder.write("&return_url=${backReturnUrl!}");
    builder.write("&platform=ios");
    return builder.toString();
  }

  void launch(
    BuildContext context, {
    required String purchaseData,
    required String orderId,
  }) {
    AfripayData ad = AfripayData(
      id: orderId,
      reference: token!,
      collected: buildDataString(purchaseData),
    );
    context.push(
      '/${RouterPath.afripay}',
      extra: ad,
    );
  }
}
