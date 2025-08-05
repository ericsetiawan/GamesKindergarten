import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kinder_quest/core/widgets/bounce_animate.dart';
import 'package:kinder_quest/features/games/feed_animal_page.dart.dart';
import 'package:kinder_quest/features/games/guess_color_page.dart';
import 'package:kinder_quest/features/games/guess_picture.dart';
import 'package:kinder_quest/features/games/memory_game_page.dart';
import 'package:kinder_quest/features/games/number_game.dart';
import 'package:kinder_quest/features/games/puzzle_page.dart';
import 'package:kinder_quest/features/home/models/game_model.dart';
import 'package:kinder_quest/features/home/presentation/cubit/home_cubit.dart';
import 'package:kinder_quest/features/home/presentation/cubit/home_state.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  double _offsetX = 0.0;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _handleGameTap(BuildContext context, GameModel game) {
    switch (game.title) {
      case "Puzzle":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PuzzleGamePage()));
        break;
      case "Math Game":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MathImageGamePage()));
        break;
      case "Guess the Picture":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GuessPictureGamePage()));
        break;
      case "Memory Game":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MemoryGamePage()));
        break;
      case "Guess the Color":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GuessColorPage()));
        break;
      case "Feed the Animal":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedTheAnimalPage()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Oops! "${game.title}" is not available yet 😅'),
            backgroundColor: Colors.orangeAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadGames(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/home4.jfif"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _offsetX += details.delta.dx;
                      });
                    },
                    onHorizontalDragEnd: (_) {
                      setState(() {
                        _offsetX = 0;
                      });
                    },
                    child: Transform.translate(
                      offset: Offset(_offsetX, 0),
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/home-animated.json',
                          height: 180,
                          controller: _lottieController,
                          onLoaded: (composition) {
                            _lottieController
                              ..duration = composition.duration
                              ..repeat(reverse: true);
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      "Choose Your Adventure! ⚔️",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.baloo2(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                        shadows: const [
                          Shadow(
                            offset: Offset(3, 5),
                            blurRadius: 6,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.games.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final game = state.games[index];
                          return BounceWidget(
                            onTap: () => _handleGameTap(context, game),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.85, end: 1),
                              duration: Duration(milliseconds: 500 + (index * 100)),
                              curve: Curves.elasticOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: _buildGameCard(game),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/avatar.jfif'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, Buddy!",
                  style: GoogleFonts.baloo2(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 2),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Ready to play? 🎮",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.w500,
                    shadows: const [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGameCard(GameModel game) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [game.color.withOpacity(0.3), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: game.color.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: game.color.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(game.icon, size: 58, color: game.color),
          const SizedBox(height: 10),
          Text(
            game.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: game.color,
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                  color: game.color.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}