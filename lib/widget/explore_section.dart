import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanin/models/color_style.dart';
import '../controllers/music_controller.dart';
import '../services/api_service.dart';

class ExploreSection extends StatelessWidget {
  final MusicApiService musicApiService = Get.put(MusicApiService());
  final MusicController musicController = Get.put(MusicController());

  ExploreSection({super.key}) {
    musicApiService.fetchData().then((tracks) {
      musicController.musicTracks.assignAll(tracks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ColorStyle().colorDark,
      body: Obx(() {
        if (musicApiService.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
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
                        // colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.0), BlendMode.darken),
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
                              color: Colors.black54.withOpacity(0.5), // حاشیه نیمه شفاف
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
          );
        }
      }),
    );
  }
}
