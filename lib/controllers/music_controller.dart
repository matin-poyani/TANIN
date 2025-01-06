import 'dart:io';
import 'dart:math';
import 'package:audiotagger/audiotagger.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../models/music_track.dart';
import '../services/api_categories.dart';
import '../services/api_explore.dart';
import '../services/api_tracks.dart';
import '../widget/snackbar_helper.dart';

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
  var currentTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMusicTracks();
    audioPlayer.positionStream.listen((position) {
      currentPosition.value = position;
      update();
    });
    audioPlayer.durationStream.listen((duration) {
      totalDuration.value = duration ?? Duration.zero;
      update();
    });
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _handleCompletion();
      }
      update();
    });
  }

  Future<void> fetchMusicTracks() async {
    try {
      await apiCategories.fetchCategories();
      var categoryTracks = apiTracks.categoryTracks;
      musicTracks
          .assignAll(categoryTracks.values.expand((tracks) => tracks).toList());
      categories.assignAll(apiCategories.categories);
    } catch (e) {
      print('Error fetching music tracks: $e');
    }
  }

  List<MusicTrack> getCategoryTracks(String category) {
    return apiTracks.getCategoryTracks(category);
  }

  void updateTitle(String filePath) async {
    final tagger = Audiotagger();
    final tags = await tagger.readTags(path: filePath);
    if (tags != null && tags.title != null && tags.title!.isNotEmpty) {
      currentTitle.value = tags.title!;
    } else {
      currentTitle.value = currentTrack.value?.title ?? 'Unknown Title';
    }
    update(); // اطمینان حاصل کنید که ویجت‌ها به‌روزرسانی می‌شوند
  }

  Future<void> playMusic(String musicUrlLink,
      {bool seekToCurrentPosition = false, MusicTrack? track}) async {
    try {
      if (track != null) {
        currentTrack.value = track;
        if (!musicUrlLink.startsWith('file://')) {
          currentTitle.value =
              track.title; // به‌روزرسانی عنوان برای موزیک‌های آنلاین
        } else {
          updateTitle(track.downloadMusics.first
              .musicUrlLink); // به‌روزرسانی عنوان برای موزیک‌های آفلاین
        }
      }
      if (musicUrlLink.startsWith('file://')) {
        final localFilePath = musicUrlLink.replaceFirst('file://', '');
        if (!File(localFilePath).existsSync()) {
          print('File does not exist: $localFilePath');
          return;
        }
        await audioPlayer.setFilePath(localFilePath);
        updateTitle(localFilePath); // به‌روزرسانی عنوان برای فایل‌های آفلاین
      } else {
        await audioPlayer.setUrl(musicUrlLink);
      }
      if (seekToCurrentPosition && currentPosition.value != Duration.zero) {
        await audioPlayer.seek(currentPosition.value);
      }
      // مطمئن شوید که تنها در صورتی پخش شروع شود که موزیک در حال پخش نباشد
      if (!isPlaying.value) {
        await audioPlayer.play();
      }
      isPlaying.value = true;
      isMiniPlayerVisible.value = true;
      update();
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  void setCurrentTrack(MusicTrack track) {
    currentTrack.value = track;
    updateTitle(track.downloadMusics.first
        .musicUrlLink); // به‌روزرسانی عنوان برای موزیک‌های آفلاین
    playMusic(track.downloadMusics.first.musicUrlLink,
        track: track, seekToCurrentPosition: true);
    if (!recentlyPlayedTracks.contains(track)) {
      recentlyPlayedTracks.add(track);
    }
    update(); // اطمینان حاصل کنید که ویجت‌ها به‌روزرسانی می‌شوند
  }

  Future<void> _getTrackMetadata(String filePath) async {
    try {
      final tagger = Audiotagger();
      final metadata = await tagger.readTags(path: filePath);
      if (currentTrack.value != null) {
        currentTrack.value = currentTrack.value!.copyWith(
          title: metadata?.title ?? currentTrack.value!.title,
        );
        update();
      }
    } catch (e) {
      print('Error reading metadata: $e');
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
      if (recentlyPlayedTracks.length > 20) {
        recentlyPlayedTracks.removeAt(0);
      }
    }
  }

  void togglePlayPause() async {
    if (isPlaying.value) {
      await audioPlayer.pause();
      isPlaying.value = false;
    } else {
      if (currentTrack.value != null) {
        await audioPlayer.play();
        isPlaying.value = true;
      }
    }
    update();
  }

  void _handleCompletion() {
    if (isRepeat.value) {
      playMusic(currentTrack.value!.downloadMusics.first.musicUrlLink);
    } else if (isShuffle.value) {
      playRandomTrack();
    } else {
      playNextTrack();
    }
  }

  void playNextTrack() async {
    final currentCategory = categories.firstWhereOrNull((category) {
      return apiTracks.getCategoryTracks(category).contains(currentTrack.value);
    });

    final tracks = currentCategory != null
        ? getCategoryTracks(currentCategory)
        : musicTracks;
    final currentIndex = tracks.indexOf(currentTrack.value!);
    final nextIndex = (currentIndex + 1) % tracks.length; // Move to next track
    final nextTrack = tracks[nextIndex];

    setCurrentTrack(nextTrack);
    await playMusic(nextTrack.downloadMusics.first.musicUrlLink,
        seekToCurrentPosition: false);
  }

  void playPreviousTrack() async {
    final currentCategory = categories.firstWhereOrNull((category) {
      return apiTracks.getCategoryTracks(category).contains(currentTrack.value);
    });

    final tracks = currentCategory != null
        ? getCategoryTracks(currentCategory)
        : musicTracks;
    final currentIndex = tracks.indexOf(currentTrack.value!);
    final previousIndex = (currentIndex - 1 + tracks.length) %
        tracks.length; // Move to previous track
    final previousTrack = tracks[previousIndex];

    setCurrentTrack(previousTrack);
    await playMusic(previousTrack.downloadMusics.first.musicUrlLink,
        seekToCurrentPosition: false);
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
    await playMusic(randomTrack.downloadMusics.first.musicUrlLink,
        seekToCurrentPosition: false);
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
  }

  void toggleRepeat() {
    isRepeat.value = !isRepeat.value;
    if (isRepeat.value) {
      isShuffle.value = false;
    }
    SnackbarHelper.showSnackbar(
        isRepeat.value ? "این آهنگ تکرار خواهد شد" : "حالت تکرار غیرفعال شد");
  }

  void toggleShuffle() {
    isShuffle.value = !isShuffle.value;
    if (isShuffle.value) {
      isRepeat.value = false;
    }
    SnackbarHelper.showSnackbar(isShuffle.value
        ? "آهنگ‌ها به صورت تصادفی پخش می‌شوند"
        : "حالت تصادفی غیرفعال شد");
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    apiTracks.clearCache();
    super.onClose();
  }
}
