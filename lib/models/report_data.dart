class ReportModel {
  String? id;
  String? title;
  String? description;
  String? traineeId;
  ReportModel({
    this.id,
    this.title = "",
    this.description = "",
    this.traineeId,
  });

  ReportModel.fromJson(Map<dynamic, dynamic> map)
      : id = map['id'] ?? "",
        title = map['title'] ?? "",
        traineeId = map['traineeId'],
        description = map['description'] ?? "";

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        "traineeId": traineeId,
      };
}
