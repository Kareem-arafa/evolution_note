import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/models/educational_video_data.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final EducationalVideoModel? educationalVideo;

  const YouTubeVideoPlayer({super.key, this.educationalVideo});
  @override
  _YouTubeVideoPlayerState createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    String videoUrl = widget.educationalVideo!.videoLink!;
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.educationalVideo!.title}"),
        backgroundColor: AppTheme.primary,
        centerTitle: true,
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
        ),
        builder: (context, player) {
          return player;
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: YouTubeVideoPlayer()));
}
