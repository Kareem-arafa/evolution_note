class ProgressModel {
  String? id;
  String? programId;
  num? precentage;
  String? userId;
  ProgressModel({
    this.id,
    this.programId = "",
    this.precentage,
    this.userId,
  });

  ProgressModel.fromJson(Map<dynamic, dynamic> map)
      : id = map['id'] ?? "",
        programId = map['programId'] ?? "",
        precentage = map['precentage'],
        userId = map['userId'];

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'programId': programId,
        "precentage": precentage,
        "userId": userId,
      };

  ProgressModel copyWith({
    String? id,
    String? programId,
    num? precentage,
    String? userId,
  }) {
    return ProgressModel(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      precentage: precentage ?? this.precentage,
      userId: userId ?? this.userId,
    );
  }
}
