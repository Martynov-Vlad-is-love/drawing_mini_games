import 'package:drawing_mini_games/model/draw_model.dart';
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
  final pointsStream = BehaviorSubject<List<DrawModel?>>.seeded([]);
  final sliderStrokeWidth = BehaviorSubject<double>.seeded(3.0);
  final key = GlobalKey();

  Color pickedColor = Colors.black;
  double pickedStrokeWidth = 20.0;

  @override
  void dispose() {
    pointsStream.close();
    sliderStrokeWidth.close();
    super.dispose();
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
              paint.color = pickedColor;
              paint.strokeWidth = sliderStrokeWidth.stream.value;
              paint.strokeCap = StrokeCap.round;
              final points = [...pointsStream.value, DrawModel(
                  box.globalToLocal(dragStartDetails.globalPosition),
                  paint,
                  Colors.black)];
              pointsStream.value = points;
              pointsStream.add(points);
            },
            onPanUpdate: (dragUpdateDetails) {
              final box = key.currentContext?.findRenderObject() as RenderBox;
              final paint = Paint();
              paint.color = pickedColor;
              paint.strokeWidth = sliderStrokeWidth.stream.value;
              paint.strokeCap = StrokeCap.round;
              final points = [...pointsStream.value, DrawModel(
                  box.globalToLocal(dragUpdateDetails.globalPosition),
                  paint,
                  Colors.black)];
              pointsStream.value = points;
              pointsStream.add(points);
            },
            onPanEnd: (dragEndDetails) {
              final points = [...pointsStream.value, null];
              pointsStream.value = points;
              history.add(points);
              print(history.length);
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
                  return Slider(
                      min: 1,
                      max: 20,
                      value: sliderStrokeWidth.stream.value,
                      onChanged: (value) {
                        sliderStrokeWidth.value = value;
                      });
                }
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
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
