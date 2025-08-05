import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MathImageGamePage extends StatefulWidget {
  const MathImageGamePage({super.key});

  @override
  State<MathImageGamePage> createState() => _MathImageGamePageState();
}

class _MathImageGamePageState extends State<MathImageGamePage> {
  int _currentLevel = 0;
  bool _answered = false;

  final List<_MathQuestion> _questions = [
    _MathQuestion('🍎', 2, '+', 3),
    _MathQuestion('🍌', 5, '-', 2),
    _MathQuestion('🍇', 4, '+', 4),
    _MathQuestion('🍓', 7, '-', 3),
    _MathQuestion('🍌', 3, '+', 6),
    _MathQuestion('🍇', 9, '-', 5),
    _MathQuestion('🍎', 8, '+', 2),
    _MathQuestion('🍓', 5, '+', 5),
    _MathQuestion('🍌', 9, '-', 3),
    _MathQuestion('🍇', 4, '+', 4),
  ];

  void _checkAnswer(int selected) {
    setState(() {
      _answered = true;
    });

    if (selected == _questions[_currentLevel].answer) {
      _showSuccessPopup();
    } else {
      _showErrorSnackbar();
    }
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "❌ Oops! Try again.",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
    setState(() {
      _answered = false;
    });
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/succes.json',
              width: 100,
              height: 100,
              repeat: false,
            ),
            const SizedBox(height: 10),
            const Text(
              '🎉 Great job!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "You're doing amazing!\nReady for the next one?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (_currentLevel < _questions.length - 1) {
                    setState(() {
                      _currentLevel++;
                      _answered = false;
                    });
                  } else {
                    _showFinishDialog();
                  }
                },
                child: const Text(
                  'Next Level 🚀',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("🏁 Finished!"),
        content: const Text("You’ve completed all 10 levels!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentLevel];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Math Game - Level Up!"),
        centerTitle: true,
        backgroundColor: Colors.orange.shade300,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, left: 4,right: 4),
        child: Column(
          children: [
            Text(
              'Level ${_currentLevel + 1}/10',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildEquation(q),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: q.generateOptions().map((opt) {
                return ElevatedButton(
                  onPressed: _answered ? null : () => _checkAnswer(opt),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    opt.toString(),
                    style: const TextStyle(fontSize: 22),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

 Widget buildBox(int count, String emoji) {
  const int maxPerRow = 2;

  List<Widget> rows = [];
  for (int i = 0; i < count; i += maxPerRow) {
    int end = (i + maxPerRow > count) ? count : i + maxPerRow;
    rows.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(end - i, (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
          );
        }),
      ),
    );
  }

  return Container(
    padding: const EdgeInsets.all(4),
    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.orange.shade300, width: 1.5),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 2,
          offset: Offset(1, 1),
        )
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    ),
  );
}

  Widget _buildEquation(_MathQuestion q) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildBox(q.leftCount, q.emoji),
          const SizedBox(width: 4),
          Text(
            q.operator,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          buildBox(q.rightCount, q.emoji),
          const SizedBox(width: 4),
          const Text(
            '=',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              border: Border.all(color: Colors.orange, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ],
  );
}
}

class _MathQuestion {
  final String emoji;
  final int leftCount;
  final String operator;
  final int rightCount;

  _MathQuestion(this.emoji, this.leftCount, this.operator, this.rightCount);

  int get answer => operator == '+' ? leftCount + rightCount : leftCount - rightCount;

  List<int> generateOptions() {
    final correct = answer;
    final options = {
      correct,
      correct + 1,
      correct - 1,
      correct + 2,
    };
    options.removeWhere((e) => e < 0);
    return options.toList()..shuffle();
  }
}