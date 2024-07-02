import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../models/music_track.dart';

class MusicController extends GetxController {
  var musicTracks = <MusicTrack>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;
  final RxBool isFavorite = false.obs;
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<MusicTrack?> currentTrack = Rx<MusicTrack?>(null);
  final RxBool isMiniPlayerVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    audioPlayer.positionStream.listen((position) {
      currentPosition.value = position;
    });
    audioPlayer.durationStream.listen((duration) {
      totalDuration.value = duration ?? Duration.zero;
    });
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }

  Future<void> playMusic(String musicUrlLink, {bool seekToCurrentPosition = false}) async {
    try {
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
    } catch (e) {
      // Handle error
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

  void setCurrentTrack(MusicTrack track) {
    currentTrack.value = track;
    playMusic(track.downloadMusics.first.musicUrlLink); // Play the new track
  }

  void togglePlayPause() async {
    if (isPlaying.value) {
      pauseMusic();
    } else {
      await playMusic(currentTrack.value!.downloadMusics.first.musicUrlLink, seekToCurrentPosition: true);
    }
  }

  void playNextTrack() async {
    final currentIndex = musicTracks.indexOf(currentTrack.value);
    final nextIndex = (currentIndex + 1) % musicTracks.length;
    final nextTrack = musicTracks[nextIndex];
    setCurrentTrack(nextTrack);
    await playMusic(nextTrack.downloadMusics.first.musicUrlLink, seekToCurrentPosition: false);
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
