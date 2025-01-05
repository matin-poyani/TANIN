import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
import '../models/color_style.dart';
import '../widget/explore_section.dart';

class ExploreScreen extends StatelessWidget {
  final MusicController musicController = Get.put(MusicController());

  ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ColorStyle().colorDark,
      body: const Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ExploreSection()),
            ],
          ),
        ],
      ),
    );
  }
}
