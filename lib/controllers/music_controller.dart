import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/color_style.dart';
import '../models/music_track.dart';
import '../services/api_service.dart';

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
  var downloadedTracks = <MusicTrack>[].obs;
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;

  final MusicApiService musicApiService = Get.put(MusicApiService());
  var categories = <String>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchMusicTracks();
    _loadDownloadedTracks();
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
      await musicApiService.fetchCategories();
      var categoryTracks = musicApiService.categoryTracks;  // استفاده از getter عمومی
      musicTracks.assignAll(categoryTracks.values.expand((tracks) => tracks).toList());
      categories.assignAll(musicApiService.categories);
    } catch (e) {
      print('Error fetching music tracks: $e');
    }
  }

  List<MusicTrack> getCategoryTracks(String category) {
    return musicApiService.getCategoryTracks(category);
  }

  Future<void> _loadDownloadedTracks() async {
    final path = await _getDownloadPath();
    final directory = Directory(path);
    if (await directory.exists()) {
      final files = directory.listSync().where((item) => item.path.endsWith('.mp3')).toList();
      for (var file in files) {
        final musicId = file.uri.pathSegments.last.split('.').first;
        try {
          final track = musicTracks.firstWhere((track) => track.musicId == musicId);
          downloadedTracks.add(track);
        } catch (e) {
          print('Track with musicId $musicId not found in musicTracks');
        }
      }
    }
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

  Future<void> playDownloadedMusic(MusicTrack track) async {
    final path = await _getDownloadPath();
    final filePath = '$path/${track.musicId}.mp3';

    if (await File(filePath).exists()) {
      await audioPlayer.setFilePath(filePath);
      await audioPlayer.play();
      isPlaying.value = true;
      isMiniPlayerVisible.value = true;
      isFavorite.value = favoriteTracks.contains(track);
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

  void toggleFavorite(MusicTrack track) {
    if (favoriteTracks.contains(track)) {
      favoriteTracks.remove(track);
    } else {
      favoriteTracks.add(track);
    }
    isFavorite.value = favoriteTracks.contains(track);
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
    if (favoriteTracks.isEmpty) return;
    final currentIndex = favoriteTracks.indexOf(currentTrack.value);
    final nextIndex = (currentIndex + 1) % favoriteTracks.length;
    final nextTrack = favoriteTracks[nextIndex];
    setCurrentTrack(nextTrack);
    await playMusic(nextTrack.downloadMusics.first.musicUrlLink, seekToCurrentPosition: false);
  }

  void playPreviousTrack() async {
    if (favoriteTracks.isEmpty) return;
    final currentIndex = favoriteTracks.indexOf(currentTrack.value);
    final previousIndex = (currentIndex - 1 + favoriteTracks.length) % favoriteTracks.length;
    final previousTrack = favoriteTracks[previousIndex];
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
    Future.delayed(const Duration(seconds: 1), () {
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
           "",
            style: TextStyle(color: const ColorStyle().colorYellow, fontSize: 16),
          ),
        ),
      );
    });
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
    super.onClose();
  }

  Future<String> _getDownloadPath() async {
    final directory = await getExternalStorageDirectory();
    final downloadDir = Directory('${directory!.parent.parent.parent.parent.path}/Download/TANIN');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir.path;
  }

Future<void> downloadMusic(String musicUrlLink, String musicId) async {
  final path = await _getDownloadPath();
  final filePath = '$path/$musicId.mp3';
  final file = File(filePath);

  if (await file.exists()) {
    print('Music already downloaded.');
    return;
  }

  isDownloading.value = true;
  final client = http.Client();
  final request = http.Request('GET', Uri.parse(musicUrlLink));
  final response = await client.send(request);
  final totalBytes = response.contentLength ?? 0;
  final bytes = <int>[];
  int receivedBytes = 0;

  response.stream.listen(
    (List<int> newBytes) {
      bytes.addAll(newBytes);
      receivedBytes += newBytes.length;
      downloadProgress.value = receivedBytes / totalBytes;
    },
    onDone: () async {
      await file.writeAsBytes(bytes);
      isDownloading.value = false;
      downloadProgress.value = 0.0;
      downloadedTracks.add(musicTracks.firstWhere((track) => track.musicId == musicId));
      print('Music downloaded to: $filePath');
    },
    onError: (e) {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
      print('Download failed: $e');
    },
    cancelOnError: true,
  );
}

  Future<bool> isDownloaded(MusicTrack track) async {
    final path = await _getDownloadPath();
    final filePath = '$path/${track.musicId}.mp3';
    return File(filePath).exists();
  }
}

