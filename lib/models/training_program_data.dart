class TrainingProgramModel {
  String? id;
  String? programName;
  String? target;
  String? trainings;
  String? numberOfRepsAndSets;
  String? weeklyFrequency;
  String? role;
  String? userId;
  TrainingProgramModel({
    this.id,
    this.programName = "",
    this.target = "",
    this.trainings,
    this.numberOfRepsAndSets,
    this.weeklyFrequency,
    this.role,
    this.userId,
  });

  TrainingProgramModel.fromJson(Map<dynamic, dynamic> map)
      : id = map['id'] ?? "",
        programName = map['programName'] ?? "",
        role = map['role'],
        target = map['target'] ?? "",
        trainings = map['trainings'] ?? "",
        numberOfRepsAndSets = map['numberOfRepsAndSets'],
        userId = map['userId'],
        weeklyFrequency = map['weeklyFrequency'];

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'programName': programName,
        'target': target,
        "role": role,
        "trainings": trainings,
        "numberOfRepsAndSets": numberOfRepsAndSets,
        "weeklyFrequency": weeklyFrequency,
        "userId": userId,
      };

  TrainingProgramModel copyWith({
    String? id,
    String? programName,
    String? target,
    String? trainings,
    String? numberOfRepsAndSets,
    String? weeklyFrequency,
    String? role,
    String? userId,
  }) {
    return TrainingProgramModel(
      id: id ?? this.id,
      programName: programName ?? this.programName,
      target: target ?? this.target,
      role: role ?? this.role,
      trainings: trainings ?? this.trainings,
      numberOfRepsAndSets: numberOfRepsAndSets ?? this.numberOfRepsAndSets,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      userId: userId ?? this.userId,
    );
  }
}
