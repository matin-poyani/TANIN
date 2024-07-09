import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
import '../models/color_style.dart';
import '../models/music_track.dart';
import '../services/api_service.dart';

class ExploreSection extends StatefulWidget {
  @override
  _ExploreSectionState createState() => _ExploreSectionState();
}

class _ExploreSectionState extends State<ExploreSection> {
  final MusicApiService musicApiService = Get.find<MusicApiService>();
  final MusicController musicController = Get.find<MusicController>();

  @override
  void initState() {
    super.initState();
    loadInitialData();
    // musicApiService.fetchCategories();  // به‌روزرسانی فهرست دسته‌بندی‌ها
  }

  void loadInitialData() async {
    try {
      List<MusicTrack> tracks = await musicApiService.fetchData();
      musicController.musicTracks.addAll(tracks);
    } catch (e) {
      print('Failed to fetch initial music tracks: $e');
    }
  }

  void loadMoreData() async {
    if (musicApiService.hasMore.value) {
      try {
        List<MusicTrack> tracks = await musicApiService.fetchData();
        if (tracks.isNotEmpty) {
          musicController.musicTracks.addAll(tracks);
        }
      } catch (e) {
        print('Failed to fetch more music tracks: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ColorStyle().colorDark,
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    loadMoreData();
                  }
                  return false;
                },
                child: musicController.musicTracks.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          children: musicController.musicTracks.map((track) {
                            return GestureDetector(
                              onTap: () {
                                musicController.setCurrentTrack(track);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(track.musicPoster),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.black54.withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          track.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ),
            Obx(() {
              if (musicApiService.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return Container();
              }
            }),
          ],
        );
      }),
    );
  }
}
