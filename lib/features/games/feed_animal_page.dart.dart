import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FeedTheAnimalPage extends StatefulWidget {
  const FeedTheAnimalPage({super.key});

  @override
  State<FeedTheAnimalPage> createState() => _FeedTheAnimalPageState();
}

class Animal {
  final String emoji;
  final String food;
  final String name;

  Animal({required this.emoji, required this.food, required this.name});
}

class _FeedTheAnimalPageState extends State<FeedTheAnimalPage> {
  final List<Animal> _allAnimals = [
    Animal(emoji: '🐰', food: '🥕', name: 'Rabbit'),
    Animal(emoji: '🐵', food: '🍌', name: 'Monkey'),
    Animal(emoji: '🦁', food: '🥩', name: 'Lion'),
    Animal(emoji: '🐍', food: '🐁', name: 'Snake'),
    Animal(emoji: '🐼', food: '🎍', name: 'Panda'),
    Animal(emoji: '🐶', food: '🦴', name: 'Dog'),
    Animal(emoji: '🐿️', food: '🥜', name: 'Squirrel '),
    Animal(emoji: '🦒', food: '🌳', name: 'Giraffe'),
    Animal(emoji: '🐔', food: '🪱', name: 'Chicken'),
    Animal(emoji: '🐧', food: '🐟', name: 'Penguin'),
  ];

  late List<Animal> _questions;
  late Animal _currentAnimal;
  int _score = 0;
  int _round = 0;

  @override
  void initState() {
    super.initState();
    _questions = List.from(_allAnimals)..shuffle();
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_round < 10) {
      _currentAnimal = _questions[_round];
    }
  }

  void _handleDrop(String food) {
    final isCorrect = food == _currentAnimal.food;
    if (isCorrect) _score++;
    _showFeedbackDialog(isCorrect);
    setState(() => _round++);
  }

  void _showFeedbackDialog(bool isCorrect) {
  final animalName = _currentAnimal.name;
  final food = _currentAnimal.food;
  final customMessage = isCorrect
      ? "Yay! The $animalName loves $food! 🐾"
      : "Oh no! The $animalName doesn't eat that 😅";

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              isCorrect
                  ? 'assets/lottie/succes.json'
                  : 'assets/lottie/Wrong Monkey.json',
              width: 180,
              repeat: false,
            ),
            const SizedBox(height: 16),
            Text(
              isCorrect ? "🎉 Correct!" : "🙈 Oops!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              customMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect ? Colors.green : Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (_round >= 10) {
                  _showResultDialog();
                } else {
                  setState(() => _nextQuestion());
                }
              },
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/Giraffe celebration transparent background.json', width: 180),
              const SizedBox(height: 10),
              const Text("🎉 Yay! All Done!",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("You fed all the animals! 🐾",
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text("Your Score: $_score / 10",
                  style: const TextStyle(fontSize: 22, color: Colors.green)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("Back to Home"),
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _score = 0;
                    _round = 0;
                    _questions = List.from(_allAnimals)..shuffle();
                    _nextQuestion();
                  });
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _generateChoices() {
    final otherFoods = _allAnimals
        .where((a) => a.food != _currentAnimal.food)
        .map((e) => e.food)
        .toList()
      ..shuffle();
    final choices = otherFoods.take(3).toList();
    choices.add(_currentAnimal.food);
    choices.shuffle();
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    final foodChoices = _generateChoices();

    return Scaffold(
      appBar: AppBar(
        title: const Text("🐾 Feed the Animal"),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      backgroundColor: Colors.yellow.shade50,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "What does the ${_currentAnimal.name} eat?",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          DragTarget<String>(
            onAccept: _handleDrop,
            builder: (context, candidateData, rejectedData) {
              return Column(
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: candidateData.isNotEmpty ? 1.2 : 1.0,
                    child: Text(
                      _currentAnimal.emoji,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Drop the food here 🍽️",
                      style: TextStyle(fontSize: 16)),
                ],
              );
            },
          ),
          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: foodChoices.map((food) {
              return Draggable<String>(
                data: food,
                feedback: Material(
                  color: Colors.transparent,
                  child: Text(food, style: const TextStyle(fontSize: 48)),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Text(food, style: const TextStyle(fontSize: 40)),
                ),
                child: Text(food, style: const TextStyle(fontSize: 40)),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          Text("⭐ Score: $_score", style: const TextStyle(fontSize: 20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: LinearProgressIndicator(
              value: _round / 10,
              minHeight: 8,
              color: Colors.green,
              backgroundColor: Colors.green[100],
            ),
          ),
        ],
      ),
    );
  }
}
