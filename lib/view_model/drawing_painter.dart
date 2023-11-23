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
        final currentPoint = pointsList[i];
        final nextPoint = pointsList[i + 1];

        if (currentPoint != null) {
          final paint = currentPoint.paint;
          final firstOffset = currentPoint.offset;

          if (nextPoint != null) {
            final secondOffset = nextPoint.offset;
            canvas.drawLine(firstOffset, secondOffset, paint);
          } else {
            canvas.drawPoints(PointMode.points, [firstOffset], paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
