import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {
  final int index;
  const OnboardingContent({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final texts = [
      "🎈 Hello, Explorer! 🎉\nLet’s begin a magical adventure full of surprises!",
      "🧠 Learn & Play! 🕹️\nPlay fun games and become a little genius!",
      "🌟 You’re a Star! 🚀\nLet’s jump into fun and start your journey!",
    ];

    final images = [
      "assets/images/a.jfif",
      "assets/images/b.jfif",
      "assets/images/e.jfif",
    ];

    final colors = [
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.tealAccent,
    ];

    final alignments = [
      Alignment.topCenter,
      Alignment.center,
      Alignment.bottomCenter,
    ];

    final paddings = [
      const EdgeInsets.only(top: 100.0, left: 24, right: 24),
      const EdgeInsets.symmetric(horizontal: 24),
      const EdgeInsets.only(bottom: 120.0, left: 24, right: 24),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            images[index],
            fit: BoxFit.cover,
          ),
        ),

        Container(
          color: Colors.black.withOpacity(0.4),
        ),

        Align(
          alignment: alignments[index],
          child: Padding(
            padding: paddings[index],
            child: Text(
              texts[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: colors[index],
                height: 1.5,
                fontFamily: 'ComicNeue',
                shadows: const [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black87,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}