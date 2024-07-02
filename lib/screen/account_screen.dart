import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import '../controllers/music_controller.dart';
import '../widget/recently_music_section.dart';

class AccountScreen extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController());
  final MusicController musicController = Get.put(MusicController());

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B29),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              const Text(
                'Library',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildLibraryItem(Icons.favorite, 'Favourite', '/favourite'),
              // _buildLibraryItem(Icons.download, 'Download', '/download'),
              const SizedBox(height: 16),
              const Text(
                'Recently Music',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (musicController.recentlyPlayedTracks.isEmpty) {
                  return const Center(
                    
                    child: Text(
                      'No Recently Muisc',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return buildRecentActivity(musicController: musicController, tracks: musicController.recentlyPlayedTracks);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryItem(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: () {
        Get.toNamed(route);
      },
    );
  }
}

