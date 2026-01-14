import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class VerificationPinField extends StatelessWidget {
  final TextEditingController controller;
  final int pinLength;
  final void Function(String)? onDone;

  const VerificationPinField({
    super.key,
    required this.controller,
    required this.pinLength,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF154DBB);
    const Color emptyGrey = Color(0xFFE0E0E0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          const double spacing = 6.0;

          final double totalPadding = spacing * (pinLength - 1);
          final double boxWidth = (maxWidth - totalPadding) / pinLength - 8;
          final double boxHeight = 50.0;

          return PinCodeTextField(
            textDirection: TextDirection.rtl,
            autofocus: true,
            controller: controller,
            hideCharacter: false,
            highlight: true,
            highlightColor: mainBlue,
            defaultBorderColor: emptyGrey,
            hasTextBorderColor: mainBlue,
            pinBoxColor: Colors.white,
            maxLength: pinLength,
            pinBoxHeight: boxHeight,
            pinBoxWidth: boxWidth,
            pinBoxRadius: 12,
            pinBoxBorderWidth: 1.5,
            pinBoxOuterPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
            wrapAlignment: WrapAlignment.start,
            pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 180),
            keyboardType: TextInputType.number,
            pinTextStyle: const TextStyle(
              color: mainBlue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            onTextChanged: (text) {
              if (text.length == pinLength && onDone != null) {
                onDone!(text);
              }
            },
            onDone: onDone,
          );
        },
      ),
    );
  }
}
