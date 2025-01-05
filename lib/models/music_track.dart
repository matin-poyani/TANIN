import 'package:flutter/foundation.dart';
import 'package:tanin/models/download_music.dart';

class MusicTrack with ChangeNotifier {
  final int musicId;
  late final String title;
  final String description;
  String musicPoster;
  final List<DownloadMusic> downloadMusics;
  final int categoryId;
  final String categoryName;

  MusicTrack({
    required this.musicId,
    required this.title,
    required this.description,
    required this.musicPoster,
    required this.downloadMusics,
    required this.categoryId,
    required this.categoryName,
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    return MusicTrack(
      musicId: json['MusicId'] ?? 0,
      title: json['Title'] ?? '',
      description: json['Description'] ?? '',
      musicPoster: json['MusicPoster'] ?? '',
      downloadMusics: (json['DownloadMusics'] as List<dynamic>?)
              ?.map((downloadJson) => DownloadMusic.fromJson(downloadJson))
              .toList() ??
          [],
      categoryId: json['CateId'] ?? 0,
      categoryName: json['Name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MusicId': musicId,
      'Title': title,
      'Description': description,
      'MusicPoster': musicPoster,
      'DownloadMusics': downloadMusics.map((e) => e.toJson()).toList(),
      'CateId': categoryId,
      'Name': categoryName,
    };
  }

  void updateMusicPoster(String newPoster) {
    musicPoster = newPoster;
    notifyListeners();
  }

  MusicTrack copyWith({
    int? musicId,
    String? title,
    String? description,
    String? musicPoster,
    List<DownloadMusic>? downloadMusics,
    int? categoryId,
    String? categoryName,
  }) {
    return MusicTrack(
      musicId: musicId ?? this.musicId,
      title: title ?? this.title,
      description: description ?? this.description,
      musicPoster: musicPoster ?? this.musicPoster,
      downloadMusics: downloadMusics ?? this.downloadMusics,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  bool isValid() {
    return downloadMusics.any((dm) => dm.musicUrlLink.isNotEmpty);
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