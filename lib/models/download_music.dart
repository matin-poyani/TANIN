class DownloadMusic {
  final int downloadId;
  final String musicUrlLink;  // اضافه شده
  final String onvanMusicDl;
  final int musicId;
  final String? localPath;
  final String? musicPoster;  // اضافه شده

  DownloadMusic({
    required this.downloadId,
    required this.musicUrlLink,  // اضافه شده
    required this.onvanMusicDl,
    required this.musicId,
    this.localPath,
    this.musicPoster,  // اضافه شده
  });

  factory DownloadMusic.fromJson(Map<String, dynamic> json) {
    return DownloadMusic(
      downloadId: json['DownloadId'],
      musicUrlLink: json['MusicUrlLink'] ?? '',  // اضافه شده
      onvanMusicDl: json['OnvanMusicDl'],
      musicId: json['MusicId'],
      localPath: json['localPath'],
      musicPoster: json['MusicPoster'],  // اضافه شده
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DownloadId': downloadId,
      'MusicUrlLink': musicUrlLink,  // اضافه شده
      'OnvanMusicDl': onvanMusicDl,
      'MusicId': musicId,
      'localPath': localPath,
      'MusicPoster': musicPoster,  // اضافه شده
    };
  }

  DownloadMusic copyWith({
    int? downloadId,
    String? musicUrlLink,  // اضافه شده
    String? onvanMusicDl,
    int? musicId,
    String? localPath,
    String? musicPoster,  // اضافه شده
  }) {
    return DownloadMusic(
      downloadId: downloadId ?? this.downloadId,
      musicUrlLink: musicUrlLink ?? this.musicUrlLink,  // اضافه شده
      onvanMusicDl: onvanMusicDl ?? this.onvanMusicDl,
      musicId: musicId ?? this.musicId,
      localPath: localPath ?? this.localPath,
      musicPoster: musicPoster ?? this.musicPoster,  // اضافه شده
    );
  }
}
