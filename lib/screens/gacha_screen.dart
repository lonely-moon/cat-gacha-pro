import 'package:flutter/material.dart';
import 'dart:math';
import '../models/cat_model.dart'; //さっき作ったモデルを読み込む

class GachaScreen extends StatefulWidget {
  const GachaScreen({super.key});

  @override
  State<GachaScreen> createState() => _GachaScreenState();
}
//中身を記憶する場所(State)

class _GachaScreenState extends State<GachaScreen> {
  final List<CatModel> cats = [
    CatModel(
      message: 'スーパーレア：白猫が出た!',
      imagePath: 'assets/images/cat0.png',
      label: '白猫',
    ),
    CatModel(
      message: 'レア：茶猫でた!',
      imagePath: 'assets/images/cat1.png',
      label: '茶猫',
    ),
    CatModel(
      message: 'ノーマル:ハズレ...また明日!',
      imagePath: 'assets/images/cat2.png',
      label: 'ハズレ',
    ),
  ];

  CatModel _currentCat = CatModel(
    message: 'ガチャを回してね!',
    imagePath: 'assets/images/cat1.png',
    label: '未確定',
  );

  void _gacha() {
    //ランダムな数字を作る

    setState(() {
      //リストの長さを使ってランダムなインデックスを取得
      int index = Random().nextInt(cats.length);
      //リストから該当する猫データを取得して上書きする
      _currentCat = cats[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cat Gacha Pro')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_currentCat.message),
            //画面に表示する文字
            const SizedBox(height: 20),
            //ボタン配置
            Image.asset(_currentCat.imagePath, width: 200, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _gacha,
              //ボタン押した時の動き
              child: const Text('ガチャを回す'),
            ),
          ],
        ),
      ),
    );
  }
}
