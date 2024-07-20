import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tanin/models/title_cleaner.dart';
import '../models/music_track.dart';

class ApiTracks extends GetxController {
  final _currentPage = 1.obs;
  final hasMore = true.obs;
  final _categoryTracks = <String, List<MusicTrack>>{}.obs;
  final _currentCategory = ''.obs;
  final _cachedCategoryTracks = <String, List<MusicTrack>>{}.obs;
  final RxList<String> _categories = <String>[].obs;

  List<String> get categories => _categories.toList();
  String get currentCategory => _currentCategory.value;
  Map<String, List<MusicTrack>> get categoryTracks => _categoryTracks;

  List<MusicTrack> getCategoryTracks(String category) =>
      _categoryTracks[category]?.take(20).toList() ?? [];

  void setCategory(String category) {
    _currentCategory.value = category;
    _currentPage.value = 1;
    hasMore.value = true;
    _categoryTracks[category]?.clear();
    fetchCategoryTracks();
  }

  Future<void> setCategories(List<String> categories) async {
    _categories.assignAll(categories);
  }

  Future<List<MusicTrack>> fetchCategoryTracks() async {
    if (!hasMore.value) return [];

    try {
      List<Future<http.Response>> futures = _categories.asMap().entries.map((entry) {
        int index = entry.key;
        return http.get(Uri.parse('https://avvangmusic.ir/Api/musicCat/${index + 1}?page=${_currentPage.value}'));
      }).toList();

      final responses = await Future.wait(futures);

      List<MusicTrack> allTracks = [];
      for (var i = 0; i < responses.length; i++) {
        if (responses[i].statusCode == 200) {
          List<dynamic> data = json.decode(responses[i].body);
          List<MusicTrack> tracks = data.map((e) {
            var track = MusicTrack.fromJson(e);
            track = track.copyWith(title: TitleCleaner().cleanTitle(track.title)); // پاکسازی تایتل
            return track;
          }).toList();
          
          // فیلتر کردن ترک‌ها
          tracks = tracks.where((track) => track.isValid()).toList();

          if (tracks.isEmpty) {
            hasMore.value = false;
          } else {
            String category = _categories[i];
            _categoryTracks[category] = (_categoryTracks[category] ?? []) + tracks.take(10).toList(); // محدود کردن به 10 موزیک
            _cachedCategoryTracks[category] = tracks; // کش کردن داده‌های دریافت شده
            allTracks.addAll(tracks);
          }
        } else {
          throw Exception('Failed to load data for category ${_categories[i]}');
        }
      }

      _currentPage.value++;
      return allTracks;
    } catch (e) {
      print('Error fetching tracks for categories: $e');
      rethrow;
    }
  }

  void clearCache() {
    _cachedCategoryTracks.clear();
  }

  void reset() {
    _currentPage.value = 1;
    hasMore.value = true;
    _cachedCategoryTracks.clear();
  }
}
