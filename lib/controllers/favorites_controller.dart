import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import '../models/music_track.dart';

class FavoritesController extends GetxController {
  final player = AudioPlayer();
  var favorites = <MusicTrack>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> addFavorite(MusicTrack music) async {
    if (!favorites.any((element) => element.musicId == music.musicId)) {
      final localPath = await downloadMusic(music.musicPoster, '${music.musicId}.mp3');
      if (localPath.isNotEmpty) {
        final downloadedMusic = music.copyWith(localPath: localPath, downloaded: true);
        favorites.add(downloadedMusic);
        saveFavorites();
      } else {
        Get.snackbar(
          'Download Error',
          'Failed to download ${music.title}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void removeFavorite(int musicId) {
    favorites.removeWhere((music) => music.musicId == musicId);
    saveFavorites();
  }

  void saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(favorites.map((e) => e.toJson()).toList()));
  }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('favorites');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      favorites.value = jsonList.map((json) {
        final track = MusicTrack.fromJson(json);
        final file = File(track.localPath ?? '');
        if (file.existsSync()) {
          return track;
        } else {
          return track.copyWith(localPath: null, downloaded: false);
        }
      }).toList();
    }
  }

  Future<String> downloadMusic(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    if (!await file.exists()) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        throw Exception('Failed to download music');
      }
    } else {
      return filePath;
    }
  }

  void playMusic(String path) async {
    if (await File(path).exists()) {
      await player.setFilePath(path);
      player.play();
    } else {
      Get.snackbar(
        'Error',
        'Music file does not exist at the specified path',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void addFavoriteMusic(MusicTrack music) async {
    await addFavorite(music);
  }

  void toggleFavorite(MusicTrack track) {
    if (favorites.contains(track)) {
      favorites.remove(track);
    } else {
      favorites.add(track);
    }
    isFavorite.value = favorites.contains(track);
    saveFavorites();
  }

  final RxBool isFavorite = false.obs;
}
