import 'package:flutter/material.dart';

import 'package:food_dash_app/cores/constants/color.dart';

import 'custom_circular_progress_indicator.dart';
import 'custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onTap,
    this.color,
    this.textColor,
    this.textSize,
    this.height,
    this.width,
    this.textFontWeight,
  })  : busy = false,
        iconData = null, iconSize = null,
        iconColor = null;

  const CustomButton.loading({
    this.onTap,
    this.color,
    this.height,
    this.width,
  })  : busy = true,
        iconData = null,
        text = null,
        textColor = null,
        textSize = null,
        textFontWeight = null, iconSize = null,
        iconColor = null;

  const CustomButton.smallSized({
    this.text,
    this.onTap,
    this.color,
    this.textColor,
    this.textSize,
    this.height,
    this.width,
    this.textFontWeight,
  })  : busy = false,
        iconData = null,
        iconSize = null,
        iconColor = null;

  const CustomButton.icon({
    required this.iconData,
    required this.height,
    required this.width,
    this.onTap,
    this.color,
    this.iconColor,
    this.iconSize,
  })  : busy = false,
        text = null,
        textColor = null,
        textSize = null,
        textFontWeight = null;

  final String? text;
  final IconData? iconData;
  final void Function()? onTap;
  final bool busy;
  final Color? color;
  final Color? textColor;
  final double? textSize;
  final double? height;
  final double? width;
  final FontWeight? textFontWeight;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (text == null) {
      child = Icon(
        iconData,
        color: iconColor ?? Colors.white,
        size: iconSize ?? 20.0,
      );
    } else {
      if (busy) {
        child = const Center(child: CustomCircularProgressIndicator());
      } else {
        child = CustomTextWidget(
          text: text ?? 'no text',
          textColor: textColor ?? Colors.white,
          fontSize: textSize,
          fontWeight: textFontWeight,
        );
      }
    }

    return SizedBox(
      height: height ?? 50.0,
      width: width ?? MediaQuery.of(context).size.width * 0.95,
      child: TextButton(
        onPressed: () => onTap!(),
        style: ButtonStyle(
          backgroundColor: busy
              ? MaterialStateProperty.all(kcGrey100)
              : MaterialStateProperty.all(color ?? kcPrimaryColor),
        ),
        child: child,
      ),
    );
  }
}
