import 'package:duma_health/models/country.dart';
import 'package:duma_health/services/api.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/functions.dart';
import 'package:duma_health/widgets/drop_countries.dart';
import 'package:duma_health/widgets/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final String nextPath;

  const SignUpPage({Key? key, required this.nextPath}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late Country _selectedCountry;
  List<Country> _countries = [];
  TextEditingController fController = TextEditingController();
  TextEditingController lController = TextEditingController();
  TextEditingController eController = TextEditingController();
  TextEditingController adController = TextEditingController();
  TextEditingController adController1 = TextEditingController();
  TextEditingController pController = TextEditingController();
  TextEditingController cPController = TextEditingController();
  TextEditingController phController = TextEditingController();
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
  void didChangeDependencies() {
    if(mounted){
      _countries = Provider.of<HomeProvider>(context).countries;
      _selectedCountry = _countries[0];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.8,
                      child: Text(
                        "Enregistrez-vous et profiter de nos services",
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 3,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FormHelper.textFieldForm(context,
                              label: 'First Name',
                              controller: fController,
                              onValidate: (value) {
                                if (value.toString().isEmpty) {
                                  return "Empty field";
                                }
                              }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: FormHelper.textFieldForm(context,
                              label: 'Last Name',
                              controller: lController,
                              onValidate: (value) {
                                if (value.toString().isEmpty) {
                                  return "Empty field";
                                }
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormHelper.emailFieldForm(
                      context,
                      controller: eController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FormHelper.passwordFieldForm(
                            context,
                            controller: pController,
                            isChecked: _hidePass,
                            isCheck: _toggle,
                            onValidate: (value) {
                              if (value.toString().isEmpty) {
                                return "Empty field";
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: FormHelper.passwordFieldForm(
                            context,
                            controller: cPController,
                            label: "Confirm Password",
                            isChecked: true,
                            onValidate: (value) {
                              if (value.toString() != pController.text) {
                                return "Passwords not compatible";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormHelper.phoneFieldForm(
                      context,
                      controller: phController,
                      label: "Phone Number",
                      hint: "72137785",
                      onValidate: (value) {
                        if (value.toString().isEmpty) {
                          return "Empty field";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CountryDropDownButton(
                      onChanged: (Country? value) {
                        setState(() {
                          _selectedCountry = value!;
                        });
                      },
                      selectedCountry: _selectedCountry,
                      countries: _countries,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormHelper.textFieldForm(
                      context,
                      controller: adController,
                      label: "Address1",
                      onValidate: (value) {
                        if (value.toString().isEmpty) {
                          return "Empty field";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormHelper.textFieldForm(
                      context,
                      controller: adController1,
                      label: "Address2",
                      onValidate: (value) {
                        if (value.toString().isEmpty) {
                          return "Empty field";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
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
                                _signUp();
                              },
                        child: _isSending
                            ? SpinKitThreeBounce(
                                color: Colors.white,
                                size: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize!,
                              )
                            : Text(
                                "Register".toUpperCase(),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _signUp() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      var data = {
        "firstname": fController.text,
        "lastname": lController.text,
        "phone": phController.text,
        "password": pController.text,
        "password_confirmation": pController.text,
        "email": eController.text,
        "address1": adController.text,
        "address2": adController1.text,
        "user_status_id": 1,
        "role_id": 1,
        "country_id": _selectedCountry.id,
      };
      Api.signUp(data).then((value) {
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
