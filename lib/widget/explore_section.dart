import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanin/services/api_explore.dart';
import '../controllers/music_controller.dart';
import '../models/color_style.dart';

class ExploreSection extends StatefulWidget {
  @override
  _ExploreSectionState createState() => _ExploreSectionState();
}

class _ExploreSectionState extends State<ExploreSection> {
  final ApiExplore apiExplore = Get.find<ApiExplore>();
  final MusicController musicController = Get.find<MusicController>();

  @override
  void initState() {
    super.initState();
    apiExplore.fetchExploreTracks(isRefresh: true);
  }

  Future<void> refreshData() async {
    await apiExplore.fetchExploreTracks(isRefresh: true);
  }

  void loadMoreData() async {
    if (apiExplore.hasMore.value) {
      await apiExplore.fetchExploreTracks();
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
                child: RefreshIndicator(
                  onRefresh: refreshData,
                  child: apiExplore.tracks.isEmpty && apiExplore.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : apiExplore.tracks.isEmpty
                          ? Center(child: Text('No data available. Please try again later.', style: TextStyle(color: Colors.white)))
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                children: apiExplore.tracks.map((track) {
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
            ),
            Obx(() {
              if (apiExplore.isLoading.value && apiExplore.tracks.isNotEmpty) {
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
