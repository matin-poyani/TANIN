import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:tanin/models/color_style.dart';
import 'package:tanin/screen/account_screen.dart';
import 'package:tanin/widget/mini_player.dart';
import '../controllers/navigation_controller.dart';
import '../screen/explore_screen.dart';
import '../screen/home_screen.dart';
import 'custom_app_bar.dart';
=======

import '../controllers/navigation_controller.dart';
import '../screen/explore_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/home_screen.dart';
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad

class BottomNavBar extends StatelessWidget {
  final BottomNavBarController navigationController = Get.put(BottomNavBarController());

   BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: const CustomAppBar(),
      bottomSheet: MiniPlayer(),
=======
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
      body: Obx(() {
        switch (navigationController.selectedIndex.value) {
          case 0:
            return HomeScreen();
          case 1:
<<<<<<< HEAD
            return  ExploreScreen();
          case 2:
            return  AccountScreen();
          default:
            return HomeScreen();
        }
        
=======
            return const ExploreScreen();
          case 2:
            return const ProfileScreen();
          default:
            return HomeScreen();
        }
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: navigationController.selectedIndex.value,
          onTap: (index) {
            navigationController.changeIndex(index);
          },
<<<<<<< HEAD
           selectedItemColor: const ColorStyle().colorYellow, // رنگ آیتم انتخابی
          unselectedItemColor: const ColorStyle().colorSilverGray, // رنگ آیتم‌های غیر انتخابی
=======
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
