import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/educational_video_data.dart';
import 'package:evalution_note/ui/trainee/home/youtube_video_player_widget.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:flutter/material.dart';

class ViewVideosScreen extends StatefulWidget {
  static const String id = '/ViewVideosScreen';
  const ViewVideosScreen({super.key});

  @override
  State<ViewVideosScreen> createState() => _ViewVideosScreenState();
}

class _ViewVideosScreenState extends State<ViewVideosScreen> {
  bool _loading = false;
  List<EducationalVideoModel> educationalVideos = [];
  @override
  void didChangeDependencies() {
    setState(() {
      _loading = true;
    });
    RealtimeRepository().getEducationalVideos().then((videos) {
      setState(() {
        educationalVideos = videos;
        _loading = false;
        getUserEducationalVideos();
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(
              color: AppTheme.primary,
            ),
          )
        : getUserEducationalVideos().length > 0
            ? SizedBox(
                height: getUserEducationalVideos().length > 0 ? 130 : 0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: getUserEducationalVideos().map((e) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => YouTubeVideoPlayer(
                                      educationalVideo: e,
                                    )));
                      },
                      child: Card(
                        margin: const EdgeInsets.only(right: 16.0),
                        color: AppTheme.primary,
                        child: Container(
                          width: 120,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.video_library,
                                size: 30,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                e.title!,
                                style: Theme.of(context).textTheme.titleMedium!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            : Center(
                child: Text("لم يتم إضافة اي ڤيديوهات بعد"),
              );
  }

  List<EducationalVideoModel> getUserEducationalVideos() {
    List<EducationalVideoModel> userEducationalVideos = [];

    for (EducationalVideoModel video in educationalVideos) {
      for (var id in userModel?.educationalVideos ?? []) {
        if (video.id == id) {
          userEducationalVideos.add(video);
        }
      }
    }
    return userEducationalVideos;
  }
}
