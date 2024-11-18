import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';

abstract class UValidator {
  static bool isEmpty(String? input) {
    return EString.isEmpty(input);
  }

  static bool isMail(String input) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return emailRegex.hasMatch(input);
  }

  static bool isEqual(String input, String compare) {
    return input == compare;
  }

  static bool isSecure(String input) {
    final passwordRegex =
        RegExp(r'(?=.*[A-Z])(?=.*[!@#.$&*-])(?=.*[0-9])(?=.*[a-z])');

    return passwordRegex.hasMatch(input);
  }

  static bool isNumber(String input) {
    return double.tryParse(input) != null;
  }

  static bool isHttpUrl(String input) {
    final urlRegex = RegExp(r'^https?://[^\s/$.?#].\S*$');
    return urlRegex.hasMatch(input);
  }
}

abstract class UValidatorPresets {
  static String? isNumberNullable(BuildContext context, String? input) {
    if (EString.isEmpty(input)) return null;

    if (!UValidator.isNumber(input!)) {
      return L10n.of(context).v_isNumber;
    }

    return null;
  }

  static String? isNotEmpty(BuildContext context, String? input) {
    if (EString.isEmpty(input)) {
      return L10n.of(context).v_isEmpty;
    }

    return null;
  }
}
