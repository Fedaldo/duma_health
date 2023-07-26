import 'dart:convert';

import 'package:duma_health/models/country.dart';
import 'package:duma_health/models/shipping_details.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/screens/checkout/checkout.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/data_manager.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:duma_health/widgets/drop_countries.dart';
import 'package:duma_health/widgets/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingPage extends StatefulWidget {
  const ShippingPage({Key? key}) : super(key: key);

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  var userData = PreferenceUtils.getPreference(Constants.userData, null);
  User? user;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fnController = TextEditingController();
  TextEditingController lnController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController communeController = TextEditingController();
  TextEditingController qController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  late Country _selectedCountry;
  List<Country> _countries = [];

  @override
  void initState() {
    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
    super.initState();
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FormHelper.textFieldForm(
                          context,
                          label: "First Name",
                          controller: userData != null
                              ? fnController =
                                  TextEditingController(text: user!.firstName)
                              : fnController,
                          onValidate: (value) {
                            if (value.toString().isEmpty) {
                              return "Empty field";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: FormHelper.textFieldForm(
                          context,
                          label: 'Last Name',
                          controller: userData != null
                              ? lnController =
                                  TextEditingController(text: user!.lastName)
                              : lnController,
                          onValidate: (value) {
                            if (value.toString().isEmpty) {
                              return 'Empty field';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, bottom: 5),
                    child: Text(
                      "Country",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
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
                    label: 'City',
                    hint: 'Bujumbura',
                    controller: cityController,
                    onValidate: (value) {
                      if (value.toString().isEmpty) {
                        return 'Empty field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormHelper.textFieldForm(
                          context,
                          label: 'Commune',
                          hint: "Mukaza",
                          controller: communeController,
                          onValidate: (value) {
                            if (value.toString().isEmpty) {
                              return 'Empty field';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: FormHelper.textFieldForm(
                          context,
                          label: 'Quartier',
                          hint: "Rohero",
                          controller: qController,
                          onValidate: (value) {
                            if (value.toString().isEmpty) {
                              return 'Empty field';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FormHelper.textFieldForm(
              context,
              label: 'Notes (Optional)',
              hint: "Additional information for delivery",
              isMultipleLine: true,
              controller: noteController,
              onValidate: (value) {},
            ),
            const SizedBox(
              height: 50,
            ),
            FormHelper.checkoutButton(
              context,
              buttonText: 'Continue',
              onTap: () {
                if (validateAndSave()) {
                  DataManager.getInstance().shippingDetails = ShippingDetails(
                    firstName: fnController.text,
                    lastName: lnController.text,
                    country: "${_selectedCountry.id}",
                    city: cityController.text,
                    streetName: communeController.text,
                    note: noteController.text,
                  );
                  CheckoutPageState.controller.nextPage(
                      duration: const Duration(seconds: 1),
                      curve: Curves.bounceIn);
                }
              },
              icon: Icons.keyboard_arrow_right,
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    var form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
