import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'controllers/music_controller.dart';
// import 'screen/download_screen.dart';
import 'screen/favorite_screen.dart';
import 'services/api_service.dart';
import 'widget/bottom_nav_bar.dart';

void main() {
 WidgetsFlutterBinding.ensureInitialized();
  Get.put(MusicApiService());
  Get.put(MusicController());
=======

import 'widget/bottom_nav_bar.dart';

void main() {
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: BottomNavBar(),
<<<<<<< HEAD
        initialRoute: '/',
      getPages: [
        GetPage(name: '/favourite', page: () => FavoriteScreen()),
        // GetPage(name: '/download', page: () => DownloadScreen()),
      ],
=======
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
    );
  }
}