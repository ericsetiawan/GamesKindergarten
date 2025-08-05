import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FinalPopup extends StatefulWidget {
  final int totalCorrect;
  final int totalQuestions;
  final VoidCallback onBackToHome;

  const FinalPopup({
    super.key,
    required this.totalCorrect,
    required this.totalQuestions,
    required this.onBackToHome,
  });

  @override
  State<FinalPopup> createState() => _FinalPopupState();
}

class _FinalPopupState extends State<FinalPopup> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  int getStarCount() {
    final ratio = widget.totalCorrect / widget.totalQuestions;
    if (ratio >= 0.9) return 3;
    if (ratio >= 0.6) return 2;
    if (ratio >= 0.3) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final starCount = getStarCount();
    final progress = widget.totalCorrect / widget.totalQuestions;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/lottie/succes.json', height: 130),
            const SizedBox(height: 10),
            const Text(
              '🎉 Great Job!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'You answered ${widget.totalCorrect} out of ${widget.totalQuestions} correctly!',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < starCount ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 28,
                );
              }),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              color: Colors.green,
              backgroundColor: Colors.grey[300],
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: widget.onBackToHome,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('Back to Home', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}