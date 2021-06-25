import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/constants/color.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      backgroundColor: kcGreyLight,
      color: kcGrey400,
    );
  }
}
