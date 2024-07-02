import 'package:flutter/foundation.dart';

class MusicTrack with ChangeNotifier {
  final int musicId;
  final String title;
  final String onvanMusic;
  final String description;
  String musicPoster;
<<<<<<< HEAD
  final String timeErsal;
  final int bazdid;
  final List<DownloadMusic> downloadMusics;
  bool downloaded = false; // New property
  
  // Category fields
  final int categoryId;
  final String categoryName;
=======
  final int categoryId;
  final String timeErsal;
  final int bazdid;
  final List<DownloadMusic> downloadMusics;
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad

  MusicTrack({
    required this.musicId,
    required this.title,
    required this.onvanMusic,
    required this.description,
    required this.musicPoster,
<<<<<<< HEAD
    required this.timeErsal,
    required this.bazdid,
    required this.downloadMusics,
      // Category fields
    required this.categoryId,
    required this.categoryName,
=======
    required this.categoryId,
    required this.timeErsal,
    required this.bazdid,
    required this.downloadMusics,
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    return MusicTrack(
      musicId: json['MusicId'] ?? 0,
      title: json['Title'] ?? '',
      onvanMusic: json['OnvanMusic'] ?? '',
      description: json['Description'] ?? '',
      musicPoster: json['MusicPoster'] ?? '',
<<<<<<< HEAD
=======
      categoryId: json['CategoryId'] ?? 0,
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
      timeErsal: json['TimeErsal'] ?? '',
      bazdid: json['Bazdid'] ?? 0,
      downloadMusics: (json['DownloadMusics'] as List<dynamic>?)
          ?.map((downloadJson) => DownloadMusic.fromJson(downloadJson))
<<<<<<< HEAD
          .toList() ?? [],
      categoryId: json['CateId'] ?? 0,
      categoryName: json['Name'] ?? '',
=======
          .toList() ??
          [],
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
    );
  }

  void updateMusicPoster(String newPoster) {
    musicPoster = newPoster;
    notifyListeners();
  }
<<<<<<< HEAD

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MusicTrack) return false;
    return musicId == other.musicId;
  }

  @override
  int get hashCode => musicId.hashCode;
=======
>>>>>>> 1bcdb9e345d239daeed9a727f023a8843cb8a9ad
}

class DownloadMusic {
  final int downloadId;
  final String musicUrlLink;
  final String onvanMusicDl;
  final int musicId;

  DownloadMusic({
    required this.downloadId,
    required this.musicUrlLink,
    required this.onvanMusicDl,
    required this.musicId,
  });

  factory DownloadMusic.fromJson(Map<String, dynamic> json) {
    return DownloadMusic(
      downloadId: json['DownloadId'],
      musicUrlLink: json['MusicUrlLink'],
      onvanMusicDl: json['OnvanMusicDl'],
      musicId: json['MusicId'],
    );
  }
}
