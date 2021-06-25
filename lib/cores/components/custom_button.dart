import 'package:flutter/material.dart';

import 'package:food_dash_app/cores/constants/color.dart';

import 'custom_circular_progress_indicator.dart';
import 'custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    this.onTap,
    this.busy = false,
  });

  final String text;
  final void Function()? onTap;
  final bool busy;

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
              : MaterialStateProperty.all(kcPrimaryColor),
        ),
        child: busy
            ? const Center(child: CustomCircularProgressIndicator())
            : CustomTextWidget(
                text: text,
                textColor: Colors.white,
              ),
      ),
    );
  }
}
