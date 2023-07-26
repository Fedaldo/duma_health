import 'package:duma_health/services/api.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/widgets/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignInPage extends StatefulWidget {
  final String nextPath;

  const SignInPage({Key? key, required this.nextPath}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController eController = TextEditingController();
  TextEditingController pController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool _isSending = false;
  String? error;
  bool _hidePass = true;

  _toggle() {
    setState(() {
      _hidePass = !_hidePass;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.6,
                child: Text(
                  "Connectez-vous et profiter de nos services",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              FormHelper.emailFieldForm(
                context,
                controller: eController,
              ),
              const SizedBox(
                height: 10,
              ),
              FormHelper.passwordFieldForm(context,
                  controller: pController,
                  isChecked: _hidePass,
                  isCheck: _toggle, onValidate: (value) {
                if (value.toString().isEmpty) {
                  return "Empty field";
                }
                return null;
              }),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    //MyRouter.pushPage(context, const ForgotPasswordPage());
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: error != null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: Colors.deepOrangeAccent,
                      ),
                      Text(
                        "$error",
                        style: const TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: width,
                child: ElevatedButton(
                  onPressed: _isSending
                      ? null
                      : () {
                          _logIn();
                        },
                  child: _isSending
                      ? SpinKitThreeBounce(
                          color: Colors.white,
                          size:
                              Theme.of(context).textTheme.bodyLarge!.fontSize!,
                        )
                      : Text(
                          "Log In".toUpperCase(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _logIn() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      var data = {
        "email": eController.text,
        "password": pController.text,
      };
      Api.login(data).then((value) {
        setState(() {
          _isSending = false;
        });
        if (value.error == null) {
          AppFunctions.authenticate(
            context,
            value: value,
            nextPath: widget.nextPath,
          );
        } else {
          setState(() {
            error = value.error;
          });
        }
      });
    }
  }
}
