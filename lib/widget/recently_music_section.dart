import 'package:flutter/material.dart';
import '../controllers/music_controller.dart';
import '../models/music_track.dart';

// ignore: camel_case_types
class buildRecentActivity extends StatelessWidget {
  const buildRecentActivity({
    super.key,
    required this.musicController,
    required this.tracks,
  });

  final MusicController musicController;
  final List<MusicTrack> tracks;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // To prevent GridView from scrolling separately
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two items in each row
        childAspectRatio: 1, // Adjust as needed
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            musicController.setCurrentTrack(tracks[index]);
            musicController.playMusic(tracks[index].downloadMusics.first.musicUrlLink);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Image.network(
                  tracks[index].musicPoster,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      tracks[index].title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
