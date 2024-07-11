import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/music_controller.dart';

class CategoryAlbumsSection extends StatelessWidget {
  final MusicController musicController = Get.put(MusicController());

  CategoryAlbumsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (musicController.categories.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await musicController.fetchMusicTracks(); // رفرش کردن دسته‌بندی‌ها و موزیک‌ها
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                musicController.apiTracks.hasMore.value) {
              musicController.apiTracks.fetchCategoryTracks();
            }
            return false;
          },
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: musicController.categories.length,
            itemBuilder: (context, index) {
              final category = musicController.categories[index];
              final tracks = musicController.getCategoryTracks(category);
        
              return Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(color: Colors.white, fontSize: 16,),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16),
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        viewportFraction: 0.5,
                      ),
                      items: tracks.map((track) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (track.downloadMusics.isNotEmpty) {
                                      musicController.setCurrentTrack(track);
                                      musicController.playMusic(track.downloadMusics.first.musicUrlLink);
                                    }
                                  },
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: track.musicPoster ?? 'Unknown Image Music',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => const Center(
                                          child: Icon(Icons.error, color: Colors.red),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.black54,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                track.title ?? 'Unknown Title',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
