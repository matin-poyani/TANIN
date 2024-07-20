import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/music_track.dart';
import '../models/title_cleaner.dart';

class ApiSuggestions extends GetxController {
  var suggestions = <MusicTrack>[].obs;
  var searchResults = <MusicTrack>[].obs;
  var isLoading = false.obs;
  var textEditingController = TextEditingController().obs;

  final TitleCleaner titleCleaner = TitleCleaner();
  Rx<http.Client> httpClient = Rx<http.Client>(http.Client());

  @override
  void onClose() {
    httpClient.value.close();
    super.onClose();
  }

  Future<void> searchMusic(String query) async {
    isLoading(true);
    searchResults.clear();
    int page = 1;
    bool hasMoreData = true;

    print('Searching for music with query: $query');

    while (hasMoreData) {
      final response = await httpClient.value.get(Uri.parse('https://avvangmusic.ir/Api/Index?query=$query&page=$page'));
      print('API Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('API Response data: $data');

        if (data.isNotEmpty) {
          List<MusicTrack> tracks = data.map((e) {
            // پاکسازی تایتل‌ها با استفاده از TitleCleaner
            String cleanedTitle = titleCleaner.cleanTitle(e['Title']);
            e['Title'] = cleanedTitle;
            return MusicTrack.fromJson(e);
          }).toList();

          // فیلتر کردن نتایج بر اساس تطابق با query و معتبر بودن موزیک
          tracks = tracks.where((track) => track.title.split(' ').contains(query) && track.isValid()).toList();

          searchResults.addAll(tracks);
          print('Added ${tracks.length} tracks from page $page');
          page++;
        } else {
          hasMoreData = false;
          print('No more data to load');
        }
      } else {
        hasMoreData = false;
        print('Failed to load data, status code: ${response.statusCode}');
      }
    }
    print('Final searchResults length: ${searchResults.length}');
    isLoading(false);
  }

  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      print('Query is empty, cleared suggestions');
      return;
    }
    await searchMusic(query);
    suggestions.assignAll(searchResults);
    print('Assigned ${searchResults.length} search results to suggestions');
  }

  void stopSearching() {
    httpClient.value.close();
    httpClient = Rx<http.Client>(http.Client());
    isLoading(false);
  }
}
