import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    super.key,
    required this.sliderStrokeWidth,
  });

  final BehaviorSubject<double> sliderStrokeWidth;

  @override
  Widget build(BuildContext context) {
    return Slider(
        inactiveColor: Colors.black,
        activeColor: Colors.black,
        overlayColor: MaterialStateColor.resolveWith(
                (states) => Colors.black),
        min: 1,
        max: 20,
        value: sliderStrokeWidth.stream.value,
        onChanged: (value) {
          sliderStrokeWidth.value = value;
        });
  }
}