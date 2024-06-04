import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/music_track.dart';

class MusicApiService extends GetxController {
  final RxList<MusicTrack> _musicTracks = <MusicTrack>[].obs;
  final RxList<String> _suggestions = <String>[].obs;
  final RxString _searchValue = ''.obs;
  final textEditingController = TextEditingController();
  var searchHistory = ["Fall out boy", "Good girl"].obs;
  var topSearches = ["Girl generation", "Imagine Dragons"].obs;
  var searchResults = <MusicTrack>[].obs;
  var isLoading = false.obs;

  List<MusicTrack> get musicTracks => _musicTracks.toList();
  List<String> get suggestions => _suggestions.toList();
  String get searchValue => _searchValue.value;

  Future<List<MusicTrack>> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://avvangmusic.ir/api/index'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<MusicTrack> tracks = data.map((e) => MusicTrack.fromJson(e)).toList();
        _musicTracks.assignAll(tracks);

        // Print URLs to console for verification
        tracks.forEach((track) => print(track.musicPoster));

        return tracks;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw e;
    }
  }


  Future<void> fetchSuggestions(String searchValue) async {
    _searchValue.value = searchValue; // Update search value
    try {
      await fetchData(); // Ensure data is fetched
      final List<String> titles = _musicTracks
          .where((track) => track.title.toLowerCase().contains(searchValue.toLowerCase()))
          .map((track) => track.title)
          .toList();
      _suggestions.assignAll(titles);
    } catch (e) {
      _suggestions.clear();
    }
  }

  void searchMusic(String query) async {
    isLoading(true);
    try {
      // Replace with your API endpoint
      final response = await http.get(Uri.parse('https://avvangmusic.ir/api/index?query=$query'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        searchResults.value = data.map((e) => MusicTrack.fromJson(e)).toList();
      } else {
        print('Failed to load search results');
      }
    } finally {
      isLoading(false);
    }
  }
}
