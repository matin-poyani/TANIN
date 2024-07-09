import 'package:flutter/foundation.dart';
import 'package:tanin/models/download_music.dart';

class MusicTrack with ChangeNotifier {
  final int musicId;
  final String title;
  final String onvanMusic;
  final String description;
  String musicPoster;
  final String timeErsal;
  final int bazdid;
  final List<DownloadMusic> downloadMusics;
  bool downloaded;
  final int categoryId;
  final String categoryName;
  final String localPath;

  MusicTrack({
    required this.musicId,
    required this.title,
    required this.onvanMusic,
    required this.description,
    required this.musicPoster,
    required this.timeErsal,
    required this.bazdid,
    required this.downloadMusics,
    required this.categoryId,
    required this.categoryName,
    this.downloaded = false,
    required this.localPath,
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    return MusicTrack(
      musicId: json['MusicId'] ?? 0,
      title: json['Title'] ?? '',
      onvanMusic: json['OnvanMusic'] ?? '',
      description: json['Description'] ?? '',
      musicPoster: json['MusicPoster'] ?? '',
      timeErsal: json['TimeErsal'] ?? '',
      bazdid: json['Bazdid'] ?? 0,
      downloadMusics: (json['DownloadMusics'] as List<dynamic>?)
              ?.map((downloadJson) => DownloadMusic.fromJson(downloadJson))
              .toList() ??
          [],
      categoryId: json['CateId'] ?? 0,
      categoryName: json['Name'] ?? '',
      downloaded: json['downloaded'] ?? false,
      localPath: json['localPath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MusicId': musicId,
      'Title': title,
      'OnvanMusic': onvanMusic,
      'Description': description,
      'MusicPoster': musicPoster,
      'TimeErsal': timeErsal,
      'Bazdid': bazdid,
      'DownloadMusics': downloadMusics.map((e) => e.toJson()).toList(),
      'CateId': categoryId,
      'Name': categoryName,
      'downloaded': downloaded,
      'localPath': localPath,
    };
  }

  void updateMusicPoster(String newPoster) {
    musicPoster = newPoster;
    notifyListeners();
  }

  MusicTrack copyWith({
    int? musicId,
    String? title,
    String? onvanMusic,
    String? description,
    String? musicPoster,
    String? timeErsal,
    int? bazdid,
    List<DownloadMusic>? downloadMusics,
    bool? downloaded,
    int? categoryId,
    String? categoryName,
    String? localPath,
  }) {
    return MusicTrack(
      musicId: musicId ?? this.musicId,
      title: title ?? this.title,
      onvanMusic: onvanMusic ?? this.onvanMusic,
      description: description ?? this.description,
      musicPoster: musicPoster ?? this.musicPoster,
      timeErsal: timeErsal ?? this.timeErsal,
      bazdid: bazdid ?? this.bazdid,
      downloadMusics: downloadMusics ?? this.downloadMusics,
      downloaded: downloaded ?? this.downloaded,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      localPath: localPath ?? this.localPath,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MusicTrack) return false;
    return musicId == other.musicId;
  }

  @override
  int get hashCode => musicId.hashCode;
}

