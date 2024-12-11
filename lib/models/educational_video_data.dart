class EducationalVideoModel {
  String? id;
  String? title;
  String? videoLink;
  String? role;
  String? userId;
  EducationalVideoModel({
    this.id,
    this.title = "",
    this.videoLink = "",
    this.role,
    this.userId,
  });

  EducationalVideoModel.fromJson(Map<dynamic, dynamic> map)
      : id = map['id'] ?? "",
        title = map['title'] ?? "",
        role = map['role'],
        userId = map['userId'],
        videoLink = map['videoLink'] ?? '';

  Map<String, dynamic> toJson() => {
        'title': title,
        'videoLink': videoLink,
        if (id != null) 'id': id,
        "role": role,
        'userId': userId,
      };
}
