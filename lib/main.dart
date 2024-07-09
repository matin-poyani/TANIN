import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/music_controller.dart';
import 'screen/favorite_screen.dart';
import 'services/api_service.dart';
import 'widget/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MusicApiService());
  Get.put(MusicController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final MusicApiService musicApiService = Get.find<MusicApiService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      musicApiService.clearCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: BottomNavBar(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/favourite', page: () => FavoriteScreen()),
        // GetPage(name: '/download', page: () => DownloadScreen()),
      ],
    );
  }
}
