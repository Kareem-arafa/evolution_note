import 'package:evalution_note/models/educational_video_data.dart';
import 'package:evalution_note/models/progress_data.dart';
import 'package:evalution_note/models/report_data.dart';
import 'package:evalution_note/models/training_program_data.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeRepository {
  const RealtimeRepository();

  Future<List<UserModel>> getUsers() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("users");
    var employeesSnapshot = await databaseReference.once();
    Map<dynamic, dynamic> map = employeesSnapshot.snapshot.value as Map<dynamic, dynamic>;
    List<UserModel> users = [];
    map.entries.forEach((e) {
      UserModel user = UserModel.fromJson(e.value);
      user.id = e.key;
      if (user.role != "admin") users.add(user);
    });

    return users;
  }

  Future<List<UserModel>> getTrainers() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("users");
    var employeesSnapshot = await databaseReference.orderByChild("role").equalTo("trainer").once();
    Map<dynamic, dynamic> map = employeesSnapshot.snapshot.value as Map<dynamic, dynamic>;
    List<UserModel> users = [];
    map.entries.forEach((e) {
      UserModel user = UserModel.fromJson(e.value);
      user.id = e.key;
      if (user.role != "admin") users.add(user);
    });

    return users;
  }

  Future<List<UserModel>> getTraineesForTrainer() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("users");
    var employeesSnapshot = await databaseReference.orderByChild("trainerId").equalTo("${userModel!.id}").once();
    Map<dynamic, dynamic> map = employeesSnapshot.snapshot.value as Map<dynamic, dynamic>;
    List<UserModel> users = [];
    map.entries.forEach((e) {
      UserModel user = UserModel.fromJson(e.value);
      user.id = e.key;
      if (user.role != "admin" && user.role != "trainer") users.add(user);
    });

    return users;
  }

  removeUser(UserModel user) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("users/${user.id}");
    databaseReference.remove();
  }

  Future<UserModel> editUserProfile(UserModel user) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("users/${user.id}");
    await databaseReference.update(user.toJson());
    var userSnapshot = await databaseReference.once();
    UserModel updatedUser = UserModel.fromJson(userSnapshot.snapshot.value as Map<dynamic, dynamic>);
    return updatedUser;
  }

  Future<TrainingProgramModel> addTrainingProgram(TrainingProgramModel program) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("trainingPrograms").push();
    await databaseReference.set(program.toJson());
    var dataSnapshot = await databaseReference.once();
    program = TrainingProgramModel.fromJson(dataSnapshot.snapshot.value as Map<dynamic, dynamic>);
    program.id = dataSnapshot.snapshot.key;

    return program;
  }

  Future<List<TrainingProgramModel>> getTrainingPrograms() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("trainingPrograms");
    var programsSnapshot = await databaseReference.once();
    List<TrainingProgramModel> trainingPrograms = [];
    if (programsSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> map = programsSnapshot.snapshot.value as Map<dynamic, dynamic>;
      map.entries.forEach((e) {
        TrainingProgramModel trainingProgram = TrainingProgramModel.fromJson(e.value);
        trainingProgram.id = e.key;
        trainingPrograms.add(trainingProgram);
      });
    }
    return trainingPrograms;
  }

  Future<List<TrainingProgramModel>> getTraineePrograms() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("trainingPrograms");
    var programsSnapshot = await databaseReference.orderByChild("traineeId").equalTo("${userModel!.id}").once();
    Map<dynamic, dynamic> map = programsSnapshot.snapshot.value as Map<dynamic, dynamic>;
    List<TrainingProgramModel> trainingPrograms = [];
    map.entries.forEach((e) {
      TrainingProgramModel trainingProgram = TrainingProgramModel.fromJson(e.value);
      trainingProgram.id = e.key;
      trainingPrograms.add(trainingProgram);
    });
    return trainingPrograms;
  }

  Future<List<TrainingProgramModel>> getTrainersPrograms() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("trainingPrograms");
    var programsSnapshot = await databaseReference.orderByChild("userId").equalTo("${userModel!.id}").once();
    Map<dynamic, dynamic> map = programsSnapshot.snapshot.value as Map<dynamic, dynamic>;
    List<TrainingProgramModel> trainingPrograms = [];
    map.entries.forEach((e) {
      TrainingProgramModel trainingProgram = TrainingProgramModel.fromJson(e.value);
      trainingProgram.id = e.key;
      trainingPrograms.add(trainingProgram);
    });
    return trainingPrograms;
  }

  removeTrainingProgram(TrainingProgramModel trainingProgram) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child("trainingPrograms/${trainingProgram.id}");
    databaseReference.remove();
  }

  Future<TrainingProgramModel> editTrainingProgram(TrainingProgramModel trainingProgram) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child("trainingPrograms/${trainingProgram.id}");
    await databaseReference.update(trainingProgram.toJson());
    var programSnapshot = await databaseReference.once();
    TrainingProgramModel updatedTrainingProgram =
        TrainingProgramModel.fromJson(programSnapshot.snapshot.value as Map<dynamic, dynamic>);
    return updatedTrainingProgram;
  }

  Future<EducationalVideoModel> addEducationalVideo(EducationalVideoModel video) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("educationalVideos").push();
    await databaseReference.set(video.toJson());
    var dataSnapshot = await databaseReference.once();
    video = EducationalVideoModel.fromJson(dataSnapshot.snapshot.value as Map<dynamic, dynamic>);
    video.id = dataSnapshot.snapshot.key;

    return video;
  }

  Future<List<EducationalVideoModel>> getEducationalVideos() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("educationalVideos");
    List<EducationalVideoModel> educationalVideos = [];
    var videosSnapshot = await databaseReference.once();
    if (videosSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> map = videosSnapshot.snapshot.value as Map<dynamic, dynamic>;
      map.entries.forEach((e) {
        EducationalVideoModel educationalVideoModel = EducationalVideoModel.fromJson(e.value);
        educationalVideoModel.id = e.key;
        educationalVideos.add(educationalVideoModel);
      });
    }
    return educationalVideos;
  }

  Future<List<EducationalVideoModel>> getTraineeEducationalVideos() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("educationalVideos");
    var videosSnapshot = await databaseReference.orderByChild("traineeId").equalTo("${userModel!.id}").once();
    Map<dynamic, dynamic> map = videosSnapshot.snapshot.value as Map<dynamic, dynamic>;
    List<EducationalVideoModel> educationalVideos = [];
    map.entries.forEach((e) {
      EducationalVideoModel educationalVideoModel = EducationalVideoModel.fromJson(e.value);
      educationalVideoModel.id = e.key;
      educationalVideos.add(educationalVideoModel);
    });
    return educationalVideos;
  }

  Future<List<EducationalVideoModel>> getTrainerEducationalVideos() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("educationalVideos");
    var videosSnapshot = await databaseReference.orderByChild("userId").equalTo("${userModel!.id}").once();
    Map<dynamic, dynamic> map = videosSnapshot.snapshot.value as Map<dynamic, dynamic>;
    List<EducationalVideoModel> educationalVideos = [];
    map.entries.forEach((e) {
      EducationalVideoModel educationalVideoModel = EducationalVideoModel.fromJson(e.value);
      educationalVideoModel.id = e.key;
      educationalVideos.add(educationalVideoModel);
    });
    return educationalVideos;
  }

  removeEducationalVideo(EducationalVideoModel video) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("educationalVideos/${video.id}");
    databaseReference.remove();
  }

  Future<EducationalVideoModel> editEducationalVideo(EducationalVideoModel video) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("educationalVideos/${video.id}");
    await databaseReference.update(video.toJson());
    var videoSnapshot = await databaseReference.once();
    EducationalVideoModel updatedEducationalVideo =
        EducationalVideoModel.fromJson(videoSnapshot.snapshot.value as Map<dynamic, dynamic>);
    return updatedEducationalVideo;
  }

  Future<ReportModel> addReport(ReportModel report) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("reports").push();
    await databaseReference.set(report.toJson());
    var dataSnapshot = await databaseReference.once();
    report = ReportModel.fromJson(dataSnapshot.snapshot.value as Map<dynamic, dynamic>);
    report.id = dataSnapshot.snapshot.key;

    return report;
  }

  Future<List<ReportModel>> getTraineeReports(UserModel trainee) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("reports");
    var reportsSnapshot = await databaseReference.orderByChild("traineeId").equalTo("${trainee.id}").once();
    Map<dynamic, dynamic> map = reportsSnapshot.snapshot.value as Map<dynamic, dynamic>;
    List<ReportModel> reports = [];
    map.entries.forEach((e) {
      ReportModel report = ReportModel.fromJson(e.value);
      report.id = e.key;
      reports.add(report);
    });
    return reports;
  }

  Future<ProgressModel> addProgress(ProgressModel progress) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("progress").push();
    await databaseReference.set(progress.toJson());
    var dataSnapshot = await databaseReference.once();
    progress = ProgressModel.fromJson(dataSnapshot.snapshot.value as Map<dynamic, dynamic>);
    progress.id = dataSnapshot.snapshot.key;

    return progress;
  }

  Future<List<ProgressModel>> getProgress(String userId, String programId) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("progress");
    var progressSnapshot = await databaseReference.orderByChild("programId").equalTo("$programId").once();
    List<ProgressModel> progress = [];
    if (progressSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> map = progressSnapshot.snapshot.value as Map<dynamic, dynamic>;
      map.entries.forEach((e) {
        ProgressModel newProgress = ProgressModel.fromJson(e.value);
        newProgress.id = e.key;
        if (newProgress.userId == userId) progress.add(newProgress);
      });
    }

    return progress;
  }

  Future<ProgressModel> editProgress(ProgressModel progress) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("progress/${progress.id}");
    await databaseReference.update(progress.toJson());
    var videoSnapshot = await databaseReference.once();
    ProgressModel updatedProgressModel = ProgressModel.fromJson(videoSnapshot.snapshot.value as Map<dynamic, dynamic>);
    return updatedProgressModel;
  }
}
