enum MediaType {
  movie,
}

class MediaModel {
  int id;
  int startYear;
  int? endYear;
  String mainPoster;
  String title;
  MediaType type;


  MediaModel({
    required this.id,
    required this.title,
    required this.type,
    required this.startYear,
    required this.endYear,
    required this.mainPoster,
  });

  factory MediaModel.fromJson(Map<String, Object?> json) {
    return MediaModel(
      id: json['id'] as int,
      title: json['title'] as String,
      type: MediaType.movie,
      startYear: json['start_year'] as int,
      endYear: json['end_year'] as int?,
      mainPoster: json['main_poster'] as String,
    );
  }
}