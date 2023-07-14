import 'package:flutter/material.dart';

class ReplayButton extends StatefulWidget{
  final Function() callback;

  const ReplayButton({super.key,required this.callback});
  @override
  ReplayButtonState createState() => ReplayButtonState();
}

class ReplayButtonState extends State<ReplayButton> with TickerProviderStateMixin{

  //replay rotate controller
  late AnimationController _replayController;
  late Animation<double> _animTurnReplay;

  // replay slide controller
  late AnimationController replaySlideController;
  late Animation<Offset> animReplayOffset;

  // replay fade controller
  late AnimationController replayFadeController;
  late Animation<double> animFadeReplay;


  @override
  void initState() {
    super.initState();
    ///replay turn
    _replayController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _replayController.reverse();
        }
      });
    _animTurnReplay = Tween<double>(begin: 0.0, end: -0.3).animate(
        CurvedAnimation(parent: _replayController, curve: Curves.easeInOut));

    ///replay slide
    replaySlideController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
        reverseDuration: const Duration(milliseconds: 300));
    final curveSlideReply = CurvedAnimation(
        curve: Curves.decelerate, parent: replaySlideController);
    animReplayOffset =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-2, 0))
            .animate(curveSlideReply);

    replaySlideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        replaySlideController.reverse();
      }
    });

    ///replay fade
    replayFadeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
        reverseDuration: const Duration(milliseconds: 300));
    final curveFadeReplay =
    CurvedAnimation(curve: Curves.linear, parent: replayFadeController);
    animFadeReplay = Tween<double>(begin: 0, end: 1).animate(curveFadeReplay);

    replayFadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        replayFadeController.reverse();
      }
    });

  }

  @override
  void dispose() {
    _replayController.dispose();
    replaySlideController.dispose();
    replayFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        widget.callback();
        _replayController.forward();
        replaySlideController.forward();
        replayFadeController.forward();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _animTurnReplay,
            child: Image.asset(
              'assets/images/replay.png',
              width: 100,
              height: 100,
              color: Colors.white,
            ),
          ),
          FadeTransition(
            opacity: animFadeReplay,
            child: SlideTransition(
              position: animReplayOffset,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "-10",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}