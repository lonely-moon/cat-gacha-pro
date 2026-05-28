// ページ番号: 1 / 1
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '自動拡張マインドマップ・学習総合プラットフォーム',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainDashboardApp(),
    );
  }
}

// マインドマップ上の1つの要素（カード）をデータとして定義するクラス
class MindMapNode {
  final String title; // カードのタイトル
  final String description; // 詳細な解説文（意味・役割・注意点など）
  final Offset position; // 画面に配置する位置座標（X, Y）
  final Color color; // カードの縁取り（テーマ）カラー

  MindMapNode({
    required this.title,
    required this.description,
    required this.position,
    required this.color,
  });
}

// メインのダッシュボード画面（StatefulWidget）
class MainDashboardApp extends StatefulWidget {
  const MainDashboardApp({super.key});

  @override
  State<MainDashboardApp> createState() => _MainDashboardAppState();
}

// 画面の状態（データとロジック）を管理するクラス
class _MainDashboardAppState extends State<MainDashboardApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ① コード解析用の変数・コントローラー
  final TextEditingController _codeController = TextEditingController();
  String _analysisResult = '';

  // ② AIサイドバー用の変数・コントローラー
  final TextEditingController _aiQueryController = TextEditingController();
  String _aiResponseText = 'AIアシスタントへ質問を入力してください。';
  String _selectedAI = 'Gemini';

  // ③ メモ帳用のコントローラー・状態管理
  final TextEditingController _memoController = TextEditingController();
  String _memoSaveStatus = '未保存';

  // ④ 自動拡張マインドマップ用の変数・コントローラー
  final TextEditingController _mindMapInputController = TextEditingController();
  List<MindMapNode> _mindMapNodes = [];

  @override
  void initState() {
    super.initState();
    // 3つのタブ（マインドマップ、コード解析、メモ帳）を制御します
    _tabController = TabController(length: 3, vsync: this);
    // 起動時にデフォルトで「Flutter」のマインドマップを展開します
    _generateMindMap('Flutter');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    _aiQueryController.dispose();
    _memoController.dispose();
    _mindMapInputController.dispose();
    super.dispose();
  }

  // 【中核システム】入力された専門用語からマインドマップを自動拡張する関数
  void _generateMindMap(String keyword) {
    String target = keyword.trim();
    if (target.isEmpty) return;

    setState(() {
      _mindMapNodes = [];

      // ① 中心ノード（ユーザーが入力したキーワードをど真ん中に配置）
      _mindMapNodes.add(
        MindMapNode(
          title: '【中心】 $target',
          description: '入力されたこの専門用語を、周囲の4つの枝葉（意味・役割・注意点・例え）で徹底的に構造分解します。',
          position: const Offset(300, 220), // ほぼ中央の座標
          color: Colors.blueAccent,
        ),
      );

      // デフォルトの解説文章テンプレート
      String definition =
          '意味（概念）：IT開発において、特定の処理や仕組みを効率よく実現するために定義された重要キーワードです。';
      String role = '役割（システム）：プログラムのコピペを減らし、バグを防いでチーム全体の開発再現性を引き上げるために存在します。';
      String caution =
          '注意点（つまずき処）：文字だけで丸暗記しようとせず、このマップのように視覚的な「繋がり」を意識して覚えるのがコツです。';
      String example =
          '例え話（身の回り）：コンセントの穴の形が全国で統一されているから、どの家電でも買ってすぐ使えるのと同じ仕組みです。';

      // 特定の重要キーワードが入力された場合、中身をさらに超詳細版に切り替える
      String lowerTarget = target.toLowerCase();
      if (lowerTarget == 'state' || target == '状態管理') {
        definition = '意味（動的データ保持）：画面のボタンを押した時などに、リアルタイムで変化するメモリ上の最新データのことです。';
        role = '役割（再描画トリガー）：データが書き換わったことをシステムに通知し、画面の見た目（UI）を一瞬で自動更新させます。';
        caution =
            '注意点（処理のフリーズ）：「setState」を一秒間に何千回も限界を超えて呼び出すと、スマホの処理が追いつかずにフリーズします。';
        example =
            '例え話（ゲームのHP）：モンスターから攻撃を受けて「体力数値」が減ったら、画面上の「残りHPバー」も連動して縮む仕組みです。';
      } else if (lowerTarget == 'api' || target == '非同期処理') {
        definition = '意味（外部連携窓口）：異なるアプリやサーバー同士が、ルールに従って安全に情報をやり取りするための連絡通路です。';
        role = '役割（データ中継）：インターネットの向こう側にある巨大なデータベースから、今必要なデータ（猫の画像など）を引っ張ってきます。';
        caution =
            'よくある間違い（通信遮断）：機内モードなど電波が完全に切れている状態で呼び出すと、データの取得に失敗してアプリが止まります。';
        example =
            '比喩（レストランの注文）：厨房へ直接行くのではなく、店員さん（API）にメニューを伝えて料理（データ）を席まで運んでもらう関係です。';
      } else if (lowerTarget == 'class' || target == 'クラス') {
        definition =
            '意味（設計図の定義）：オブジェクト（データや画面の部品）をプログラムの中で量産するために用意する「独自の型」です。';
        role =
            '役割（オブジェクト量産）：同じ構造や機能を持った画面（プロフィール画面や設定画面など）を、1から作らずに何個でも複製できます。';
        caution =
            '注意点（実体化の忘れ）：設計図（class）を書いただけでは画面に現れません。必ず「MyApp()」のように呼び出して実体を作る必要があります。';
        example =
            '例え話（たい焼きの型）：「たい焼きの型（クラス）」が1つあれば、中にあんこやカスタード（データ）を入れて実体（たい焼き）を大量生産できます。';
      }

      // ② 四方の枝葉ノード（カード）を配置（中心を囲むように上下左右に展開）
      _mindMapNodes.add(
        MindMapNode(
          title: '① 厳密な意味',
          description: definition,
          position: const Offset(30, 40),
          color: Colors.green,
        ),
      );
      _mindMapNodes.add(
        MindMapNode(
          title: '② システム上の役割',
          description: role,
          position: const Offset(570, 40),
          color: Colors.orange,
        ),
      );
      _mindMapNodes.add(
        MindMapNode(
          title: '③ 注意点・つまずき処',
          description: caution,
          position: const Offset(30, 380),
          color: Colors.redAccent,
        ),
      );
      _mindMapNodes.add(
        MindMapNode(
          title: '④ 理解を深める例え話',
          description: example,
          position: const Offset(570, 380),
          color: Colors.purpleAccent,
        ),
      );
    });
  }

  // コード一括自動解析ロジック
  void _analyzeCode() {
    setState(() {
      String input = _codeController.text.trim();
      _analysisResult = '';

      if (input.contains('import') && input.contains('void main')) {
        _analysisResult +=
            '【解析結果①：アプリ起動コード】\n■ import / void main() / runApp()\n・意味：OSから最初に呼ばれる実行スイッチと外部パーツの読み込み構文です。\n------------------------------------------------------------\n\n';
      }
      if (input.contains('TextEditingController')) {
        _analysisResult +=
            '【解析結果②：変数宣言】\n■ TextEditingController\n・意味：TextFieldの文字を掴んで離さない「データ受信機」です。\n------------------------------------------------------------\n\n';
      }

      if (_analysisResult.isEmpty) {
        _analysisResult = '対応するDart構文が検出されませんでした。';
      }
    });
  }

  // 右側サイドバー：AI検索ロジック
  void _searchWithAI() {
    setState(() {
      String query = _aiQueryController.text.trim();
      if (query.isEmpty) return;
      _aiResponseText =
          '【$_selectedAI からの即時回答】\n「$query」を分解しました。さらに深く知りたい場合は、左の「自動拡張マインドマップ」に入力して可視化を試してください。';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自動拡張マインドマップ ＆ エンジニア学習総合ダッシュボード'),
        backgroundColor: Colors.blueAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.hub), text: '自動拡張マインドマップ'),
            Tab(icon: Icon(Icons.analytics), text: 'コード一発可視化'),
            Tab(icon: Icon(Icons.note_alt), text: 'つど開けるメモ帳'),
          ],
        ),
      ),
      body: Row(
        children: [
          // 左側メインコンテンツエリア（3つの機能タブを切り替え）
          Expanded(
            flex: 7,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMindMapTab(),
                _buildCodeAnalysisTab(),
                _buildMemoTab(),
              ],
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
          // 右側：縦長常駐AIサイドバー
          _buildAISidebar(),
        ],
      ),
    );
  }

  // 【左タブ1】自動拡張マインドマップ画面
  Widget _buildMindMapTab() {
    return Column(
      children: [
        // キーワード入力セクション
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _mindMapInputController,
                  decoration: const InputDecoration(
                    labelText: '調べたいIT専門用語を入力してね（例: State, API, class）',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _generateMindMap(val),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _generateMindMap(_mindMapInputController.text),
                icon: const Icon(Icons.blur_circular),
                label: const Text('マップを自動拡張する'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        // マインドマップ描画キャンバス
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // 背景：ノードを繋ぐ「線」を自動描画
                CustomPaint(
                  size: Size.infinite,
                  painter: MindMapLinePainter(nodes: _mindMapNodes),
                ),
                // 前景：各ノード（カード）を絶対座標で配置
                ..._mindMapNodes.map((node) {
                  return Positioned(
                    left: node.position.dx,
                    top: node.position.dy,
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: node.color, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((255 * 0.05).round()),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: node.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              node.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            node.description,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 【左タブ2】コード解析画面
  Widget _buildCodeAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // 【修正完了】スペルミスと重複を完全に修正し、クリーンに配置
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dartコードをコピペ入力してください',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _codeController,
            maxLines: 6,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ここにコードを貼り付けてね',
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _analyzeCode,
              icon: const Icon(Icons.bolt),
              label: const Text('コード構造を一発可視化する'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _analysisResult.isEmpty ? '解析結果がここにでます。' : _analysisResult,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  // 【左タブ3】メモ帳画面
  Widget _buildMemoTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '学習メモ（自由に記録・保存可能）',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Chip(
                label: Text(_memoSaveStatus),
                backgroundColor: Colors.amberAccent,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TextField(
              controller: _memoController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'マップで学んだことをここにメモして残せます。',
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _memoSaveStatus = '保存完了'),
              icon: const Icon(Icons.save),
              label: const Text('メモを保存する'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  // 【右側固定】縦長AIサイドバー
  Widget _buildAISidebar() {
    return Container(
      width: 350,
      color: Colors.grey[50],
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'つど調べられるAIアシスタント',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _selectedAI = 'Gemini'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAI == 'Gemini'
                        ? Colors.purple
                        : Colors.grey[300],
                  ),
                  child: Text(
                    'Gemini',
                    style: TextStyle(
                      color: _selectedAI == 'Gemini'
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _selectedAI = 'Copilot'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAI == 'Copilot'
                        ? Colors.blue[900]
                        : Colors.grey[300],
                  ),
                  child: Text(
                    'Copilot',
                    style: TextStyle(
                      color: _selectedAI == 'Copilot'
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _aiQueryController,
            decoration: InputDecoration(
              labelText: '$_selectedAI に技術質問する',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _searchWithAI,
              ),
            ),
            onSubmitted: (_) => _searchWithAI(),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _aiResponseText,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// マインドマップの「線」を引くレンダリングクラス
class MindMapLinePainter extends CustomPainter {
  final List<MindMapNode> nodes;
  MindMapLinePainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) return;

    // 中心ノード（インデックス0番）の中心位置を計算
    final centerNode = nodes[0];
    final Offset centerPoint = Offset(
      centerNode.position.dx + 125, // カード横幅の半分
      centerNode.position.dy + 40, // カード縦幅のおおよその半分
    );

    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 中心からすべての枝葉（インデックス1番以降）に向かって線を繋ぐ
    for (int i = 1; i < nodes.length; i++) {
      final leafNode = nodes[i];
      final Offset leafPoint = Offset(
        leafNode.position.dx + 125,
        leafNode.position.dy + 40,
      );
      canvas.drawLine(centerPoint, leafPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MindMapLinePainter oldDelegate) => true;
}
