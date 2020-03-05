import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediswift/home.dart';
import 'package:mediswift/login.dart';
import 'package:mediswift/register.dart';
import 'database/Model.dart';
Model current;
String google_api_ky="AIzaSyCsFvmoBsPBhQG1rzlL1aY8rUV6DPgt7Cw";
double height, width;

void main() => runApp(new MaterialApp(
  routes: {
        '/':(cons)=>LogPage(),
    MyHome.HomeRoute: (cont) => MyHome(),
    Register.RegisterRoute:(con)=>Register()
  },
    ));


class MyBorder extends InputBorder {
  @override
  InputBorder copyWith({BorderSide borderSide}) {
    // TODO: implement copyWith
    return null;
  }

  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getInnerPath
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getOuterPath
    return null;
  }

  @override
  // TODO: implement isOutline
  bool get isOutline => false;

  @override
  void paint(Canvas canvas, Rect rect,
      {double gapStart,
      double gapExtent = 0.0,
      double gapPercentage = 0.0,
      TextDirection textDirection}) {
    // TODO: implement paint
    Paint paint = new Paint();
    paint.color = Colors.lightBlueAccent.shade400;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3.0;
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect,
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        paint);
  }

  @override
  ShapeBorder scale(double t) {
   return null;
  }
}

double dw(double pt) => pt * width / 100;

double dh(double pt) => pt * height / 100;
