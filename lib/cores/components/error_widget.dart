import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/retry_button.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.callback,
  }) : super(key: key);

  final String message;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomTextWidget(text: message),
        const SizedBox(height: 10.0),
        RetryButtonWidget(callback: () => callback!.call()),
      ],
    );
  }
}
