import 'package:get/get.dart';
import 'package:tanin/services/api_tracks.dart';

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;
  final ApiTracks apiTracks = Get.find<ApiTracks>();

  void changeIndex(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      apiTracks.clearCache(); // پاک کردن کش هنگام تغییر صفحه
    }
  }
}

