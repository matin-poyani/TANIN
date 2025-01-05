import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
import '../models/color_style.dart';
import '../widget/category_section.dart';

class HomeScreen extends StatelessWidget {
  final MusicController musicController = Get.put(MusicController());

   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ColorStyle().colorDark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryAlbumsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
