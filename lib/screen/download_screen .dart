import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanin/models/color_style.dart';
import '../controllers/downloadcontroller.dart';
import 'player_screen.dart';

class DownloadScreen extends StatelessWidget {
  final DownloadController downloadedMusicController =
  Get.put(DownloadController());
  final TextEditingController searchController = TextEditingController();

  DownloadScreen({super.key}) {
    _initialize();
  }

  void _initialize() async {
    await _loadDownloadedTracks();
    searchController.addListener(_filterTracks);
  }

  Future<void> _loadDownloadedTracks() async {
    downloadedMusicController.downloadedMusic.value =
    await downloadedMusicController.getAllDownloadedMusic();
    downloadedMusicController.filteredTracks.value =
        downloadedMusicController.downloadedMusic;
  }

  void _filterTracks() {
    String query = searchController.text.toLowerCase();
    downloadedMusicController.filterTracks(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloaded Music'),
        centerTitle: true,
        backgroundColor: const ColorStyle().colorDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const ColorStyle().colorDark,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildMusicList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search in downloads...',
        hintStyle: const TextStyle(color: Colors.yellow),
        filled: true,
        fillColor: const ColorStyle().colorBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.yellow),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildMusicList() {
    return Obx(() {
      final tracks = downloadedMusicController.filteredTracks;
      if (tracks.isEmpty) {
        return const Center(
          child: Text(
            'No downloaded music found.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }

      return ListView.builder(
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          final track = tracks[index];
          return _buildMusicTile(track, index);
        },
      );
    });
  }

  Widget _buildMusicTile(dynamic track, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => Get.to(() => PlayerScreen(musicTrack: track)),
        child: Row(
          children: [
            Text(
              '${index + 1}'.padLeft(2, '0'),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.grey,
                child: const Icon(Icons.music_note, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Downloaded',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildPopupMenu(track),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(dynamic track) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (String value) {
        switch (value) {
          case 'delete':
            downloadedMusicController.deleteMusic(track.title);
            Get.snackbar(
              'Deleted',
              '${track.title} removed successfully.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            break;
          case 'download':
          // Implement download functionality here
            Get.snackbar(
              'Download',
              'Downloading ${track.title}',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            break;
          case 'share':
          // Implement share functionality here
            Get.snackbar(
              'Share',
              'Sharing ${track.title}',
              backgroundColor: Colors.blue,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
          const PopupMenuItem<String>(
            value: 'download',
            child: Text('Download'),
          ),
          const PopupMenuItem<String>(
            value: 'share',
            child: Text('Share'),
          ),
        ];
      },
    );
  }
}
