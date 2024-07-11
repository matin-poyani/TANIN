class DownloadMusic {

  final String musicUrlLink;  // اضافه شده


  DownloadMusic({
  
    required this.musicUrlLink,  

  });

  factory DownloadMusic.fromJson(Map<String, dynamic> json) {
    return DownloadMusic(
     
      musicUrlLink: json['MusicUrlLink'] ?? '',  

    );
  }

  Map<String, dynamic> toJson() {
    return {
    
      'MusicUrlLink': musicUrlLink, 
   
    };
  }

  DownloadMusic copyWith({

    String? musicUrlLink,  

  }) {
    return DownloadMusic(
      musicUrlLink: musicUrlLink ?? this.musicUrlLink, 
    );
  }
}
