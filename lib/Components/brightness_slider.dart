import 'dart:async';

import 'package:flutter/material.dart';
import 'package:screen_brightness_util/screen_brightness_util.dart';

class BrightnessSlider extends StatefulWidget{
  final void Function()? onChanged;
  const BrightnessSlider({super.key,this.onChanged});

  @override
  BrightnessState createState() => BrightnessState();
}

class BrightnessState extends State<BrightnessSlider>{
  final ScreenBrightnessUtil _screenBrightnessUtil = ScreenBrightnessUtil();
  late StreamSubscription ss;
  double _sliderBrightness = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ss = _screenBrightnessUtil.getBrightnessChangeStream().listen((event) {
        setState(() {
          _sliderBrightness = event;
        });
      });
      getBrightness();
    });
  }

  void getBrightness() async{
    ScreenBrightnessUtil().getBrightness().then((value) {
      setState(() {
        _sliderBrightness = value;
      });
    });
  }

  @override
  void dispose() {
    ss.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
              data: const SliderThemeData(
                  trackHeight: 1,
                  activeTrackColor: Colors.white,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  thumbColor: Colors.white,
                  inactiveTrackColor: Colors.white24,
              ),
              child: Slider(
                  value : _sliderBrightness,
                  onChanged : (double b){
                widget.onChanged!();
                _screenBrightnessUtil.setBrightness(b);
                setState((){
                  _sliderBrightness = b;
                });
              },
              ),
            ),
            Icon(_getIcon(),color: Colors.white,)
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    if(_sliderBrightness>=0&&_sliderBrightness<0.4){
      return Icons.brightness_low;
    }else if(_sliderBrightness>=0.4 && _sliderBrightness<0.75){
      return Icons.brightness_medium;
    }else{
      return Icons.brightness_high;
    }
  }

}