import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/music_controller.dart';
import '../services/api_service.dart';

class NewAlbumsSection extends StatelessWidget {
  final MusicApiService musicApiService = Get.put(MusicApiService());
  final MusicController musicController = Get.put(MusicController());

  NewAlbumsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch data when the widget is built
    musicApiService.fetchData();

    return Padding(
      padding: const EdgeInsets.only(left: 16.0,top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Albums',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (musicApiService.musicTracks.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
      
            return CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0, // Adjust the aspect ratio for the desired height and width
                enlargeCenterPage: true,
                viewportFraction: 0.5, // Make the items narrower
              ),
              items: musicApiService.musicTracks.map((track) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0), // Rounded corners
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
                                imageUrl: track.musicPoster,
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
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        track.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      // Text(
                                      //   track.title, // Assuming you have an artist field
                                      //   style: const TextStyle(
                                      //     color: Colors.white70,
                                      //     fontSize: 14,
                                      //   ),
                                      //   textAlign: TextAlign.center,
                                      // ),
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
            );
          }),
        ],
      ),
    );
  }
}
