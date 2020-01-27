import 'package:bricktime/model/player.dart';
import 'package:bricktime/model/user.dart';

class Squad {
  final String id;
  final User owner;
  List<Player> players;
  List<Player> starters;
  List<Player> subs;
  List<Player> waterboys;
  List<int> minutes_per_position; //0 : 24 , 1 : 28,  2: 32, 3 : 36,
  String strategy_selected;
  List<String> strategy_played;
  String id_bonus_player;
  int num_poste_bonus_player;
  String game_plan;



  Squad({this.id, this.owner, this.players, this.starters, this.strategy_selected, this.strategy_played, this.waterboys, this.id_bonus_player, this.num_poste_bonus_player, this.game_plan,});


}
