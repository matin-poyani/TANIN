import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
import '../models/music_track.dart';
import '../models/color_style.dart';

class PlayerScreen extends StatelessWidget {
  final MusicTrack musicTrack;
  final MusicController controller = Get.put(MusicController());

  PlayerScreen({super.key, required this.musicTrack});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (musicTrack.downloadMusics.isNotEmpty) {
        await controller.playMusic(musicTrack.downloadMusics.first.musicUrlLink, seekToCurrentPosition: true);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Obx(() {
              final track = controller.currentTrack.value;
              return ClipOval(
                child: Image.network(
                  track?.musicPoster ?? '',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: 200,
                      color: Colors.grey,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 48,
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              final track = controller.currentTrack.value;
              return Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    track?.title ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => IconButton(
                  icon: Icon(
                    controller.isFavorite.value ? Icons.favorite : Icons.favorite_border_sharp,
                    color: controller.isFavorite.value ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    controller.toggleFavorite(musicTrack);
                  },
                )),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              double currentPosition = controller.currentPosition.value.inSeconds.toDouble();
              double maxPosition = controller.totalDuration.value.inSeconds.toDouble();
              return Slider(
                value: currentPosition,
                min: 0,
                max: maxPosition > 0 ? maxPosition : 1,
                activeColor: const ColorStyle().colorYellow,
                inactiveColor: Colors.grey,
                onChanged: (value) {
                  if (value >= 0 && value <= maxPosition) {
                    controller.seekTo(Duration(seconds: value.toInt()));
                  }
                },
              );
            }),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(controller.currentPosition.value),
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  _formatDuration(controller.totalDuration.value),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    color: controller.isShuffle.value ? const ColorStyle().colorYellow : const ColorStyle().colorWhite,
                  ),
                  onPressed: controller.toggleShuffle,
                )),
                IconButton(
                  icon: const Icon(Icons.skip_previous_outlined),
                  color: const ColorStyle().colorWhite,
                  iconSize: 32.0,
                  onPressed: () {
                    controller.playPreviousTrack();
                  },
                ),
                Obx(() => IconButton(
                  icon: Icon(
                    controller.isPlaying.value ? Icons.pause : Icons.play_circle_filled,
                    color: const ColorStyle().colorYellow,
                    size: 64.0,
                  ),
                  onPressed: controller.togglePlayPause,
                )),
                IconButton(
                  icon: const Icon(Icons.skip_next_outlined),
                  color: const ColorStyle().colorWhite,
                  iconSize: 32.0,
                  onPressed: () {
                    controller.playNextTrack();
                  },
                ),
                Obx(() => IconButton(
                  icon: Icon(
                    Icons.repeat_outlined,
                    color: controller.isRepeat.value ? const ColorStyle().colorYellow : const ColorStyle().colorWhite,
                  ),
                  onPressed: controller.toggleRepeat,
                )),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

