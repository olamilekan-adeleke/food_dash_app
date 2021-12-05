import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButtomModalService {
  static void showModal(Widget child) {
    Get.bottomSheet(
      child,
      isDismissible: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      enableDrag: false,
      backgroundColor: Colors.grey,
    );
  }
}
