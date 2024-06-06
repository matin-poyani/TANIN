import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
import '../models/color_style.dart';
import '../widget/custom_app_bar.dart';
import '../widget/mini_player.dart';
import '../widget/new_albums_section.dart';
import '../widget/geez_weekly_section.dart';

class HomeScreen extends StatelessWidget {
  final MusicController musicController = Get.put(MusicController());

   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ColorStyle().colorDark,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewAlbumsSection(),
                GeezWeeklySection(),
                NewAlbumsSection(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
