import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
import '../models/music_track.dart';
import '../models/color_style.dart';

class SelectedMusicPage extends StatelessWidget {
  final MusicTrack musicTrack;
  final MusicController controller = Get.put(MusicController());

  SelectedMusicPage({Key? key, required this.musicTrack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Automatically play the song from the current position
    Future.delayed(Duration.zero, () async {
      if (musicTrack.downloadMusics.isNotEmpty) {
        await controller.playMusic(musicTrack.downloadMusics.first.musicUrlLink, seekToCurrentPosition: true);
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Dark background color
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
            const SizedBox(height: 20), // Add top padding
            ClipOval(
              child: Image.network(
                musicTrack.musicPoster,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Show a placeholder image or an icon when the image fails to load
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
            ),
            const SizedBox(height: 20),
            Text(
              musicTrack.onvanMusic,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              musicTrack.title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  color: Colors.white,
                  onPressed: () {
                    // Handle share
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sort_sharp),
                  color: const ColorStyle().colorWhite,
                  onPressed: () {
                    // Handle sort
                  },
                ),
                Obx(() => IconButton(
                  icon: Icon(
                    controller.isFavorite.value ? Icons.favorite : Icons.favorite_border_sharp,
                    color: controller.isFavorite.value ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    controller.isFavorite.value = !controller.isFavorite.value;
                    // Add your favorite logic here
                  },
                )),
                IconButton(
                  icon: const Icon(Icons.download_rounded),
                  color: Colors.white,
                  onPressed: () {
                    // Handle download
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() => Slider(
              value: controller.currentPosition.value.inSeconds.toDouble(),
              min: 0,
              max: controller.totalDuration.value.inSeconds.toDouble(),
              activeColor: const ColorStyle().colorYellow,
              inactiveColor: Colors.grey,
              onChanged: (value) {
                controller.seekTo(Duration(seconds: value.toInt()));
              },
            )),
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
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  color: const ColorStyle().colorWhite,
                  onPressed: () {
                    // Handle shuffle
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous_outlined),
                  color: const ColorStyle().colorWhite,
                  iconSize: 32.0,
                  onPressed: () {
                    // Handle skip previous
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
                  onPressed: () {
                    // Handle skip next
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.repeat_outlined),
                  color: const ColorStyle().colorWhite,
                  onPressed: () {
                    // Handle repeat
                  },
                ),
              ],
            ),
            const SizedBox(height: 20), // Add bottom padding
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
