import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../models/color_style.dart';
import '../models/music_track.dart';
import '../services/api_categories.dart';
import '../services/api_explore.dart';
import '../services/api_tracks.dart';

class MusicController extends GetxController {
  var musicTracks = <MusicTrack>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;
  final RxBool isFavorite = false.obs;
  final RxBool isShuffle = false.obs;
  final RxBool isRepeat = false.obs;
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<MusicTrack?> currentTrack = Rxn<MusicTrack?>();
  final RxBool isMiniPlayerVisible = true.obs;
  var recentlyPlayedTracks = <MusicTrack>[].obs;
  var favoriteTracks = <MusicTrack>[].obs;
  final ApiCategories apiCategories = Get.put(ApiCategories());
  final ApiTracks apiTracks = Get.put(ApiTracks());
  final ApiExplore apiExplore = Get.put(ApiExplore());
  var categories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMusicTracks();
    audioPlayer.positionStream.listen((position) {
      currentPosition.value = position;
    });
    audioPlayer.durationStream.listen((duration) {
      totalDuration.value = duration ?? Duration.zero;
    });
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _handleCompletion();
      }
    });
  }

  Future<void> fetchMusicTracks() async {
    try {
      await apiCategories.fetchCategories();
      var categoryTracks = apiTracks.categoryTracks; // استفاده از getter عمومی
      musicTracks.assignAll(categoryTracks.values.expand((tracks) => tracks).toList());
      categories.assignAll(apiCategories.categories);
    } catch (e) {
      print('Error fetching music tracks: $e');
    }
  }

  List<MusicTrack> getCategoryTracks(String category) {
    return apiTracks.getCategoryTracks(category);
  }

  Future<void> playMusic(String musicUrlLink, {bool seekToCurrentPosition = false}) async {
    try {
      print('Playing music: $musicUrlLink');
      if (currentTrack.value?.downloadMusics.first.musicUrlLink != musicUrlLink) {
        currentTrack.value = musicTracks.firstWhere((track) => track.downloadMusics.first.musicUrlLink == musicUrlLink);
      }
      if (!seekToCurrentPosition) {
        await audioPlayer.setUrl(musicUrlLink);
      } else {
        await audioPlayer.seek(currentPosition.value);
      }
      await audioPlayer.play();
      isPlaying.value = true;
      isMiniPlayerVisible.value = true;
      isFavorite.value = favoriteTracks.contains(currentTrack.value);
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  void pauseMusic() async {
    await audioPlayer.pause();
    isPlaying.value = false;
  }

  void stopMusic() async {
    await audioPlayer.stop();
    isPlaying.value = false;
    currentTrack.value = null;
    isMiniPlayerVisible.value = false;
  }

  void addRecentlyPlayedTrack(MusicTrack track) {
    if (!recentlyPlayedTracks.contains(track)) {
      recentlyPlayedTracks.add(track);
      if (recentlyPlayedTracks.length > 10) {
        recentlyPlayedTracks.removeAt(0);
      }
    }
  }

  void setCurrentTrack(MusicTrack track) {
    print('Setting current track: ${track.title}');
    currentTrack.value = track;
    playMusic(track.downloadMusics.first.musicUrlLink);
    addRecentlyPlayedTrack(track);
  }

  void togglePlayPause() async {
    if (isPlaying.value) {
      pauseMusic();
    } else {
      if (currentTrack.value != null) {
        await playMusic(currentTrack.value!.downloadMusics.first.musicUrlLink, seekToCurrentPosition: true);
      }
    }
  }

  void playNextTrack() async {
    final currentCategory = categories.firstWhereOrNull((category) {
      return apiTracks.getCategoryTracks(category).contains(currentTrack.value);
    });

    final tracks = currentCategory != null ? getCategoryTracks(currentCategory) : musicTracks;
    final currentIndex = tracks.indexOf(currentTrack.value!);
    final nextIndex = (currentIndex + 1) % tracks.length;  // Move to next track
    final nextTrack = tracks[nextIndex];

    setCurrentTrack(nextTrack);
    await playMusic(nextTrack.downloadMusics.first.musicUrlLink, seekToCurrentPosition: false);
  }

  void playPreviousTrack() async {
    final currentCategory = categories.firstWhereOrNull((category) {
      return apiTracks.getCategoryTracks(category).contains(currentTrack.value);
    });

    final tracks = currentCategory != null ? getCategoryTracks(currentCategory) : musicTracks;
    final currentIndex = tracks.indexOf(currentTrack.value!);
    final previousIndex = (currentIndex - 1 + tracks.length) % tracks.length;  // Move to previous track
    final previousTrack = tracks[previousIndex];

    setCurrentTrack(previousTrack);
    await playMusic(previousTrack.downloadMusics.first.musicUrlLink, seekToCurrentPosition: false);
  }

  void playRandomTrack() async {
    if (musicTracks.isEmpty) {
      print('No tracks available to play.');
      return;
    }
    final randomIndex = Random().nextInt(musicTracks.length);
    final randomTrack = musicTracks[randomIndex];
    print('Playing random track: ${randomTrack.title}');
    setCurrentTrack(randomTrack);
    await playMusic(randomTrack.downloadMusics.first.musicUrlLink, seekToCurrentPosition: false);
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
  }

  void _handleCompletion() {
    if (isRepeat.value) {
      print('Repeat mode is on, repeating the current track.');
      playMusic(currentTrack.value!.downloadMusics.first.musicUrlLink);
    } else if (isShuffle.value) {
      print('Shuffle mode is on, playing random track.');
      print('Total tracks available: ${musicTracks.length}');
      playRandomTrack();
    } else {
      print('Playing next track.');
      playNextTrack();
    }
  }

  void toggleRepeat() {
    isRepeat.value = !isRepeat.value;
    if (isRepeat.value) {
      isShuffle.value = false;
    }
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const ColorStyle().colorDark,
      colorText: Colors.yellowAccent,
      duration: const Duration(seconds: 3),
      messageText: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          isRepeat.value ? "این آهنگ تکرار خواهد شد" : "حالت تکرار غیرفعال شد",
          style: TextStyle(color: const ColorStyle().colorYellow, fontSize: 16),
        ),
      ),
    );
  }

  void toggleShuffle() {
    isShuffle.value = !isShuffle.value;
    if (isShuffle.value) {
      isRepeat.value = false;
    }
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const ColorStyle().colorDark,
      colorText: Colors.yellowAccent,
      duration: const Duration(seconds: 3),
      messageText: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          isShuffle.value ? "آهنگ‌ها به صورت تصادفی پخش می‌شوند" : "حالت تصادفی غیرفعال شد",
          style: TextStyle(color: const ColorStyle().colorYellow, fontSize: 16),
        ),
      ),
    );
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    apiTracks.clearCache();
    super.onClose();
  }
}
