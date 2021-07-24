import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(child: CustomTextWidget(text: 'Notification Screem')),
    );
  }
}