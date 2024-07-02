import 'package:get/get.dart';
import 'package:tanin/models/music_track.dart';
import '../services/api_service.dart';

class AccountController extends GetxController {
  var playlists = 22.obs;
  var followers = 360000.obs; // 360K followers
  var following = 56.obs;

  // Music tracks
  var musicTracks = <MusicTrack>[].obs;
  var isLoading = true.obs;

  final MusicApiService musicApiService = Get.put(MusicApiService());

  @override
  void onInit() {
    super.onInit();
    fetchMusicTracks();
  }

  void fetchMusicTracks() async {
    try {
      isLoading(true);
      var tracks = await musicApiService.fetchData(); // انتظار داریم لیستی از ترک‌ها را برگرداند
      musicTracks.assignAll(tracks);
    } finally {
      isLoading(false);
    }
  }

  void updateDetails(int newPlaylists, int newFollowers, int newFollowing) {
    playlists.value = newPlaylists;
    followers.value = newFollowers;
    following.value = newFollowing;
  }
}
