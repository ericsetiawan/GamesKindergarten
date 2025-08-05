import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GuessColorPage extends StatefulWidget {
  const GuessColorPage({super.key});

  @override
  State<GuessColorPage> createState() => _GuessColorPageState();
}

class _GuessColorPageState extends State<GuessColorPage> {
  final List<Map<String, dynamic>> _colorData = [
    {'color': Colors.red, 'name': 'Red'},
    {'color': Colors.green, 'name': 'Green'},
    {'color': Colors.blue, 'name': 'Blue'},
    {'color': Colors.yellow, 'name': 'Yellow'},
    {'color': Colors.orange, 'name': 'Orange'},
    {'color': Colors.purple, 'name': 'Purple'},
    {'color': Colors.black, 'name': 'Black'},
    {'color': Colors.brown, 'name': 'Brown'},
    {'color': Colors.grey, 'name': 'Grey'},
    {'color': Colors.cyan, 'name': 'Cyan'},
  ];

  late List<Map<String, dynamic>> _questions;
  late Map<String, dynamic> _currentColor;
  int _questionIndex = 0;
  int _score = 0;
  List<String> _currentOptions = [];

  @override
  void initState() {
    super.initState();
    _questions = List.from(_colorData)..shuffle();
    _setNewQuestion();
  }

  void _setNewQuestion() {
    _currentColor = _questions[_questionIndex];

    final correct = _currentColor['name'];
    final others = _colorData
        .where((e) => e['name'] != correct)
        .map((e) => e['name'] as String)
        .toList()
      ..shuffle();

    _currentOptions = [correct, ...others.take(3)];
    _currentOptions.shuffle();
  }

  void _checkAnswer(String selectedName) {
    bool isCorrect = selectedName == _currentColor['name'];
    if (isCorrect) _score++;

    _showAnimatedDialog(
      isCorrect: isCorrect,
      onDismiss: () {
        if (_questionIndex + 1 >= _questions.length) {
          _showFinalDialog();
        } else {
          setState(() {
            _questionIndex++;
            _setNewQuestion();
          });
        }
      },
    );
  }

  void _showAnimatedDialog({
    required bool isCorrect,
    required VoidCallback onDismiss,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (_, anim, __, ___) {
        return Transform.scale(
          scale: anim.value,
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  isCorrect
                      ? 'assets/lottie/succes.json'
                      : 'assets/lottie/Wrong Monkey.json',
                  width: 150,
                ),
                Text(
                  isCorrect ? "Awesome! You're correct! 🎉" : "Oops! Try again!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDismiss();
                  },
                  child: const Text("Next"),
                )
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  void _showFinalDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/Giraffe celebration transparent background.json',
                width: 180,
              ),
              const SizedBox(height: 10),
              Text(
                "You did it! 🎊",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text("Your score: $_score out of ${_questions.length} colors."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _score = 0;
                    _questionIndex = 0;
                    _questions = List.from(_colorData)..shuffle();
                    _setNewQuestion();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Play Again"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text("Back to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: (_questionIndex + 1) / _questions.length,
      backgroundColor: Colors.grey.shade300,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
      minHeight: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎨 Guess the Color"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProgressBar(),
            const SizedBox(height: 30),
            Text(
              "What color is this?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: _currentColor['color'],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26, width: 2),
              ),
            ),
            const SizedBox(height: 30),
            ..._currentOptions.map((name) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () => _checkAnswer(name),
                  child: Text(name, style: const TextStyle(fontSize: 18)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}