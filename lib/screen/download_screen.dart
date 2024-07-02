import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
class DownloadScreen extends StatelessWidget {
  final MusicController musicController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دانلودها'),
      ),
      body: Obx(() {
        if (musicController.isDownloading.value) {
          return Center(
            child: CircularProgressIndicator(
              value: musicController.downloadProgress.value,
            ),
          );
        } else {
          return ListView.builder(
            itemCount: musicController.downloadedTracks.length,
            itemBuilder: (context, index) {
              final track = musicController.downloadedTracks[index];
              return ListTile(
                title: Text(track.title),
                subtitle: Text(track.title),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    // musicController.playDownloadedMusic(track);
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }
}
