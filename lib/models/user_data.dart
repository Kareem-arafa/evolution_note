class UserModel {
  String? id;
  String? userName;
  String? password;
  String? email;
  String? role;
  String? roleAr;
  String? bio;
  String? trainerId;
  List<String>? trainingPrograms = [];
  List<String>? educationalVideos = [];

  UserModel({
    this.id,
    this.userName = "",
    this.email = "",
    this.role = '',
    this.password,
    this.roleAr,
    this.bio,
    this.trainerId,
    this.trainingPrograms,
    this.educationalVideos,
  });

  UserModel.fromJson(Map<dynamic, dynamic> map)
      : id = map['id'] ?? "",
        userName = map['userName'] ?? "",
        email = map['email'] ?? "",
        roleAr = map['roleAr'] ?? '',
        role = map['role'] ?? '',
        trainerId = map['trainerId'],
        trainingPrograms = map['trainingPrograms'] != null ? List.of(map['trainingPrograms'].cast<String>()) : null,
        educationalVideos = map['educationalVideos'] != null ? List.of(map['educationalVideos'].cast<String>()) : null,
        bio = map['bio'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        'role': role,
        if (id != null) 'id': id,
        if (roleAr != null) 'roleAr': roleAr,
        if (bio != null) 'bio': bio,
        if (trainerId != null) "trainerId": trainerId,
        if (trainingPrograms != null) "trainingPrograms": trainingPrograms ?? [],
        if (educationalVideos != null) "educationalVideos": educationalVideos ?? [],
      };
  UserModel copyWith({
    String? id,
    String? userName,
    String? password,
    String? email,
    String? role,
    String? roleAr,
    String? bio,
    String? trainerId,
    List<String>? trainingPrograms,
    List<String>? educationalVideos,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      email: email ?? this.email,
      role: role ?? this.role,
      roleAr: roleAr ?? this.roleAr,
      bio: bio ?? this.bio,
      trainerId: trainerId ?? this.trainerId,
      trainingPrograms: trainingPrograms ?? this.trainingPrograms,
      educationalVideos: educationalVideos ?? this.educationalVideos,
    );
  }
}
