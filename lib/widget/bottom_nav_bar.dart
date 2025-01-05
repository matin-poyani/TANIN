import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanin/models/color_style.dart';
import 'package:tanin/screen/account_screen.dart';
import 'package:tanin/widget/mini_player.dart';
import '../controllers/navigation_controller.dart';
import '../screen/explore_screen.dart';
import '../screen/home_screen.dart';
import 'custom_app_bar.dart';

class BottomNavBar extends StatelessWidget {
  final BottomNavBarController navigationController = Get.put(BottomNavBarController());

  BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomSheet: MiniPlayer(),
      body: Obx(() {
        switch (navigationController.selectedIndex.value) {
          case 0:
            return HomeScreen();
          case 1:
            return ExploreScreen();
          case 2:
            return  AccountScreen();
          default:
            return HomeScreen();
        }
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: navigationController.selectedIndex.value,
          onTap: (index) {
            navigationController.changeIndex(index);
          },
          selectedItemColor: const ColorStyle().colorYellow,
          unselectedItemColor: const ColorStyle().colorSilverGray,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'اکسپلور',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'پروفایل',
            ),
          ],
        );
      }),
    );
  }
}
