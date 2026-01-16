import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class AppValidator {
  static String? nameValidate(value, context) {
    if (value.isEmpty || value.length < 3) {
      return AppTranslations.of(context)!.text("enterName");
    }
    return null;
  }

  static String? emailValidate(value, context) {
    if (value.isEmpty) {
      return AppTranslations.of(context)!.text("enterEmail");
    } else if (!value.contains('@')) {
      return AppTranslations.of(context)!.text("enterValidateEmail");
    }
    return null;
  }

  static Future<String?> phoneParsing({
    String? phone,
    String? countryCode,
    bool withCode = true,
  }) async {
    PhoneNumber phoneParsed;
    try {
      phoneParsed = PhoneNumber.parse(phone!, destinationCountry: IsoCode.KW);
      log(phoneParsed.isValid().toString());
      if (phoneParsed.isValid(type: PhoneNumberType.mobile)) {
        return withCode == true ? phoneParsed.international : phoneParsed.nsn;
      } else {
        log('Phone number is invalid');
        // throw 'Invalid Phone Number';
        return null;
      }
    } on PlatformException {
      rethrow;
    }
  }

  static String? txtValidate({value, context, title}) {
    if (value.isEmpty) {
      return "${AppTranslations.of(context)!.text('enter')} $title";
    }
    return null;
  }

  static String? passwordValidate(value, context) {
    if (value.isEmpty) {
      return AppTranslations.of(context)!.text("enterPass");
    } else if (value.length < 4) {
      return AppTranslations.of(context)!.text("passShortValidator");
    }
    return null;
  }
}
