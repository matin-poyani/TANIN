import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanin/models/color_style.dart';
import '../controllers/favorites_controller.dart';
import 'player_screen.dart';
import '../models/music_track.dart';

class FavoriteScreen extends StatelessWidget {
  // استفاده از Get.find برای پیدا کردن کنترلر و از Get.put برای ایجاد آن
  final FavoritesController controller = Get.put(FavoritesController()); 
  final TextEditingController searchController = TextEditingController();
  var filteredPlaylists = <MusicTrack>[].obs;

  FavoriteScreen({super.key}) {
    filteredPlaylists.value = controller.favorites;
    searchController.addListener(_filterPlaylists);
  }

  void _filterPlaylists() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredPlaylists.value = controller.favorites;
    } else {
      filteredPlaylists.value = controller.favorites.where((track) {
        return track.description.toLowerCase().contains(query) ||
               track.title.toLowerCase().contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist'),
        centerTitle: true,
        backgroundColor: const ColorStyle().colorDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const ColorStyle().colorDark,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
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
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: filteredPlaylists.length,
                itemBuilder: (context, index) {
                  final track = filteredPlaylists[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (track.downloaded && track.localPath != null) {
                          controller.playMusic(track.localPath!);
                          Get.to(() => PlayerScreen(musicTrack: track));
                        } else {
                          Get.snackbar(
                            'Error',
                            'Music not available for playback',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}'.padLeft(2, '0'),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(width: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              track.musicPoster,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track.description,
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  track.title,
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onSelected: (String value) async {
                              switch (value) {
                                case 'delete':
                                  controller.removeFavorite(track.musicId);
                                  filteredPlaylists.remove(track);
                                  Get.snackbar(
                                    'Deleted',
                                    '${track.title} removed ',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  break;
                                case 'download':
                                  controller.addFavoriteMusic(track);
                                  filteredPlaylists.refresh();
                                  Get.snackbar(
                                    'Download',
                                    'Downloading ${track.title}',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  break;
                                case 'share':
                                  Get.snackbar(
                                    'Share',
                                    'Sharing ${track.title}',
                                    backgroundColor: Colors.blue,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  break;
                                default:
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
