import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanin/models/color_style.dart';
import '../controllers/music_controller.dart';
import '../screen/SelectedMusicPage.dart';

class MiniPlayer extends StatefulWidget {
  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final MusicController musicController = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!musicController.isMiniPlayerVisible.value || musicController.currentTrack.value == null) {
        return const SizedBox.shrink();
      }

      return InkWell(
        onTap: () {
          Get.to(() => SelectedMusicPage(musicTrack: musicController.currentTrack.value!));
        },
        child: Container(
          color: const ColorStyle().colorGray,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: musicController.currentTrack.value!.musicPoster,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        musicController.currentTrack.value!.title,
                        style: const TextStyle(color: Colors.white, fontSize: 14.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Obx(() => IconButton(
                      icon: Icon(
                        musicController.isPlaying.value ? Icons.pause : Icons.play_circle_filled,
                        color: const ColorStyle().colorYellow,
                        size: 32.0,
                      ),
                      onPressed: musicController.togglePlayPause,
                    )),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 20.0),
                      onPressed: () {
                        musicController.isMiniPlayerVisible.value = false;
                        musicController.stopMusic();
                      },
                    ),
                  ],
                ),
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
                      max: musicController.totalDuration.value.inMilliseconds.toDouble(),
                      activeColor: const ColorStyle().colorYellow,
                      inactiveColor: Colors.grey,
                      value: musicController.currentPosition.value.inMilliseconds.toDouble().clamp(0.0, musicController.totalDuration.value.inMilliseconds.toDouble()),
                      onChanged: (value) {
                        final position = Duration(milliseconds: value.toInt());
                        musicController.seekTo(position);
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
