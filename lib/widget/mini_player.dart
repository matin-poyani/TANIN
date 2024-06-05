import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
import '../models/color_style.dart';
import '../screen/Player_Screen.dart'; 

class MiniPlayer extends StatelessWidget {
  final MusicController controller = Get.find<MusicController>();

  MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isMiniPlayerVisible.value || controller.currentTrack.value == null) {
        return const SizedBox.shrink(); // Return an empty widget if mini player should not be visible
      }
      return GestureDetector(
        onTap: () {
          Get.to(() => PlayerScreen(musicTrack: controller.currentTrack.value!));
        },
        child: Container(
          color: const Color(0xFF333333), // Mini player background color
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(
                    controller.currentTrack.value!.musicPoster,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      controller.currentTrack.value!.title,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: controller.togglePlayPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      controller.stopMusic();
                    },
                  ),
                ],
              ),
              Obx(() {
                return SizedBox(
                  height: 1.0,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: SliderComponentShape.noThumb,
                      overlayShape: SliderComponentShape.noOverlay,
                      trackHeight: 1.0, // Adjust the track height if needed
                    ),
                    child: Slider(
                      min: 0.0,
                      max: controller.totalDuration.value.inMilliseconds.toDouble(),
                      activeColor: const ColorStyle().colorYellow,
                      inactiveColor: Colors.grey,
                      value: controller.currentPosition.value.inMilliseconds
                          .toDouble()
                          .clamp(0.0, controller.totalDuration.value.inMilliseconds.toDouble()),
                      onChanged: (value) {
                        final position = Duration(milliseconds: value.toInt());
                        controller.seekTo(position);
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
