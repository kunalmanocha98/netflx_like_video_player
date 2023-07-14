import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netflx_like_video_player/Components/controls_widget.dart';
import 'package:netflx_like_video_player/Components/loading_widget.dart';
import 'package:netflx_like_video_player/Constants/media_constants.dart';
import 'package:video_player/video_player.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
  // video player controller to controll the action on video
  late VideoPlayerController videoPlayerController;

  // used to show loader when loading for the first time
  bool loading = true;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.networkUrl(
      // Url for the media goes here
        Uri.parse(MediaConstants.tearsOfSteel),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: false,
        ));
    // set landscape mode on this page
    setLandscape();
    super.initState();
    // play video
    playVideo();
  }

  /// function plays the video
  void playVideo() async {
    videoPlayerController.initialize().then((value) {
      setState(() {
        loading = false;
      });
      videoPlayerController.play();
    });
  }

  /// function to set the mode to landscape
  void setLandscape() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  /// function to set back the orientation to default
  setAllOrientations() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  void dispose() async {
    await videoPlayerController.dispose();
    await setAllOrientations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(videoPlayerController),
          ControlsWidget(videoPlayerController: videoPlayerController),
          LoadingWidget(isLoading: loading),
        ],
      ),
    );
  }
}




