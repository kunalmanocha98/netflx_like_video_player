import 'package:flutter/material.dart';

class ForwardButton extends StatefulWidget{
  final Function() callback;

  const ForwardButton({super.key,required this.callback});
  @override
  ForwardButtonState createState() => ForwardButtonState();
}

class ForwardButtonState extends State<ForwardButton> with TickerProviderStateMixin{
  // forward rotate controller
  late AnimationController _forwardController;
  late Animation<double> _animTurnForward;

  // forward slide controller
  late AnimationController forwardSlideController;
  late Animation<Offset> animForwardOffset;

  // forward fade controller
  late AnimationController forwardFadeController;
  late Animation<double> animFadeForward;


  @override
  void initState() {
    super.initState();
    ///forward turn
    _forwardController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _forwardController.reverse();
        }
      });
    _animTurnForward = Tween<double>(begin: 0.0, end: 0.3).animate(
        CurvedAnimation(parent: _forwardController, curve: Curves.easeInOut));

    ///forward slide
    forwardSlideController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
        reverseDuration: const Duration(milliseconds: 300));
    final curveSlideFwd = CurvedAnimation(
        curve: Curves.decelerate, parent: forwardSlideController);
    animForwardOffset =
        Tween<Offset>(begin: Offset.zero, end: const Offset(2, 0))
            .animate(curveSlideFwd);

    forwardSlideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        forwardSlideController.reverse();
      }
    });

    ///forward fade
    forwardFadeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
        reverseDuration: const Duration(milliseconds: 300));
    final curveFadeFwd =
    CurvedAnimation(curve: Curves.linear, parent: forwardFadeController);
    animFadeForward = Tween<double>(begin: 0, end: 1).animate(curveFadeFwd);

    forwardFadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        forwardFadeController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _forwardController.dispose();
    forwardSlideController.dispose();
    forwardFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callback();
        _forwardController.forward();
        forwardSlideController.forward();
        forwardFadeController.forward();

      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _animTurnForward,
            child: Image.asset(
              'assets/images/forward.png',
              width: 100,
              height: 100,
              color: Colors.white,
            ),
          ),
          FadeTransition(
            opacity: animFadeForward,
            child: SlideTransition(
              position: animForwardOffset,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "+10",
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