import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/music_track.dart';
import '../models/title_cleaner.dart';

class ApiExplore extends GetxController {
  final _currentPage = 1.obs;
  final hasMore = true.obs;
  final isLoading = false.obs;
  final RxList<MusicTrack> _tracks = <MusicTrack>[].obs;

  List<MusicTrack> get tracks => _tracks.toList();

  @override
  void onInit() {
    super.onInit();
    fetchExploreTracks(isRefresh: true); // Fetch initial data
  }

  Future<void> fetchExploreTracks({bool isRefresh = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    if (isRefresh) {
      _currentPage.value = 1;
      _tracks.clear();
      hasMore.value = true;
    }

    try {
      final response = await http.get(Uri.parse('https://avvangmusic.ir/Api/Index?page=${_currentPage.value}'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<MusicTrack> fetchedTracks = data.map((e) {
          var track = MusicTrack.fromJson(e);
          track = track.copyWith(title: TitleCleaner().cleanTitle(track.title)); // پاکسازی تایتل
          return track;
        }).toList();

        if (fetchedTracks.isEmpty) {
          hasMore.value = false;
        } else {
          _tracks.addAll(fetchedTracks);
          _currentPage.value++;
        }
      } else {
        print('Failed to load data: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching tracks: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
