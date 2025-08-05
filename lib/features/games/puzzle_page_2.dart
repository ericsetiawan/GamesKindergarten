// import 'package:flutter/material.dart';
// import 'dart:math';

// class ImagePuzzleGamePage extends StatefulWidget {
//   const ImagePuzzleGamePage({super.key});

//   @override
//   State<ImagePuzzleGamePage> createState() => _ImagePuzzleGamePageState();
// }

// class _ImagePuzzleGamePageState extends State<ImagePuzzleGamePage> {
//   int currentLevel = 1;
//   static const int maxLevel = 10;

//   late List<int> targetOrder;
//   List<int> shuffled = [];
//   final Map<int, bool> matched = {};
//   int? wrongDropTarget;

//   @override
//   void initState() {
//     super.initState();
//     _generateLevel();
//   }

//   void _generateLevel() {
//     final count = currentLevel + 2; // Level 1 = 3 numbers, Level 2 = 4, etc.
//     targetOrder = List.generate(count, (i) => i + 1);
//     shuffled = List.from(targetOrder);
//     shuffled.shuffle(Random());
//     matched.clear();
//     wrongDropTarget = null;
//     setState(() {});
//   }

//   void _checkIfCompleted() {
//     if (matched.length == targetOrder.length && matched.values.every((v) => v)) {
//       final isLastLevel = currentLevel >= maxLevel;

//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//           backgroundColor: Colors.yellow[100],
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "🎉 Yay! 🎉",
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.deepPurple,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   isLastLevel
//                       ? "You’ve completed all levels like a champ! 🏆 Let’s return to the main page!"
//                       : "You finished Level $currentLevel! Ready for Level ${currentLevel + 1}? 💪",
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton.icon(
//                   icon: Icon(isLastLevel ? Icons.home : Icons.arrow_forward),
//                   label: Text(
//                     isLastLevel ? "Back to Home" : "Next to Level ${currentLevel + 1}",
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();

//                     if (isLastLevel) {
//                       Navigator.of(context).pop();
//                     } else {
//                       setState(() {
//                         currentLevel++;
//                         _generateLevel();
//                       });
//                     }
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("🧩 Puzzle Game - Level $currentLevel"),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             const Text(
//               "Drag the numbers to the correct spots!",
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 24),
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: targetOrder.map((target) {
//                 final isCorrect = matched[target] == true;
//                 final isWrong = wrongDropTarget == target;

//                 return DragTarget<int>(
//                   builder: (context, candidateData, rejectedData) {
//                     return AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       height: 80,
//                       width: 80,
//                       decoration: BoxDecoration(
//                         color: isCorrect
//                             ? Colors.green
//                             : isWrong
//                                 ? Colors.redAccent
//                                 : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         isCorrect ? "$target" : "?",
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   },
//                   onAccept: (received) {
//                     setState(() {
//                       if (received == target) {
//                         matched[target] = true;
//                         wrongDropTarget = null;
//                         _checkIfCompleted();
//                       } else {
//                         wrongDropTarget = target;
//                       }
//                     });
//                   },
//                   onWillAccept: (data) => true,
//                   onLeave: (data) {
//                     setState(() {
//                       wrongDropTarget = null;
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 32),
//             Wrap(
//               spacing: 12,
//               children: shuffled.map((number) {
//                 return Draggable<int>(
//                   data: number,
//                   feedback: _buildNumberBox(number, isDragging: true),
//                   childWhenDragging: _buildNumberBox(number,
//                       isDragging: false, transparent: true),
//                   child: matched[number] == true
//                       ? const SizedBox(width: 60)
//                       : _buildNumberBox(number),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNumberBox(int number,
//       {bool isDragging = false, bool transparent = false}) {
//     return Opacity(
//       opacity: transparent ? 0.3 : 1,
//       child: Container(
//         height: 60,
//         width: 60,
//         decoration: BoxDecoration(
//           color: isDragging ? Colors.blueAccent : Colors.lightBlueAccent,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.blue),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           "$number",
//           style: const TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }