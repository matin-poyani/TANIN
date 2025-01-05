import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
import '../models/color_style.dart';
import '../models/music_track.dart';
import '../screen/Player_Screen.dart';

class MiniPlayer extends StatelessWidget {
  final MusicController controller = Get.find<MusicController>();

  MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isMiniPlayerVisible.value ||
          controller.currentTrack.value == null) {
        return const SizedBox
            .shrink(); // Return an empty widget if mini player should not be visible
      }

      final track = controller.currentTrack.value;
      return GestureDetector(
        onTap: () {
          // هنگام تغییر به PlayerScreen، فقط ویجت‌ها را به‌روزرسانی کنیم
          Get.to(() => PlayerScreen(musicTrack: track!));
        },
        child: Container(
          color: const Color(0xFF333333), // Mini player background color
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (track != null) _buildTrackImage(track),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: _buildTrackDetails(),
                  ),
                  _buildPlayPauseButton(),
                  _buildCloseButton(),
                ],
              ),
              _buildSlider(context),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTrackImage(MusicTrack track) {
    return Image.network(
      track.musicPoster,
      height: 50,
      width: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 50,
          width: 50,
          color: Colors.grey,
          child: const Center(
            child: Text(
              'TANIN',
              style: TextStyle(color: Colors.yellow, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrackDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Text(
            controller.currentTitle.value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          );
        }),
        const SizedBox(height: 4.0),
        Obx(() {
          return Text(
            '${_formatDuration(controller.currentPosition.value)} / ${_formatDuration(controller.totalDuration.value)}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          );
        }),
      ],
    );
  }

  Widget _buildPlayPauseButton() {
    return Obx(() {
      return IconButton(
        icon: Icon(
          controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
        onPressed: controller.togglePlayPause,
      );
    });
  }

  Widget _buildCloseButton() {
    return IconButton(
      icon: const Icon(Icons.close, color: Colors.white),
      onPressed: () {
        controller.stopMusic();
      },
    );
  }

  Widget _buildSlider(BuildContext context) {
    return Obx(() {
      return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          thumbShape: SliderComponentShape.noThumb,
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: 1.0,
        ),
        child: Slider(
          min: 0.0,
          max: controller.totalDuration.value.inMilliseconds.toDouble(),
          activeColor: const ColorStyle().colorYellow,
          inactiveColor: Colors.grey,
          value: controller.currentPosition.value.inMilliseconds
              .toDouble()
              .clamp(0.0,
                  controller.totalDuration.value.inMilliseconds.toDouble()),
          onChanged: (value) {
            final position = Duration(milliseconds: value.toInt());
            controller.seekTo(position);
          },
        ),
      );
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
