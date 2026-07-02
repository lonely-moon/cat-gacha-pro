import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: CarSimulationPage()));
}

class CarSimulationPage extends StatefulWidget {
  const CarSimulationPage({super.key});

  @override
  State<CarSimulationPage> createState() => _CarSimulationPageState();
}

class _CarSimulationPageState extends State<CarSimulationPage> {
  // [意味] 画面の中に登場させる車のデータ（スタート位置）を設定します
  Car myCar = Car(x: 50.0, y: 200.0, angle: 0.0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // [意味] アプリが起動したら、0.03秒ごとにずっと車の数字を動かし続けるタイマーを開始します
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        myCar.x += 2.0; // [意味] 車を少しずつ右に進めます
        myCar.angle += 0.05; // [意味] 車を少しずつ右に回転させます（グルグル回ります）

        // [意味] 画面の外（右端）にはみ出したら、左端（x=0）に戻します
        if (myCar.x > 400) {
          myCar.x = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 画用紙の背景を白にします
      body: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: _SimulationPainter(
          carX: myCar.x,
          carY: myCar.y,
          carAngle: myCar.angle,
        ),
      ),
    );
  }
}

// =========================================================================
// 【車のデータを管理するクラス（設計図）】
// =========================================================================
class Car {
  double x;
  double y;
  double angle;
  Car({required this.x, required this.y, required this.angle});
}

// =========================================================================
// 【画面に車を実際に描く絵描きロボット（部品の中身）】
// =========================================================================
class _SimulationPainter extends CustomPainter {
  final double carX;
  final double carY;
  final double carAngle;

  _SimulationPainter({
    required this.carX,
    required this.carY,
    required this.carAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;

    canvas.save();
    canvas.translate(carX + 30, carY + 15); // 車の中心を軸にする
    canvas.rotate(carAngle); // 角度の分だけ回転させる
    canvas.drawRect(const Rect.fromLTWH(-30, -15, 60, 30), paint); // 車を描く
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SimulationPainter oldDelegate) {
    return oldDelegate.carX != carX ||
        oldDelegate.carY != carY ||
        oldDelegate.carAngle != carAngle;
  }
}
