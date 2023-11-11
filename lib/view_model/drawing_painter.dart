import 'dart:ui';

import 'package:drawing_mini_games/model/draw_model.dart';
import 'package:flutter/cupertino.dart';

class DrawingPainter extends CustomPainter{

  final List<List<DrawModel?>> history;

  DrawingPainter(this.history);
  @override
  void paint(Canvas canvas, Size size) {
    for (final pointsList in history) {
      for (int i = 0; i < pointsList.length - 1; i++) {
        if (pointsList[i] != null && pointsList[i + 1] != null) {
          final firstOffset = pointsList[i]?.offset;
          final secondOffset = pointsList[i + 1]?.offset;
          final paint = pointsList[i]?.paint;
          canvas.drawLine(firstOffset!, secondOffset!, paint!);
        } else if (pointsList[i] != null && pointsList[i + 1] == null) {
          List<Offset> offsetList = [];
          offsetList.add(pointsList[i]!.offset);
          canvas.drawPoints(PointMode.points, offsetList, pointsList[i]!.paint);
        }
      }
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

// for(int i = 0; i < pointsList.length-1; i++) {
//   if(pointsList[i] != null && pointsList[i+1] != null){
//     final firstOffset = pointsList[i]?.offset;
//     final secondOffset = pointsList[i+1]?.offset;
//     final paint = pointsList[i]?.paint;
//     canvas.drawLine(firstOffset!, secondOffset!, paint!);
//   }else if(pointsList[i] != null && pointsList[i+1] == null){
//     List<Offset> offsetList = [];
//     offsetList.add(pointsList[i]!.offset);
//     canvas.drawPoints(PointMode.points, offsetList, pointsList[i]!.paint);
//   }
// }