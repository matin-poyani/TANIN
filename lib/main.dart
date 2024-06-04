import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screen/home_screen.dart';

void main() {
  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home:  HomeScreen(),
    );
  }
}
