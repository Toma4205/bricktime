import 'package:bricktime/model/user.dart';


class Confrontation {
  final String id;
  final String domicile;
  final String domicile_name;
  final String exterieur;
  final String exterieur_name;
  final DateTime start_date_time;

  Confrontation({this.id, this.domicile, this.domicile_name, this.exterieur, this.exterieur_name, this.start_date_time});
}
