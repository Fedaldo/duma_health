import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:duma_health/afripay/afripay_client.dart';
import 'package:duma_health/afripay/afripay_constants.dart';
import 'package:duma_health/afripay/afripay_data.dart';
import 'package:duma_health/afripay/afripay_pop_dialog.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AfripayScreen extends StatefulWidget {
  final AfripayData afripayData;

  const AfripayScreen({
    super.key,
    required this.afripayData,
  });

  @override
  AfripayScreenState createState() => AfripayScreenState();
}

class AfripayScreenState extends State<AfripayScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isLoading = false;
  int _progress = 0;
  var userData = PreferenceUtils.getPreference(Constants.userData, null);
  User? user;

  @override
  void initState() {
    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String url =
        "${AfripayConstants.clientAfripayUrl}?${widget.afripayData.collected}"
            .trim();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              key: const Key("afripay"),
              userAgent: AfripayConstants.afripayUserAgent,
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              javascriptChannels: <JavascriptChannel>{
                JavascriptChannel(
                    name: "Payment",
                    onMessageReceived: (JavascriptMessage message) {
                      _onPaymentSuccess();
                    }),
                JavascriptChannel(
                    name: "PaymentCancelled",
                    onMessageReceived: (JavascriptMessage message) {
                      Navigator.pop(context);
                      AfripayPopDialog.error(context, message: message.message);
                    }),
                JavascriptChannel(
                    name: "ActionRequired",
                    onMessageReceived: (JavascriptMessage message) {
                      AfripayPopDialog.info(context,
                          title: "Action Required", message: message.message);
                    }),
                JavascriptChannel(
                    name: "InfoError",
                    onMessageReceived: (JavascriptMessage message) {
                      AfripayPopDialog.error(context, message: message.message);
                    }),
                JavascriptChannel(
                    name: "RequestConfirmation",
                    onMessageReceived: (JavascriptMessage message) {
                      AfripayPopDialog.info(context,
                          title: "Request Confirmation",
                          message: message.message);
                    }),
                JavascriptChannel(
                    name: "UnsifficientAmount",
                    onMessageReceived: (JavascriptMessage message) {
                      AfripayPopDialog.error(context, message: message.message);
                    }),
                JavascriptChannel(
                    name: "Back",
                    onMessageReceived: (JavascriptMessage message) {
                      Navigator.pop(context);
                    }),
              },
              onPageStarted: (String url) {
                if (url != AfripayClient.backReturnUrl) {
                  setState(() {
                    _isLoading = true;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              onProgress: (int progress) {
                setState(() {
                  _progress = progress;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
              gestureNavigationEnabled: true,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            _isLoading
                ? Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SpinKitFadingCircle(
                          color: Theme.of(context).colorScheme.primary,
                          size: MediaQuery.of(context).size.height * 0.073,
                        ),
                        Text(
                          "$_progress %",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }

  void _onPaymentSuccess() {
    setState(() {
      _isLoading = true;
      _progress = 50;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
        _progress = 100;
      });
      AfripayPopDialog.success(context, reference: widget.afripayData.reference,
          onDone: () {
        Provider.of<OrderProvider>(context, listen: false)
            .getOrders(userId: "${user?.id}");
        context.go('/');
      });
    });
    /*Api.updateOrder(widget.afripayData.id).then((value) {
      setState(() {
        _isLoading = false;
        _progress = 100;
      });
      AfripayPopDialog.success(context, reference: widget.afripayData.reference,
          onDone: () {
        Provider.of<OrderProvider>(context, listen: false)
            .getOrders(userId: "${user?.id}");
        context.go('/');
      });
    });*/
  }
}
