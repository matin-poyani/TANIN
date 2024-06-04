import 'package:flutter/foundation.dart';

class MusicTrack with ChangeNotifier {
  final int musicId;
  final String title;
  final String onvanMusic;
  final String description;
  String musicPoster;
  final int categoryId;
  final String timeErsal;
  final int bazdid;
  final List<DownloadMusic> downloadMusics;

  MusicTrack({
    required this.musicId,
    required this.title,
    required this.onvanMusic,
    required this.description,
    required this.musicPoster,
    required this.categoryId,
    required this.timeErsal,
    required this.bazdid,
    required this.downloadMusics,
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    return MusicTrack(
      musicId: json['MusicId'] ?? 0,
      title: json['Title'] ?? '',
      onvanMusic: json['OnvanMusic'] ?? '',
      description: json['Description'] ?? '',
      musicPoster: json['MusicPoster'] ?? '',
      categoryId: json['CategoryId'] ?? 0,
      timeErsal: json['TimeErsal'] ?? '',
      bazdid: json['Bazdid'] ?? 0,
      downloadMusics: (json['DownloadMusics'] as List<dynamic>?)
          ?.map((downloadJson) => DownloadMusic.fromJson(downloadJson))
          .toList() ??
          [],
    );
  }

  void updateMusicPoster(String newPoster) {
    musicPoster = newPoster;
    notifyListeners();
  }
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
