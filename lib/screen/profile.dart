import 'package:flutter/material.dart';
import 'package:tanin/models/color_style.dart';
import 'package:tanin/widget/Custom_App_Bar.dart'; // Import your CustomAppBar widget
import '../widget/bottom_nav_bar.dart';
import '../widget/mini_player.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ColorStyle().colorDark,
      appBar: AppBar(
        actions: [
          CustomAppBar(), // Remove the 'const' keyword here
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
      bottomSheet: MiniPlayer(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 64, left: 16),
            child: Text(
              'Library',
              style: TextStyle(fontSize: 8, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                // Add onRowClick logic here
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.library_music_outlined,
                    size: 32.0,
                    color: const ColorStyle().colorWhite,
                  ),
                  const Text(
                    'My PlayList',
                    style: TextStyle(fontSize: 8, color: Colors.white),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 32.0,
                    color: const ColorStyle().colorWhite,
                  ),
                ],
              ),
            ),
          ),
          // Other children widgets...
        ],
      ),
    );
  }
}
