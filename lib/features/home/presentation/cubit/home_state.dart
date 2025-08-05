import 'package:kinder_quest/features/home/models/game_model.dart';


class HomeState {
  final List<GameModel> games;

  HomeState({required this.games});

  factory HomeState.initial() => HomeState(games: []);

  HomeState copyWith({List<GameModel>? games}) {
    return HomeState(games: games ?? this.games);
  }
}