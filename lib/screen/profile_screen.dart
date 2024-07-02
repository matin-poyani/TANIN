import 'package:flutter/material.dart';
import 'package:tanin/models/color_style.dart';
import '../widget/custom_app_bar.dart'; // Import your CustomAppBar widget
import '../widget/mini_player.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ColorStyle().colorDark,
      appBar: AppBar(
        actions: const [
          CustomAppBar(), // Remove the 'const' keyword here
        ],
      ),
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
      bottomSheet: MiniPlayer(),
    );
  }
}
