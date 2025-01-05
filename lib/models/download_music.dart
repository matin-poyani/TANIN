class DownloadMusic {
  final String title;
  final String musicUrlLink;
  final String? localPath; // مسیر محلی برای فایل دانلود شده

  DownloadMusic({
    required this.title,
    required this.musicUrlLink,
    this.localPath,
  });

  /// بررسی اینکه آیا موسیقی به صورت آفلاین موجود است یا خیر
  bool get isOffline => localPath != null && localPath!.isNotEmpty;

  factory DownloadMusic.fromJson(Map<String, dynamic> json) {
    return DownloadMusic(
      title: json['Title'] ?? '',
      musicUrlLink: json['MusicUrlLink'] ?? '',
      localPath: json['LocalPath'],  // مسیر محلی برای پخش آفلاین
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'MusicUrlLink': musicUrlLink,
      'LocalPath': localPath,
    };
  }
}
