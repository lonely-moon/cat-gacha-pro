import 'package:flutter/material.dart';
import 'dart:math';
//乱数を使うための機能を追加

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
//中身を記憶する場所(State)

class _MyAppState extends State<MyApp> {
  //ここに変数を置く
  String message = 'ガチャを回してね!';
  String imagePath = 'assets/images/cat1.png'; //初期画像

  void _gacha() {
    //ランダムな数字を作る

    int result = Random().nextInt(3);
    setState(() {
      //数字によって結果を変える

      if (result == 0) {
        message = 'スーパーレア：白猫が出た!';
        imagePath = 'assets/images/cat0.png';
      } else if (result == 1) {
        message = 'レア：茶猫が出た!';
        imagePath = 'assets/images/cat1.png';
      } else {
        message = 'ノーマル：ハズレ...また明日!';
        imagePath = 'assets/images/cat2.png';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Cat Gacha Pro')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              //画面に表示する文字
              const SizedBox(height: 20),
              //ボタン配置
              Image.asset(imagePath, width: 200, height: 200),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _gacha,
                //ボタン押した時の動き
                child: const Text('ガチャを回す'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
