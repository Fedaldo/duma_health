import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormHelper {
  static InputDecoration inputDecoration({
    String? hint,
    String? label,
  }) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  static Widget textFieldForm(
    BuildContext context, {
    String? label,
    required TextEditingController controller,
    String? hint,
    bool isMultipleLine = false,
    TextInputType inputType = TextInputType.text,
    required Function onValidate,
  }) {
    return TextFormField(
      controller: controller,
      decoration: inputDecoration(hint: hint, label: label),
      maxLines: !isMultipleLine ? 1 : null,
      keyboardType: isMultipleLine ? TextInputType.multiline : inputType,
      minLines: isMultipleLine ? 3 : null,
      validator: (value) {
        return onValidate(value);
      },
    );
  }

  static Widget phoneFieldForm(
    BuildContext context, {
    required TextEditingController controller,
    required Function onValidate,
    String? label,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: inputDecoration(hint: hint, label: label),
      validator: (value) {
        return onValidate(value);
      },
    );
  }

  static Widget emailFieldForm(
    BuildContext context, {
    required TextEditingController controller,
  }) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      validator: (value) {
        bool emailValid =
            RegExp(r"^[a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+")
                .hasMatch(value!);
        if (!emailValid) {
          return "Enter a valid email address";
        }
        return null;
      },
      decoration: inputDecoration(label: "Email"),
    );
  }

  static Widget passwordFieldForm(
    BuildContext context, {
    required TextEditingController controller,
    required bool isChecked,
    Function? isCheck,
    required Function onValidate,
    String label = "Password",
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isChecked,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        suffixIcon: Visibility(
          visible: isCheck != null,
          child: IconButton(
            onPressed: isCheck as void Function()?,
            icon: isChecked
                ? const Icon(
                    Icons.visibility_off,
                  )
                : const Icon(
                    Icons.visibility,
                  ),
          ),
        ),
      ),
      validator: (value) {
        return onValidate(value);
      },
    );
  }

  static Widget checkoutButton(
    BuildContext context, {
    required String buttonText,
    required Function onTap,
    required IconData icon,
  }) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        onPressed: () {
          onTap();
        },
        label: Text(
          buttonText.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 3,
          ),
        ),
        icon: Icon(icon),
      ),
    );
  }

  static Widget backButton(
    BuildContext context, {
    required Function onTap,
  }) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon(
        onPressed: () {
          onTap();
        },
        label: Text(
          "Back".toUpperCase(),
          style: const TextStyle(
            letterSpacing: 3,
          ),
        ),
        icon: const Icon(Icons.keyboard_arrow_left),
      ),
    );
  }
}
