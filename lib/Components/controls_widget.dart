import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netflx_like_video_player/Components/Buttons/action_button.dart';
import 'package:netflx_like_video_player/Components/Buttons/replay_button.dart';
import 'package:netflx_like_video_player/Components/brightness_slider.dart';
import 'package:netflx_like_video_player/Components/Buttons/forward_button.dart';
import 'package:netflx_like_video_player/Utils/utility.dart';
import 'package:netflx_like_video_player/Components/video_slider.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';


/// This class defines the controls that are visible over the video
class ControlsWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const ControlsWidget({super.key, required this.videoPlayerController});

  @override
  ControlsWidgetState createState() => ControlsWidgetState();
}

class ControlsWidgetState extends State<ControlsWidget>
    with TickerProviderStateMixin {

  // use to show and hide the controls
  bool visible = true;
  // timer to hide the controls automatically
  Timer? timer;
  // uses to show buffer loader widget
  bool _isBuffering = false;

  //fade controller
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    ///fade
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    initializeTimer();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.videoPlayerController.addListener(checkVideo);
    });

  }

  /// function to listen to Video Controller events
  void checkVideo() {
    if(widget.videoPlayerController.value.isBuffering){
      setState(() {
        _isBuffering = true;
      });
    }else if(widget.videoPlayerController.value.isPlaying){
      setState(() {
        _isBuffering = false;
      });
    }
  }


  /// function to initialize and reset timer every time there is an action
  void initializeTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer(const Duration(seconds: 5), () {
      hidePanel();
    });
  }

  @override
  void dispose() {
    widget.videoPlayerController.removeListener(checkVideo);
    _controller.dispose();
    timer!.cancel();
    super.dispose();
  }

  /// function to hide or show controls on touch
  void hideOrShowControlPanel() {
    initializeTimer();
    visible ? hidePanel() : showPanel();
  }

  /// function to hide controls
  void hidePanel() {
    setState(() {
      visible = false;
    });
  }

  /// function to show controls
  void showPanel() {
    setState(() {
      visible = true;
    });
  }

  /// function to show toast message
  void showtoast(){
    Utility.showToast("No action yet");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideOrShowControlPanel();
      },
      child: Stack(
        children: [
          AnimatedContainer(
            color: visible ? Colors.black38 : Colors.transparent,
            duration: const Duration(milliseconds: 600),
          ),
          IgnorePointer(
            ignoring: !visible,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                onPressed: () {Navigator.pop(context);},
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ))),
                        const Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text(
                                "This is a netflix clone playing tears of steel",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {showtoast();},
                                icon: const Icon(
                                  Icons.cast,
                                  color: Colors.white,
                                ))),
                      ],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(alignment: Alignment.centerLeft,child: BrightnessSlider(onChanged: (){initializeTimer();},)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //     initializeTimer();
                          //     HapticFeedback.lightImpact();
                          //     _replayController.forward();
                          //     replaySlideController.forward();
                          //     replayFadeController.forward();
                          //     widget.videoPlayerController.seekTo(Duration(
                          //         seconds: widget.videoPlayerController.value.position
                          //             .inSeconds -
                          //             10));
                          //   },
                          //   child: Stack(
                          //     alignment: Alignment.center,
                          //     children: [
                          //       RotationTransition(
                          //         turns: _animTurnReplay,
                          //         child: Image.asset(
                          //           'assets/images/replay.png',
                          //           width: 100,
                          //           height: 100,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //       FadeTransition(
                          //         opacity: animFadeReplay,
                          //         child: SlideTransition(
                          //           position: animReplayOffset,
                          //           child: const Padding(
                          //             padding: EdgeInsets.all(8.0),
                          //             child: Text(
                          //               "-10",
                          //               style: TextStyle(
                          //                   fontSize: 16,
                          //                   fontWeight: FontWeight.bold,
                          //                   color: Colors.white),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          ReplayButton(callback: (){
                            initializeTimer();
                            HapticFeedback.lightImpact();
                            widget.videoPlayerController.seekTo(Duration(
                                seconds: widget.videoPlayerController.value.position
                                    .inSeconds -
                                    10));
                          }),
                          _isBuffering?
                          const CircularProgressIndicator()
                              :InkWell(
                            onTap: () {
                              initializeTimer();
                              if (widget.videoPlayerController.value.isPlaying) {
                                widget.videoPlayerController.pause();
                                _controller.forward();
                              } else {
                                widget.videoPlayerController.play();
                                _controller.reverse();
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.scale(
                                  scale: _animation.value,
                                  child: const Icon(
                                    Icons.pause,
                                    size: 60.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Transform.scale(
                                  scale: 1 - _animation.value,
                                  child: const Icon(Icons.play_arrow,
                                      size: 60.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     initializeTimer();
                          //     HapticFeedback.lightImpact();
                          //     _forwardController.forward();
                          //     forwardSlideController.forward();
                          //     forwardFadeController.forward();
                          //     widget.videoPlayerController.seekTo(Duration(
                          //         seconds: widget.videoPlayerController.value.position
                          //             .inSeconds +
                          //             10));
                          //   },
                          //   child: Stack(
                          //     alignment: Alignment.center,
                          //     children: [
                          //       RotationTransition(
                          //         turns: _animTurnForward,
                          //         child: Image.asset(
                          //           'assets/images/forward.png',
                          //           width: 100,
                          //           height: 100,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //       FadeTransition(
                          //         opacity: animFadeForward,
                          //         child: SlideTransition(
                          //           position: animForwardOffset,
                          //           child: const Padding(
                          //             padding: EdgeInsets.all(8.0),
                          //             child: Text(
                          //               "+10",
                          //               style: TextStyle(
                          //                   fontSize: 16,
                          //                   fontWeight: FontWeight.bold,
                          //                   color: Colors.white),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          ForwardButton(callback: (){
                            initializeTimer();
                            HapticFeedback.lightImpact();
                            widget.videoPlayerController.seekTo(Duration(
                                seconds: widget.videoPlayerController.value.position
                                    .inSeconds +
                                    10));
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: SmoothVideoProgress(
                              controller: widget.videoPlayerController,
                              builder: (BuildContext context, Duration progress,
                                  Duration duration, Widget? child) {
                                return VideoProgressSlider(
                                    position: progress,
                                    duration: duration,
                                    onChanged:(){ initializeTimer();},
                                    controller: widget.videoPlayerController,
                                    swatch: Theme.of(context).primaryColor);
                              },
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: widget.videoPlayerController,
                            builder: (context, VideoPlayerValue value, child) {
                              //Do Something with the value.
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  getVideoPosition(value),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ActionButton(
                              callback: (){showtoast();},
                              iconData: Icons.speed_outlined, title: 'Speed(1X)'),
                          ActionButton(
                              callback: (){showtoast();},
                              iconData: Icons.lock_open_outlined, title: 'Lock'),
                          ActionButton(
                              callback: (){showtoast();},
                              iconData: Icons.dynamic_feed_outlined,
                              title: 'Episodes'),
                          ActionButton(
                              callback: (){showtoast();},
                              iconData: Icons.subtitles_outlined,
                              title: 'Audio & Subtitles'),
                          ActionButton(
                              callback: (){showtoast();},
                              iconData: Icons.skip_next, title: 'Next Ep.')
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getVideoPosition(VideoPlayerValue value) {
    var position = Duration(milliseconds: value.position.inMilliseconds.round());
    var durationTime = DateTime.fromMillisecondsSinceEpoch(value.duration.inMilliseconds);
    var remainingTime = durationTime.subtract(position);
    var duration = Duration(milliseconds: remainingTime.millisecondsSinceEpoch);
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }
}