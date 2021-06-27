import 'package:flutter/material.dart';

import 'package:food_dash_app/cores/constants/color.dart';

import 'custom_circular_progress_indicator.dart';
import 'custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onTap,
    this.busy = false,
    this.color,
    this.textColor,
  });

  const CustomButton.loading({
    this.text,
    this.onTap,
    this.busy = false,
    this.color,
    this.textColor,
  });

  final String? text;
  final void Function()? onTap;
  final bool busy;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: MediaQuery.of(context).size.width * 0.95,
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
              ),
      ),
    );
  }
}
