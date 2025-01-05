import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tanin/models/music_track.dart';

import '../widget/snackbar_helper.dart';

class DownloadController extends GetxController {
  var downloadedMusic = <MusicTrack>[].obs;
  var filteredTracks = <MusicTrack>[].obs; // Add filteredTracks for search functionality
  var downloadProgress = 0.0.obs; // Track the progress of the download
  var downloadSnackbarShowing = false.obs; // Manage snackbar state

  @override
  void onInit() {
    super.onInit();
    fetchDownloadedMusic(); // Load existing downloads
  }

  Future<void> fetchDownloadedMusic() async {
    downloadedMusic.value = await getAllDownloadedMusic();
  }

  Future<void> downloadMusic(MusicTrack downloadMusic, String filename) async {
    if (downloadSnackbarShowing.value) {
      return; // Avoid showing multiple snackbars
    }

    downloadSnackbarShowing.value = true;

    // Show initial snackbar for download
    SnackbarHelper.showSnackbar("دانلود ${downloadMusic.title}...",);

    try {
      final musicUrl = downloadMusic.downloadMusics.first.musicUrlLink;
      final response = await http.get(Uri.parse(musicUrl));

      if (response.statusCode == 200) {
        final musicDirectory = Directory('/storage/emulated/0/Music/TANIN');
        if (!await musicDirectory.exists()) {
          await musicDirectory.create(recursive: true);
        }

        final filePath = '${musicDirectory.path}/$filename.mp3';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Update the download state
        downloadedMusic.add(downloadMusic);
        downloadProgress.value = 100; // Download complete

        // Update snackbar to show success
        SnackbarHelper.showSnackbar("دانلود با موفقیت انجام شد...",);
      } else {
        SnackbarHelper.showSnackbar("دانلود انجام نشد...");
      }
    } catch (e) {
      SnackbarHelper.showSnackbar("خطا در دانلود موزیک: $e",);
    } finally {
      downloadSnackbarShowing.value = false; // Allow future snackbars
    }
  }

  Future<File?> getDownloadedMusic(String filename) async {
    final musicDirectory = Directory('/storage/emulated/0/Music/TANIN');
    final filePath = '${musicDirectory.path}/$filename.mp3';
    final file = File(filePath);
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Future<List<MusicTrack>> getAllDownloadedMusic() async {
    final musicDirectory = Directory('/storage/emulated/0/Music/TANIN');
    if (await musicDirectory.exists()) {
      final files = musicDirectory.listSync();
      return files.map((file) {
        final filename = file.uri.pathSegments.last;
        final title = filename.replaceAll('.mp3', '');
        return MusicTrack(
          title: title,
          musicId: 0, // Default or adjust based on your logic
          description: '', // Set appropriately if needed
          musicPoster: '', // Set appropriately if needed
          categoryId: 0, // Default or adjust based on your logic
          categoryName: '',
          downloadMusics: [], // Set appropriately if needed
        );
      }).toList();
    }
    return [];
  }

  Future<void> deleteMusic(String title) async {
    final musicDirectory = Directory('/storage/emulated/0/Music/TANIN');
    final filePath = '${musicDirectory.path}/$title.mp3';
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      downloadedMusic.removeWhere((track) => track.title == title); // Remove from list
    }
  }

  bool isMusicDownloaded(MusicTrack musicTrack) {
    return downloadedMusic.any((track) => track.title == musicTrack.title);
  }

  void filterTracks(String query) {
    if (query.isEmpty) {
      filteredTracks.value = downloadedMusic;
    } else {
      filteredTracks.value = downloadedMusic
          .where((track) => track.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
