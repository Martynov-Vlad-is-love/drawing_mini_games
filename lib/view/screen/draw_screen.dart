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
  List<DrawModel?> points = [];
  List<List<DrawModel?>> history = [];
  final pointsStream = BehaviorSubject<List<DrawModel?>>();
  final key = GlobalKey();
  @override
  void dispose() {
    pointsStream.close();
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
              final box = key.currentContext?.findRenderObject() as RenderBox;
              final paint = Paint();
              paint.color = Colors.black;
              paint.strokeWidth = 3.0;
              paint.strokeCap = StrokeCap.round;
              points.add(DrawModel(box.globalToLocal(dragStartDetails.globalPosition), paint, Colors.black));
              pointsStream.add(points);
            },
            onPanUpdate: (dragUpdateDetails) {
              final box = key.currentContext?.findRenderObject() as RenderBox;
              final paint = Paint();
              paint.color = Colors.black;
              paint.strokeWidth = 6.0;
              paint.strokeCap = StrokeCap.round;
              points.add(DrawModel(box.globalToLocal(dragUpdateDetails.globalPosition), paint, Colors.black));

              pointsStream.add(points);            },
            onPanEnd: (dragEndDetails) {
              history.add(List.from(points));
              points.add(null);
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
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(onPressed: (){}),
          SizedBox(width: 30,),
          FloatingActionButton(onPressed: (){}),
        ],
      ),
    );
  }
}
