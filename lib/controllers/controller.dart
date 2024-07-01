import 'package:get/get.dart';

class SortingController extends GetxController {
  RxBool sortByTitle = true.obs; // Explicitly typed as boolean

  void toggleSortByTitle() {
    sortByTitle.toggle(); // Toggle the value of sortByTitle
  }
}
