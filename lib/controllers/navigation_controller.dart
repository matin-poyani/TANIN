import 'package:get/get.dart';
import '../services/api_service.dart';

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;
  final MusicApiService musicApiService = Get.find<MusicApiService>();

  void changeIndex(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      musicApiService.clearCache(); // پاک کردن کش هنگام تغییر صفحه
    }
  }
}

