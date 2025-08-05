import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class PuzzleGamePage extends StatefulWidget {
  const PuzzleGamePage({super.key});

  @override
  State<PuzzleGamePage> createState() => _PuzzleGamePageState();
}

class _PuzzleGamePageState extends State<PuzzleGamePage> {
  static const int gridSize = 4;
  late ui.Image image;
  List<int> positions = [];
  bool isLoading = true;

  final List<String> imagePaths = [
    'assets/images/puzzle.jfif',
    'assets/images/puzzle-1.jfif',
    'assets/images/puzzle-3.jfif',
    'assets/images/puzzle-4.jfif',
  ];

  @override
  void initState() {
    super.initState();
    _loadRandomImage();
  }

  void _loadRandomImage() {
    isLoading = true;
    setState(() {});

    final random = Random();
    final selectedImage = imagePaths[random.nextInt(imagePaths.length)];
    _loadImage(selectedImage);
  }

  Future<void> _loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    image = frame.image;
    _resetPuzzle();
  }

  void _resetPuzzle() {
    positions = List.generate(gridSize * gridSize, (index) => index);
    positions.shuffle(Random());
    isLoading = false;
    setState(() {});
  }

  bool _isPuzzleComplete() {
    for (int i = 0; i < positions.length; i++) {
      if (positions[i] != i) return false;
    }
    return true;
  }

  void _onSwap(int fromIndex, int toIndex) {
  setState(() {
    final temp = positions[fromIndex];
    positions[fromIndex] = positions[toIndex];
    positions[toIndex] = temp;

    if (_isPuzzleComplete()) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Puzzle Complete",
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, anim1, anim2) => const SizedBox(),
        transitionBuilder: (context, anim1, anim2, child) {
          return ScaleTransition(
            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "🎉 Puzzle Completed!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Great job! You're a puzzle master!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text("Play Again"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                textStyle: const TextStyle(decoration: TextDecoration.none),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Future.delayed(Duration.zero, () {
                                  _loadRandomImage();
                                });
                              },
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.home),
                              label: const Text("Home"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                side: const BorderSide(color: Colors.green, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                textStyle: const TextStyle(decoration: TextDecoration.none),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final tileSize = MediaQuery.of(context).size.width / gridSize - 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🧩 Image Puzzle"),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _loadRandomImage,
            tooltip: "New Puzzle",
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                itemCount: gridSize * gridSize,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final tileIndex = positions[index];
                  return DragTarget<int>(
                    builder: (context, candidateData, rejectedData) {
                      return Draggable<int>(
                        data: index,
                        feedback: _buildImageTile(tileIndex, tileSize, dragging: true),
                        childWhenDragging: Container(
                          width: tileSize,
                          height: tileSize,
                          color: Colors.grey[300],
                        ),
                        child: _buildImageTile(tileIndex, tileSize),
                      );
                    },
                    onAccept: (fromIndex) {
                      _onSwap(fromIndex, index);
                    },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildImageTile(int tileIndex, double size, {bool dragging = false}) {
    final row = tileIndex ~/ gridSize;
    final col = tileIndex % gridSize;
    final imageWidth = image.width / gridSize;
    final imageHeight = image.height / gridSize;

    return ClipRect(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _ImageTilePainter(
            image,
            Rect.fromLTWH(
              col * imageWidth,
              row * imageHeight,
              imageWidth,
              imageHeight,
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageTilePainter extends CustomPainter {
  final ui.Image image;
  final Rect srcRect;

  _ImageTilePainter(this.image, this.srcRect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}