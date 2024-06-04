// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../controllers/music_controller.dart';

// class RecentlyMusicSection extends StatelessWidget {
//   final MusicController musicController = Get.find();

//   RecentlyMusicSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0, top: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Recently Music',
//             style: TextStyle(color: Colors.white, fontSize: 16),
//           ),
//           const SizedBox(height: 10),
//           Obx(() {
//             return Column(
//               children: musicController.musicTracks.map((track) {
//                 return ListTile(
//                   leading: CachedNetworkImage(
//                     imageUrl: track.musicPoster,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                     errorWidget: (context, url, error) => const Center(
//                       child: Icon(Icons.error, color: Colors.red),
//                     ),
//                   ),
//                   title: Text(
//                     track.title,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   subtitle: Text(
//                     track.title,
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 );
//               }).toList(),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
