import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/downloadcontroller.dart';
import '../controllers/music_controller.dart';
import '../models/music_track.dart';
import '../models/color_style.dart';

class PlayerScreen extends StatelessWidget {
  final MusicTrack musicTrack;
  final MusicController controller = Get.find();
  final DownloadController downloadController = Get.find();

  PlayerScreen({super.key, required this.musicTrack});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      final file =
          await downloadController.getDownloadedMusic(musicTrack.title);
      if (file != null) {
        // اطمینان حاصل کنید که موزیک‌های آفلاین به درستی پخش می‌شوند
        await controller.playMusic('file://${file.path}',
            seekToCurrentPosition: true);
        controller.updateTitle(
            file.path); // به‌روزرسانی عنوان و تصویر برای موزیک آفلاین
      } else if (musicTrack.downloadMusics.isNotEmpty) {
        await controller.playMusic(musicTrack.downloadMusics.first.musicUrlLink,
            seekToCurrentPosition: true);
        controller.updateTitle(musicTrack.downloadMusics.first
            .musicUrlLink); // به‌روزرسانی عنوان و تصویر برای موزیک آنلاین
      } else {
        Get.snackbar(
          "Error",
          "Music file not found",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      controller.update();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              _buildAlbumArt(),
              const SizedBox(height: 32),
              _buildTrackInfo(),
              const SizedBox(height: 20),
              _buildActionButtons(),
              const SizedBox(height: 20),
              _buildDownloadProgress(),
              const SizedBox(height: 32),
              _buildSlider(),
              _buildTimeInfo(),
              const SizedBox(height: 32),
              _buildPlaybackControls(),
              const SizedBox(height: 32),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAlbumArt() {
    final track = controller.currentTrack.value;
    return track?.musicPoster != null && track!.musicPoster.isNotEmpty
        ? Image.network(
            track.musicPoster,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _placeholderArt(),
          )
        : _placeholderArt();
  }

  Widget _placeholderArt() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.grey,
      child: const Center(
        child: Text(
          'TANIN',
          style: TextStyle(color: Colors.yellow, fontSize: 32),
        ),
      ),
    );
  }

  Widget _buildTrackInfo() {
    return Column(
      children: [
        Obx(() {
          return Text(
            controller.currentTitle.value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          );
        }),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDownloadButton(),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white, size: 32),
          onPressed: () {
            Get.snackbar(
              "Share",
              "Sharing ${musicTrack.title}",
              backgroundColor: Colors.blue,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDownloadButton() {
    final currentTrack = controller.currentTrack.value;
    final isDownloaded = currentTrack != null &&
        downloadController.isMusicDownloaded(currentTrack);
    return IconButton(
      icon: Icon(
        isDownloaded ? Icons.check_circle : Icons.download,
        color: isDownloaded ? Colors.green : Colors.white,
        size: 32,
      ),
      onPressed: () async {
        if (isDownloaded) {
          Get.snackbar(
            "Info",
            "Music already downloaded",
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          await downloadController.downloadMusic(
              currentTrack!, currentTrack.title);
        }
      },
    );
  }

  Widget _buildDownloadProgress() {
    final progress = downloadController.downloadProgress.value;
    if (progress > 0 && progress < 100) {
      return Column(
        children: [
          LinearProgressIndicator(value: progress / 100),
          const SizedBox(height: 10),
          Text(
            'Downloading: ${progress.toStringAsFixed(0)}%',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildSlider() {
    double currentPosition =
        controller.currentPosition.value.inSeconds.toDouble();
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
  }

  Widget _buildTimeInfo() {
    return Row(
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
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildShuffleButton(),
        _buildPreviousButton(),
        _buildPlayPauseButton(),
        _buildNextButton(),
        _buildRepeatButton(),
      ],
    );
  }

  Widget _buildShuffleButton() {
    return IconButton(
      icon: Icon(
        Icons.shuffle,
        color: controller.isShuffle.value
            ? const ColorStyle().colorYellow
            : const ColorStyle().colorWhite,
      ),
      onPressed: controller.toggleShuffle,
    );
  }

  Widget _buildPreviousButton() {
    return IconButton(
      icon: const Icon(Icons.skip_previous_outlined),
      color: const ColorStyle().colorWhite,
      iconSize: 32,
      onPressed: controller.playPreviousTrack,
    );
  }

  Widget _buildPlayPauseButton() {
    return IconButton(
      icon: Icon(
        controller.isPlaying.value
            ? Icons.pause_circle_filled
            : Icons.play_circle_filled,
        size: 64,
        color: const ColorStyle().colorYellow,
      ),
      onPressed: controller.togglePlayPause,
    );
  }

  Widget _buildNextButton() {
    return IconButton(
      icon: const Icon(Icons.skip_next_outlined),
      color: const ColorStyle().colorWhite,
      iconSize: 32,
      onPressed: controller.playNextTrack,
    );
  }

  Widget _buildRepeatButton() {
    return IconButton(
      icon: Icon(
        Icons.repeat,
        color: controller.isRepeat.value
            ? const ColorStyle().colorYellow
            : const ColorStyle().colorWhite,
      ),
      onPressed: controller.toggleRepeat,
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
