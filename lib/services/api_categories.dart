import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tanin/services/api_tracks.dart';

class ApiCategories extends GetxController {
  final _categories = <String>[].obs;

  List<String> get categories => _categories.toList();

  final ApiTracks apiTracks = Get.put(ApiTracks());

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://avvangmusic.ir/Api/Categorys'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _categories.assignAll(data.map((e) => e['Name'].toString()).toList());
        await apiTracks.setCategories(_categories); // ارسال دسته‌ها به ApiTracks
        await apiTracks.fetchCategoryTracks(); // فراخوانی برای دریافت موزیک‌ها
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }
}
