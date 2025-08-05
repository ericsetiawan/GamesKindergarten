import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_quest/features/home/models/game_model.dart';
import 'home_state.dart';
import 'package:flutter/material.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void loadGames() {
    emit(state.copyWith(
      games: [
        // GameModel(title: 'Puzzle', icon: Icons.extension, color: Colors.orange),
        GameModel(title: 'Puzzle', icon: Icons.extension, color: Colors.orange),
        GameModel(title: 'Math Game', icon: Icons.calculate, color: Colors.green ),
        GameModel(title: 'Guess the Picture', icon: Icons.image, color: Colors.purple),
        GameModel(title: 'Memory Game', icon: Icons.psychology, color: Colors.pink),    
        GameModel(title: 'Guess the Color', icon: Icons.color_lens, color: Colors.teal),
        GameModel(title: 'Feed the Animal', icon: Icons.pets, color: Colors.brown),
      ],
    ));
  }
}