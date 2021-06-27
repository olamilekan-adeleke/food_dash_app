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
  }) : busy = false;

  const CustomButton.loading({
    this.text,
    this.onTap,
    this.color,
    this.textColor,
    this.textSize,
    this.height,
    this.width,
    this.textFontWeight,
  }) : busy = true;

  const CustomButton.smallSized({
    this.text,
    this.onTap,
    this.color,
    this.textColor,
    this.textSize,
    this.height,
    this.width,
    this.textFontWeight,
  }) : busy = false;

  final String? text;
  final void Function()? onTap;
  final bool busy;
  final Color? color;
  final Color? textColor;
  final double? textSize;
  final double? height;
  final double? width;
  final FontWeight? textFontWeight;

  @override
  Widget build(BuildContext context) {
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
        child: busy
            ? const Center(child: CustomCircularProgressIndicator())
            : CustomTextWidget(
                text: text ?? 'no text',
                textColor: textColor ?? Colors.white,
                fontSize: textSize,
                fontWeight: textFontWeight,
              ),
      ),
    );
  }
}
