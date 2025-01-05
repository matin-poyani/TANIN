import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanin/services/api_suggestions.dart';
import '../controllers/music_controller.dart';
import '../models/music_track.dart';
import '../models/color_style.dart';
import 'Player_Screen.dart';

class SearchScreen extends StatelessWidget {
  final ApiSuggestions controller = Get.put(ApiSuggestions());
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
            controller.stopSearching(); // متوقف کردن جستجو
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
                      valueListenable: controller.textEditingController.value,
                      builder: (context, value, child) {
                        return TextField(
                          controller: controller.textEditingController.value,
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
                                      controller.textEditingController.value.clear();
                                      controller.suggestions.clear();
                                      controller.stopSearching(); // متوقف کردن جستجو
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (query) {
                            controller.getSuggestions(query);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
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
