import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/color_style.dart';

class SnackbarHelper {
  static void showSnackbar(String message) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const ColorStyle().colorDark,
      colorText: Colors.yellowAccent,
      duration: const Duration(seconds: 6),
      messageText: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          message,
          style: TextStyle(color: const ColorStyle().colorYellow, fontSize: 16),
        ),
      ),
    );
  }
}
