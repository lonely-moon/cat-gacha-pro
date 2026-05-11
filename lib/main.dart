import 'package:flutter/material.dart';
import 'screens/gacha_screen.dart';
//乱数を使うための機能を追加

//意味ー猫の情報を管理するためのデータ設計図（モデル）を作成する
//理由ー画像パスやメッセージをバラバラに管理せずに、１つの「猫」というオブジェクトとして箱にまとまるため

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GachaScreen(), //最初の画面をここにする
    );
  }
}
