// کلاس مدیریت پیشنهاد‌ها
import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/music_track.dart';

class ApiSuggestions extends GetxController {
  final _suggestions = <MusicTrack>[].obs;
  final _searchValue = ''.obs;
  final searchResults = <MusicTrack>[].obs;
  final TextEditingController textEditingController = TextEditingController();
  List<MusicTrack> get suggestions => _suggestions.toList();
  String get searchValue => _searchValue.value;
  final RxBool isLoading = false.obs;
  final RxList<MusicTrack> _musicTracks = <MusicTrack>[].obs;
  final RxMap<String, List<MusicTrack>> _categoryTracks = <String, List<MusicTrack>>{}.obs;
  Map<String, List<MusicTrack>> get categoryTracks => _categoryTracks;
  
  Timer? _debounce;

  Future<void> fetchSuggestions(String searchValue) async {
    _searchValue.value = searchValue;
    try {
      List<MusicTrack> allTracks = [..._musicTracks, ..._categoryTracks.values.expand((x) => x)];
      final List<MusicTrack> filteredTracks = allTracks
          .where((track) => track.title.toLowerCase().contains(searchValue.toLowerCase()))
          .toList();
      _suggestions.assignAll(filteredTracks); // ذخیره کردن نتیجه جستجو
    } catch (e) {
      _suggestions.clear();
      print('Error fetching suggestions: $e');
      rethrow;
    }
  }

  Future<void> searchMusic(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      isLoading(true);
      try {
        final responses = await Future.wait([
          http.get(Uri.parse('https://avvangmusic.ir/Api/Index?query=$query')),
          http.get(Uri.parse('https://avvangmusic.ir/Api/Index?page=&query=$query')),
          http.get(Uri.parse('https://avvangmusic.ir/Api/Categorys?query=$query')),
        ]);

        final allData = responses
            .where((response) => response.statusCode == 200)
            .expand((response) {
          List<dynamic> data = json.decode(response.body);
          return data;
        }).toList();

        List<MusicTrack> tracks = allData.map((e) => MusicTrack.fromJson(e)).toList();
        searchResults.value = tracks;
      } catch (e) {
        print('Error fetching search results: $e');
        rethrow;
      } finally {
        isLoading(false);
      }
    });
  }
}
