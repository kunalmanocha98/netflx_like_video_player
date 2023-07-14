import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProgressSlider extends StatelessWidget {
  const VideoProgressSlider({super.key,
    required this.position,
    required this.duration,
    required this.controller,
    required this.swatch,
    required this.onChanged,
  });

  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;
  final Color swatch;
  final Function() onChanged;

  @override
  Widget build(BuildContext context) {
    final max = duration.inMilliseconds.toDouble();
    final value = position.inMilliseconds.clamp(0, max).toDouble();
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Row(
        children: [
          Expanded(
            child: SliderTheme(
              data: const SliderThemeData(
                  trackShape: RectangularSliderTrackShape(),
                  trackHeight: 2,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11)),
              child: SizedBox(
                height: 50,
                child: Slider(
                  min: 0,
                  max: max,
                  value: value,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    onChanged();
                    controller.seekTo(Duration(milliseconds: value.toInt()));
                  },
                  onChangeStart: (_) => controller.pause(),
                  onChangeEnd: (_) => controller.play(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
