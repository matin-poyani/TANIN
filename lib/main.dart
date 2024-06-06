import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/bottom_nav_bar.dart';

void main() {
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
    );
  }
}