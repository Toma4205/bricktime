import 'package:firebase_database/firebase_database.dart';


void init_db_teams(){
  FirebaseDatabase.instance.reference().child('teams').child('AHAWKS').set(
  {
    'city': 'Atlanta',
    'name': 'Hawks',
    'conference': 'East',
  });

  FirebaseDatabase.instance.reference().child('teams').child('BCELTICS').set(
  {
    'city': 'Boston',
    'name': 'Celtics',
    'conference': 'East',
  });

  FirebaseDatabase.instance.reference().child('teams').child('BNETS').set(
      {
        'city': 'Brooklyn',
        'name': 'Nets',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('CHORNETS').set(
      {
        'city': 'Charlotte',
        'name': 'Hornets',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('CBULLS').set(
      {
        'city': 'Chicago',
        'name': 'Bulls',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('CCAVALIERS').set(
      {
        'city': 'Cleveland',
        'name': 'Cavaliers',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('DMAVERICKS').set(
      {
        'city': 'Dallas',
        'name': 'Mavericks',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('DNUGGETS').set(
      {
        'city': 'Denver',
        'name': 'Nuggets',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('DPISTONS').set(
      {
        'city': 'Detroit',
        'name': 'Pistons',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('GWARRIORS').set(
      {
        'city': 'Golden State',
        'name': 'Warriors',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('HROCKETS').set(
      {
        'city': 'Houston',
        'name': 'Rockets',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('IPACERS').set(
      {
        'city': 'Indiana',
        'name': 'Pacers',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('LCLIPPERS').set(
      {
        'city': 'Los Angeles',
        'name': 'Clippers',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('LLAKERS').set(
      {
        'city': 'Los Angeles',
        'name': 'Lakers',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('MGRIZZLIES').set(
      {
        'city': 'Memphis',
        'name': 'Grizzlies',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('MHEAT').set(
      {
        'city': 'Miami',
        'name': 'Heat',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('MBUCKS').set(
      {
        'city': 'Milwaukee',
        'name': 'Bucks',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('MTIMBERWOLVES').set(
      {
        'city': 'Minnesota',
        'name': 'Timberwolves',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('NPELICANS').set(
      {
        'city': 'New Orleans',
        'name': 'Pelicans',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('NKNICKS').set(
      {
        'city': 'New York',
        'name': 'Knicks',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('OTHUNDER').set(
      {
        'city': 'Oklahoma City',
        'name': 'Thunder',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('OMAGIC').set(
      {
        'city': 'Orlando',
        'name': 'Magic',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('P76ERS').set(
      {
        'city': 'Philadelphia',
        'name': '76ers',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('PSUNS').set(
      {
        'city': 'Phoenix',
        'name': 'Suns',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('PBLAZERS').set(
      {
        'city': 'Portland Trail',
        'name': 'Blazers',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('SKINGS').set(
      {
        'city': 'Sacramento',
        'name': 'Kings',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('SSPURS').set(
      {
        'city': 'San Antonio',
        'name': 'Spurs',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('TRAPTORS').set(
      {
        'city': 'Toronto',
        'name': 'Raptors',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('UJAZZ').set(
      {
        'city': 'Utah',
        'name': 'Jazz',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('WWIZARDS').set(
      {
        'city': 'Washington',
        'name': 'Wizards',
        'conference': 'East',
      });
}

void init_db_rules(){
  FirebaseDatabase.instance.reference().child('rules').child('playoffspredictions').child('firstround').set(
      {
        'perfect': 4,
        'good': 2,
      });

  FirebaseDatabase.instance.reference().child('rules').child('playoffspredictions').child('confsemifinal').set(
      {
        'perfect': 5,
        'good': 3,
      });

  FirebaseDatabase.instance.reference().child('rules').child('playoffspredictions').child('conffinal').set(
      {
        'perfect': 8,
        'good': 5,
      });

  FirebaseDatabase.instance.reference().child('rules').child('playoffspredictions').child('final').set(
      {
        'perfect': 12,
        'good': 8,
      });

}

void init_db_results_2019(){
  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('firstround').child('ESerie1').set(
      {
        'teamA': 'MBUCKS',
        'teamB': 'DPISTONS',
        'winA': 4,
        'winB': 0,
        'date_first_game': DateTime(2019,4,15,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('firstround').child('ESerie2').set(
      {
        'teamA': 'CBOSTON',
        'teamB': 'IPACERS',
        'winA': 4,
        'winB': 0,
        'date_first_game': DateTime(2019,4,15,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('firstround').child('ESerie3').set(
      {
        'teamA': 'P76ERS',
        'teamB': 'BNETS',
        'winA': 4,
        'winB': 1,
        'date_first_game': DateTime(2019,4,15,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('firstround').child('ESerie4').set(
      {
        'teamA': 'TRAPTORS',
        'teamB': 'OMAGIC',
        'winA': 4,
        'winB': 1,
        'date_first_game': DateTime(2019,4,15,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('firstround').child('WSerie1').set(
      {
        'teamA': 'GWARRIOS',
        'teamB': 'LCLIPPERS',
        'winA': 4,
        'winB': 2,
        'date_first_game': DateTime(2019,4,15,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('firstround').child('WSerie2').set(
      {
        'teamA': 'HROCKETS',
        'teamB': 'UJAZZ',
        'winA': 4,
        'winB': 1,
        'date_first_game': DateTime(2019,4,15,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('firstround').child('WSerie3').set(
      {
        'teamA': 'PBLAZERS',
        'teamB': 'OTHUNDER',
        'winA': 4,
        'winB': 1,
        'date_first_game': DateTime(2019,4,15,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('firstround').child('WSerie4').set(
      {
        'teamA': 'DNUGGETS',
        'teamB': 'SSPURS',
        'winA': 4,
        'winB': 3,
        'date_first_game': DateTime(2019,4,15,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('confsemifinal').child('ESerie1').set(
      {
        'teamA': 'MBUCKS',
        'teamB': 'BCELTICS',
        'winA': 4,
        'winB': 1,
        'date_first_game': DateTime(2019,4,28,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('confsemifinal').child('ESerie2').set(
      {
        'teamA': 'P76ERS',
        'teamB': 'TRAPTORS',
        'winA': 3,
        'winB': 4,
        'date_first_game': DateTime(2019,4,28,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('confsemifinal').child('WSerie1').set(
      {
        'teamA': 'GWARRIORS',
        'teamB': 'HROCKETS',
        'winA': 4,
        'winB': 2,
        'date_first_game': DateTime(2019,4,28,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('confsemifinal').child('WSerie2').set(
      {
        'teamA': 'PBLAZERS',
        'teamB': 'DNUGGETS',
        'winA': 4,
        'winB': 3,
        'date_first_game': DateTime(2019,4,28,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('conffinal').child('ESerie1').set(
      {
        'teamA': 'MBUCKS',
        'teamB': 'TRAPTORS',
        'winA': 2,
        'winB': 4,
        'date_first_game': DateTime(2019,5,14,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('conffinal').child('WSerie1').set(
      {
        'teamA': 'GWARRIORS',
        'teamB': 'PBLAZERS',
        'winA': 4,
        'winB': 0,
        'date_first_game': DateTime(2019,5,14,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('results').child('2019playoffs').child('final').child('Serie1').set(
      {
        'teamA': 'TRAPTORS',
        'teamB': 'GWARRIORS',
        'winA': 4,
        'winB': 2,
        'date_first_game': DateTime(2019,5,30,1,0).toString(),
      });

}

void init_db_user(){
  FirebaseDatabase.instance.reference().child('users').child('RANDOMID').child('pronostics').child('2019playoffs').child('final').child('Serie1').set(
      {
        'winA': 4,
        'winB': 0,
        'date_prono': DateTime(2019,4,15,1,0).toString(),
      });

  FirebaseDatabase.instance.reference().child('users').child('RANDOMID').child('infos').set(
      {
        'pseudo': 'random_pseudo',
        'level' : 'allstar',
        'inscription_date': DateTime(1987,2,11).toString(),
        'last_connexion': DateTime(2019,4,15,1,0).toString(),
      });
}


void init_db_constantes(){
  FirebaseDatabase.instance.reference().child('constantes').update(
      {
        'year_actual_playoff': 2019,
      });
}