class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<CourseVideo> videos;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.videos,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      videos: (json['videos'] as List)
          .map((e) => CourseVideo.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'videos': videos.map((e) => e.toJson()).toList(),
    };
  }
}


class CourseVideo {
  final String id;
  final String title;
  final String videoUrl;

  CourseVideo({
    required this.id,
    required this.title,
    required this.videoUrl,
  });

  factory CourseVideo.fromJson(Map<String, dynamic> json) {
    return CourseVideo(
      id: json['id'],
      title: json['title'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'videoUrl': videoUrl,
    };
  }
}
