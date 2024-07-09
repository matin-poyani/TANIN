import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';
import '../models/music_track.dart';
import '../models/color_style.dart';
import '../services/api_service.dart';
import 'Player_Screen.dart';

class SearchScreen extends StatelessWidget {
  final MusicApiService controller = Get.put(MusicApiService());
  final MusicController musicController = Get.put(MusicController()); // Ensure the MusicController is available
  final ColorStyle colorStyle = const ColorStyle();
  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorStyle.colorDark,
      appBar: AppBar(
        backgroundColor: colorStyle.colorBlack,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorStyle.colorYellow),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('TANIN', style: TextStyle(color: colorStyle.colorYellow)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller.textEditingController,
                      builder: (context, value, child) {
                        return TextField(
                          controller: controller.textEditingController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: value.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      controller.textEditingController.clear();
                                      controller.suggestions.clear();
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (query) {
                            controller.fetchSuggestions(query);
                          },
                          onSubmitted: (query) {
                            controller.searchMusic(query);
                          },
                        );
                      },
                    ),
                  ),
                  Obx(() {
                    if (controller.suggestions.isEmpty || controller.textEditingController.text.isEmpty) {
                      return Container();
                    }
                    return Container(
                      height: 200,
                      margin: const EdgeInsets.only(top: 48.0), // Adjust this value based on your TextField height
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      //TODO... No work....
                      // child: ListView.builder(
                      //   shrinkWrap: true,
                      //   itemCount: controller.suggestions.length,
                      //   itemBuilder: (context, index) {
                      //     String suggestion = controller.suggestions[index];
                      //     return ListTile(
                      //       title: Text(suggestion, style: const TextStyle(color: Colors.white)),
                      //       onTap: () async {
                      //         // Find the selected track from the list of music tracks
                      //         MusicTrack? selectedTrack = controller.musicTracks.firstWhereOrNull(
                      //           (track) => track.title == suggestion,
                      //         );
                      //         if (selectedTrack != null) {
                      //           musicController.setCurrentTrack(selectedTrack);
                      //           Get.to(() => PlayerScreen(musicTrack: selectedTrack));
                      //         }
                      //       },
                      //     );
                      //   },
                      // ),
                    );
                  }),
                ],
              ),
              // const SizedBox(height: 20),
              // const Text('History', style: TextStyle(color: Colors.white)),
              // const SizedBox(height: 10),
              // Obx(() => Wrap(
              //   spacing: 8.0,
              //   children: controller.searchHistory
              //       .map((item) => Chip(
              //             label: Text(item, style: TextStyle(color: colorStyle.colorYellow)),
              //             backgroundColor: Colors.grey[800],
              //           ))
              //       .toList(),
              // )),
              // const SizedBox(height: 20),
              // const Text('Top searching', style: TextStyle(color: Colors.white)),
              // const SizedBox(height: 10),
              // Obx(() => Wrap(
              //   spacing: 8.0,
              //   children: controller.topSearches
              //       .map((item) => Chip(
              //             label: Text(item, style: const TextStyle(color: Colors.black)),
              //             backgroundColor: colorStyle.colorYellow,
              //           ))
              //       .toList(),
              // )),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SizedBox(
                  height: 400, // Adjust this value based on the remaining space
                  child: ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      MusicTrack track = controller.searchResults[index];
                      return ListTile(
                        title: Text(track.title, style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          musicController.setCurrentTrack(track);
                          Get.to(() => PlayerScreen(musicTrack: track));
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
