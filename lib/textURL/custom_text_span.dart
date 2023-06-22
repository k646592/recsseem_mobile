import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomTextSpan {
  const CustomTextSpan({
    required this.text,
  });

  final String text;
  static double fontSize = 14;
  static Color color = const Color(0xff111111);

  static TextSpan urlTextSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launchUrl(Uri.parse(text));
        },
    );
  }

  static TextSpan normalTextSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}