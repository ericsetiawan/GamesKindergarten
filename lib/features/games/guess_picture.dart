import 'package:flutter/material.dart';
import 'package:kinder_quest/core/widgets/popup.dart';
import 'package:lottie/lottie.dart';

class GuessPictureGamePage extends StatefulWidget {
  const GuessPictureGamePage({super.key});

  @override
  State<GuessPictureGamePage> createState() => _GuessPictureGamePageState();
}

class _GuessPictureGamePageState extends State<GuessPictureGamePage> {
  final List<_GuessItem> _questions = [
    _GuessItem(
      image: 'assets/images/cat.jfif',
      correctAnswer: 'Cat',
      options: ['Cat', 'Dog', 'Rabbit'],
    ),
    _GuessItem(
      image: 'assets/images/elephant.jfif',
      correctAnswer: 'Elephant',
      options: ['Elephant', 'Hippo', 'Rhino'],
    ),
    _GuessItem(
      image: 'assets/images/girrafe.jfif',
      correctAnswer: 'Giraffe',
      options: ['Giraffe', 'Zebra', 'Horse'],
    ),
    _GuessItem(
      image: 'assets/images/hedgehog.jfif',
      correctAnswer: 'Hedgehog',
      options: ['Hedgehog', 'Mouse', 'Beaver'],
    ),
    _GuessItem(
      image: 'assets/images/koala.jfif',
      correctAnswer: 'Koala',
      options: ['Koala', 'Panda', 'Sloth'],
    ),
    _GuessItem(
      image: 'assets/images/lion.jfif',
      correctAnswer: 'Lion',
      options: ['Lion', 'Tiger', 'Bear'],
    ),
    _GuessItem(
      image: 'assets/images/monkey.jfif',
      correctAnswer: 'Monkey',
      options: ['Monkey', 'Gorilla', 'koala'],
    ),
    _GuessItem(
      image: 'assets/images/panda.jfif',
      correctAnswer: 'Panda',
      options: ['Panda', 'Koala', 'Bear'],
    ),
    _GuessItem(
      image: 'assets/images/scorpion.jfif',
      correctAnswer: 'Scorpion',
      options: ['Scorpion', 'Spider', 'Lobster'],
    ),
    _GuessItem(
      image: 'assets/images/tiger.jfif',
      correctAnswer: 'Tiger',
      options: ['Tiger', 'Lion', 'Cheetah'],
    ),
  ];

  // final List<_GuessItem> _questions = [
  //   _GuessItem(
  //     image: 'assets/images/cat.webp',
  //     correctAnswer: 'Cat',
  //     options: ['Cat', 'Dog', 'Rabbit'],
  //   ),
  //   _GuessItem(
  //     image: 'assets/images/elephant.webp',
  //     correctAnswer: 'Elephant',
  //     options: ['Elephant', 'Hippo', 'Rhino'],
  //   ),
  //   _GuessItem(
  //     image: 'assets/images/girrafe.webp',
  //     correctAnswer: 'Giraffe',
  //     options: ['Giraffe', 'Zebra', 'Horse'],
  //   ),
  //   _GuessItem(
  //     image: 'assets/images/hedgehog.webp',
  //     correctAnswer: 'Hedgehog',
  //     options: ['Hedgehog', 'Mouse', 'Beaver'],
  //   ),
  //   _GuessItem(
  //     image: 'assets/images/koala.webp',
  //     correctAnswer: 'Koala',
  //     options: ['Koala', 'Panda', 'Sloth'],
  //   ),
  //   _GuessItem(
  //     image: 'assets/images/lion.webp',
  //     correctAnswer: 'Lion',
  //     options: ['Lion', 'Tiger', 'Bear'],
  //   ),
  //   _GuessItem(
  //     image: 'assets/images/monkey.webp',
  //     correctAnswer: 'Monkey',
  //     options: ['Monkey', 'Gorilla', 'koala'],
  //   ),
  //   _GuessItem(
  //     image: 'assets/images/panda.webp',
  //     correctAnswer: 'Panda',
  //     options: ['Panda', 'Koala', 'Bear'],
  //   ),
  //   _GuessItem(
  //     image: 'assets/images/scorpio.webp',
  //     correctAnswer: 'Scorpion',
  //     options: ['Scorpion', 'Spider', 'Lobster'],
  //   ),
  //   _GuessItem(
  //     image: 'assets/images/tiger.webp',
  //     correctAnswer: 'Tiger',
  //     options: ['Tiger', 'Lion', 'Cheetah'],
  //   ),
  // ];

  int _currentIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  int _correctCount = 0;

  void _checkAnswer(String selected) {
    final correct = _questions[_currentIndex].correctAnswer == selected;
    setState(() {
      _isCorrect = correct;
      _isAnswered = true;
      if (correct) _correctCount++;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _isAnswered = false;
          _questions[_currentIndex].options.shuffle(); // acak opsi lagi
        });
      } else {
        _showFinishDialog();
      }
    });
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => FinalPopup(
        totalCorrect: _correctCount,
        totalQuestions: _questions.length,
        onBackToHome: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _questions.shuffle(); // ACak urutan soal di awal
    _questions[_currentIndex].options.shuffle(); // Acak pilihan pertama
  }

  @override
  Widget build(BuildContext context) {
    final current = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🖼️ Guess the Picture'),
        backgroundColor: Colors.purpleAccent,
      ),
      backgroundColor: Colors.purple.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(current.image),
                constraints: const BoxConstraints(maxHeight: 400),
                child: Center(
                  child: Image.asset(
                    current.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_isAnswered)
              Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: Lottie.asset(
                      _isCorrect
                          ? 'assets/lottie/Correct.json'
                          : 'assets/lottie/Wrong Monkey.json',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isCorrect ? 'Correct! 🎉' : 'Oops! Try Again 🙈',
                    style: TextStyle(
                      fontSize: 22,
                      color: _isCorrect ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: current.options.map((option) {
                return ElevatedButton(
                  onPressed: _isAnswered ? null : () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(110, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.purple),
                  ),
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuessItem {
  final String image;
  final String correctAnswer;
  final List<String> options;

  _GuessItem({
    required this.image,
    required this.correctAnswer,
    required this.options,
  });
}