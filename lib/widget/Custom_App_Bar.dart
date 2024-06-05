import 'package:flutter/material.dart';
import 'package:tanin/screen/Search_screen.dart';
import '../models/color_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('TANIN', style: TextStyle(color: Colors.yellow,fontSize: 32)),
      iconTheme: const IconThemeData(color: Colors.yellow),
      backgroundColor: const ColorStyle().colorDark,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
