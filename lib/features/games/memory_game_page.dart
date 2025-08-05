import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  final int gridSize = 4; // 4x4
  late List<_MemoryCard> _cards;
  _MemoryCard? _firstSelected;
  bool _waiting = false;
  int _matchedPairs = 0;

  final List<String> _emojis = [
    '🐶', '🐱', '🦁', '🐸',
    '🐵', '🐼', '🦊', '🐰',
  ];

  @override
  void initState() {
    super.initState();
    _generateCards();
  }

  void _generateCards() {
    List<String> content = [..._emojis, ..._emojis];
    content.shuffle(Random());
    _cards = content.map((e) => _MemoryCard(content: e)).toList();
  }

  void _onCardTap(_MemoryCard card) async {
    if (_waiting || card.isRevealed || card.isMatched) return;
    setState(() => card.isRevealed = true);

    if (_firstSelected == null) {
      _firstSelected = card;
    } else {
      _waiting = true;
      await Future.delayed(const Duration(milliseconds: 700));

      if (_firstSelected!.content == card.content) {
        setState(() {
          _firstSelected!.isMatched = true;
          card.isMatched = true;
          _matchedPairs++;
        });
        if (_matchedPairs == _emojis.length) {
          _showFinishDialog();
        }
      } else {
        setState(() {
          _firstSelected!.isRevealed = false;
          card.isRevealed = false;
        });
      }

      _firstSelected = null;
      _waiting = false;
    }
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉 You did it!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'All animals matched! Great memory!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _matchedPairs = 0;
                  _generateCards();
                  _firstSelected = null;
                });
              },
              child: const Text("Play Again"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Back to Home"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade50,
      appBar: AppBar(
        title: const Text("🧠 Memory Game"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final card = _cards[index];
            return GestureDetector(
              onTap: () => _onCardTap(card),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: card.isRevealed || card.isMatched ? Colors.white : Colors.green.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                  boxShadow: card.isRevealed || card.isMatched
                      ? [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    card.isRevealed || card.isMatched ? card.content : '',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MemoryCard {
  final String content;
  bool isRevealed = false;
  bool isMatched = false;

  _MemoryCard({required this.content});
}