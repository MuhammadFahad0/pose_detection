
import 'package:flutter/material.dart';

class PointOnCamera extends CustomPainter {
  PointOnCamera({required this.pointPosition});

  final List<Map<String,double>> pointPosition;


  @override
  void paint(Canvas canvas, Size size) {


    print("canvus Size $size");



    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 10.0
      ..color = Colors.indigo;


       canvas.drawRect(
         Rect.fromLTWH(size.width - 10, size.height - 10, 10, 10),
        paint,
      );



    // for (var element in pointPosition) {
    //   canvas.drawRect(
    //     Rect.fromLTWH(element["left"]??0.0, element["top"]??0.0, 10, 10),
    //  //   const Rect.fromLTWH(720/2, 1280/2, 10, 10),
    //     paint,
    //   );
    //
    // }
    //

  }

  @override
  bool shouldRepaint(oldDelegate) => true;
}