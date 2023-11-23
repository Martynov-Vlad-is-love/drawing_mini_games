import 'dart:math';

import 'package:drawing_mini_games/model/draw_model.dart';
import 'package:drawing_mini_games/view/widget/color_picker_button.dart';
import 'package:drawing_mini_games/view/widget/custom_slider.dart';
import 'package:drawing_mini_games/view_model/drawing_painter.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<List<DrawModel?>> history = [];
  List<List<DrawModel?>> redoHistory = [];
  List<DrawModel?> points = List.filled(100000, null);

  final pointsStream = BehaviorSubject<List<DrawModel?>>.seeded([]);
  final sliderStrokeWidth = BehaviorSubject<double>.seeded(3.0);
  final pickedColor = BehaviorSubject<Color>.seeded(Colors.black);

  final key = GlobalKey();

  @override
  void dispose() {
    pointsStream.close();
    sliderStrokeWidth.close();
    pickedColor.close();
    super.dispose();
  }
  double _distanceBetweenPoints(Offset point1, Offset point2) {
    final dx = point1.dx - point2.dx;
    final dy = point1.dy - point2.dy;
    return sqrt(dx * dx + dy * dy);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: key,
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (dragStartDetails) {
              redoHistory.clear();
              final box = key.currentContext?.findRenderObject() as RenderBox;
              final paint = Paint();
              paint.color = pickedColor.stream.value;
              paint.strokeWidth = sliderStrokeWidth.stream.value;
              paint.strokeCap = StrokeCap.round;
              points = [
                ...pointsStream.value,
                DrawModel(
                    box.globalToLocal(dragStartDetails.globalPosition), paint)
              ];
              pointsStream.value = List.from(points);
              pointsStream.add(List.from(points));
            },
            onPanUpdate: (dragUpdateDetails) {
              final box = key.currentContext?.findRenderObject() as RenderBox;
              final paint = Paint();
              paint.color = pickedColor.stream.value;
              paint.strokeWidth = sliderStrokeWidth.stream.value;
              paint.strokeCap = StrokeCap.round;
              final currentPoint = box.globalToLocal(dragUpdateDetails.globalPosition);
              if (points.isEmpty ||
                  _distanceBetweenPoints(currentPoint, points.last!.offset) > 5) {
                points.add(DrawModel(currentPoint, paint));
                pointsStream.value = List.from(points);
                pointsStream.add(List.from(points));
              }
              if (points.length % 10 == 0) {
                print(points.length);
              }
            },
            onPanEnd: (dragEndDetails) {
              points.add(null);
              pointsStream.value = List.from(points);
              history.add(List.from(points));
            },
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: StreamBuilder<List<DrawModel?>>(
                  stream: pointsStream.stream,
                  builder: (context, snapshot) {
                    return CustomPaint(
                      painter: DrawingPainter([snapshot.data ?? []]),
                    );
                  }),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 0,
            bottom: 150,
            child: RotatedBox(
              quarterTurns: 3,
              child: StreamBuilder<double>(
                  stream: sliderStrokeWidth,
                  builder: (context, snapshot) {
                    return CustomSlider(sliderStrokeWidth: sliderStrokeWidth);
                  }),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              child: StreamBuilder<Object>(
                  stream: pickedColor,
                  builder: (context, snapshot) {
                    return ColorPickerButton(pickedColor: pickedColor);
                  }))
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.brown,
            heroTag: "Undo",
            onPressed: () async {
              if (history.isNotEmpty) {
                redoHistory.add(List.from(history.last));
                history.removeLast();
                if (history.isNotEmpty) {
                  pointsStream.add(List.from(history.last));
                } else {
                  pointsStream.add(List.empty());
                }
              }
            },
            child: const Icon(Icons.undo),
          ),
          const SizedBox(
            width: 30,
          ),
          FloatingActionButton(
            backgroundColor: Colors.brown,
            heroTag: "Redo",
            onPressed: () {
              if (redoHistory.isNotEmpty) {
                history.add(List.from(redoHistory.last));
                redoHistory.removeLast();
                pointsStream.add(List.from(history.last));
              }
            },
            child: const Icon(Icons.redo),
          ),
        ],
      ),
    );
  }
}
