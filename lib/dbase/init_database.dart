import 'package:firebase_database/firebase_database.dart';


void init_db_teams(){
  FirebaseDatabase.instance.reference().child('teams').child('AHAWKS').update(
  {
    'city': 'Atlanta',
    'name': 'Hawks',
    'conference': 'East',
  });

  FirebaseDatabase.instance.reference().child('teams').child('BCELTICS').update(
  {
    'city': 'Boston',
    'name': 'Celtics',
    'conference': 'East',
  });

  FirebaseDatabase.instance.reference().child('teams').child('BNETS').update(
      {
        'city': 'Brooklyn',
        'name': 'Nets',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('CHORNETS').update(
      {
        'city': 'Charlotte',
        'name': 'Hornets',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('CBULLS').update(
      {
        'city': 'Chicago',
        'name': 'Bulls',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('CCAVALIERS').update(
      {
        'city': 'Cleveland',
        'name': 'Cavaliers',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('DMAVERICKS').update(
      {
        'city': 'Dallas',
        'name': 'Mavericks',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('DNUGGETS').update(
      {
        'city': 'Denver',
        'name': 'Nuggets',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('DPISTONS').update(
      {
        'city': 'Detroit',
        'name': 'Pistons',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('GWARRIORS').update(
      {
        'city': 'Golden State',
        'name': 'Warriors',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('HROCKETS').update(
      {
        'city': 'Houston',
        'name': 'Rockets',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('IPACERS').update(
      {
        'city': 'Indiana',
        'name': 'Pacers',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('LCLIPPERS').update(
      {
        'city': 'Los Angeles',
        'name': 'Clippers',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('LLAKERS').update(
      {
        'city': 'Los Angeles',
        'name': 'Lakers',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('MGRIZZLIES').update(
      {
        'city': 'Memphis',
        'name': 'Grizzlies',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('MHEAT').update(
      {
        'city': 'Miami',
        'name': 'Heat',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('MBUCKS').update(
      {
        'city': 'Milwaukee',
        'name': 'Bucks',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('MTIMBERWOLVES').update(
      {
        'city': 'Minnesota',
        'name': 'Timberwolves',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('NPELICANS').update(
      {
        'city': 'New Orleans',
        'name': 'Pelicans',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('NKNICKS').update(
      {
        'city': 'New York',
        'name': 'Knicks',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('OTHUNDER').update(
      {
        'city': 'Oklahoma City',
        'name': 'Thunder',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('OMAGIC').update(
      {
        'city': 'Orlando',
        'name': 'Magic',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('P76ERS').update(
      {
        'city': 'Philadelphia',
        'name': '76ers',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('PSUNS').update(
      {
        'city': 'Phoenix',
        'name': 'Suns',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('PBLAZERS').update(
      {
        'city': 'Portland Trail',
        'name': 'Blazers',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('SKINGS').update(
      {
        'city': 'Sacramento',
        'name': 'Kings',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('SSPURS').update(
      {
        'city': 'San Antonio',
        'name': 'Spurs',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('TRAPTORS').update(
      {
        'city': 'Toronto',
        'name': 'Raptors',
        'conference': 'East',
      });

  FirebaseDatabase.instance.reference().child('teams').child('UJAZZ').update(
      {
        'city': 'Utah',
        'name': 'Jazz',
        'conference': 'West',
      });

  FirebaseDatabase.instance.reference().child('teams').child('WWIZARDS').update(
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

  FirebaseDatabase.instance.reference().child('constantes').update(
      {
        'is_competition_in_progress': false,
      });
}

void init_db_players(){
  FirebaseDatabase.instance.reference().child('api').child('players').child('666543').update({'first_name':'Sekou','last_name':'Doumbouya','position':'F','team_id':'DPISTONS','price':10,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('330').update({'first_name':'Monte','last_name':'Morris','position':'G','team_id':'DNUGGETS','price':5,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('220').update({'first_name':'Dwight','last_name':'Howard','position':'C','team_id':'LLAKERS','price':17,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666848').update({'first_name':'Jordan','last_name':'Poole','position':'G','team_id':'GWARRIORS','price':6,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666626').update({'first_name':'Jaxson','last_name':'Hayes','position':'C','team_id':'NPELICANS','price':15,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('110').update({'first_name':'Torrey','last_name':'Craig','position':'F','team_id':'DNUGGETS','price':6,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666630').update({'first_name':'Dewan','last_name':'Hernandez','position':'C','team_id':'TRAPTORS','price':3,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('444').update({'first_name':'Tristan','last_name':'Thompson','position':'C-F','team_id':'CCAVALIERS','price':56,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666963').update({'first_name':'Nigel','last_name':'Williams-Goss','position':'G','team_id':'UJAZZ','price':5,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('333').update({'first_name':'Emmanuel','last_name':'Mudiay','position':'G','team_id':'UJAZZ','price':6,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('222').update({'first_name':'Chandler','last_name':'Hutchison','position':'F','team_id':'CBULLS','price':7,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('112').update({'first_name':'Jae','last_name':'Crowder','position':'F','team_id':'MGRIZZLIES','price':24,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('334').update({'first_name':'Dejounte','last_name':'Murray','position':'G','team_id':'SSPURS','price':7,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666679').update({'first_name':'Cameron','last_name':'Johnson','position':'F','team_id':'PSUNS','price':13,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('223').update({'first_name':'Serge','last_name':'Ibaka','position':'F-C','team_id':'TRAPTORS','price':70,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666824').update({'first_name':'Miye','last_name':'Oni','position':'G','team_id':'UJAZZ','price':3,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('446').update({'first_name':'Anthony','last_name':'Tolliver','position':'F','team_id':'PBLAZERS','price':8,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('335').update({'first_name':'Jamal','last_name':'Murray','position':'G','team_id':'DNUGGETS','price':14,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('191').update({'first_name':'Tim','last_name':'Hardaway Jr.','position':'G','team_id':'DMAVERICKS','price':60,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('114').update({'first_name':'Seth','last_name':'Curry','position':'G','team_id':'DMAVERICKS','price':23,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666429').update({'first_name':'Darius','last_name':'Bazley','position':'F','team_id':'OTHUNDER','price':7,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('447').update({'first_name':'Karl-Anthony','last_name':'Towns','position':'C','team_id':'MTIMBERWOLVES','price':82,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('81').update({'first_name':'Kentavious','last_name':'Caldwell-Pope','position':'G','team_id':'LLAKERS','price':25,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('336').update({'first_name':'Dzanan','last_name':'Musa','position':'G-F','team_id':'BNETS','price':6,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('225').update({'first_name':'Ersan','last_name':'Ilyasova','position':'F','team_id':'MBUCKS','price':21,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('192').update({'first_name':'James','last_name':'Harden','position':'G','team_id':'HROCKETS','price':114,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('337').update({'first_name':'Mike','last_name':'Muscala','position':'F-C','team_id':'OTHUNDER','price':7,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('226').update({'first_name':'Joe','last_name':'Ingles','position':'F','team_id':'UJAZZ','price':35,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('83').update({'first_name':'Clint','last_name':'Capela','position':'C','team_id':'HROCKETS','price':51,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('193').update({'first_name':'Maurice','last_name':'Harkless','position':'F','team_id':'LCLIPPERS','price':33,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('116').update({'first_name':'Troy','last_name':'Daniels','position':'G','team_id':'LLAKERS','price':7,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('84').update({'first_name':'DeMarre','last_name':'Carroll','position':'F','team_id':'SSPURS','price':21,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('449').update({'first_name':'Allonzo','last_name':'Trier','position':'G','team_id':'NKNICKS','price':11,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('338').update({'first_name':'Svi','last_name':'Mykhailiuk','position':'G','team_id':'DPISTONS','price':5,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('227').update({'first_name':'Brandon','last_name':'Ingram','position':'F','team_id':'NPELICANS','price':22,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('85').update({'first_name':'Wendell','last_name':'Carter Jr.','position':'F','team_id':'CBULLS','price':16,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('194').update({'first_name':'Montrezl','last_name':'Harrell','position':'F-C','team_id':'LCLIPPERS','price':18,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('117').update({'first_name':'Anthony','last_name':'Davis','position':'F-C','team_id':'LLAKERS','price':81,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666849').update({'first_name':'Kevin','last_name':'Porter Jr.','position':'G','team_id':'CCAVALIERS','price':4,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('339').update({'first_name':'Abdel','last_name':'Nader','position':'F','team_id':'OTHUNDER','price':5,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('87').update({'first_name':'Jevon','last_name':'Carter','position':'G','team_id':'PSUNS','price':5,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('118').update({'first_name':'Ed','last_name':'Davis','position':'C','team_id':'UJAZZ','price':15,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('229').update({'first_name':'Jonathan','last_name':'Isaac','position':'F','team_id':'OMAGIC','price':18,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('88').update({'first_name':'Vince','last_name':'Carter','position':'F-G','team_id':'AHAWKS','price':8,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('89').update({'first_name':'Alex','last_name':'Caruso','position':'G','team_id':'LLAKERS','price':9,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('196').update({'first_name':'Gary','last_name':'Harris','position':'G','team_id':'DNUGGETS','price':54,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('197').update({'first_name':'Joe','last_name':'Harris','position':'F-G','team_id':'BNETS','price':23,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666940').update({'first_name':'Dean','last_name':'Wade','position':'F','team_id':'CCAVALIERS','price':1,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('199').update({'first_name':'Shaquille','last_name':'Harrison','position':'G','team_id':'CBULLS','price':5,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666908').update({'first_name':'Max','last_name':'Strus','position':'G','team_id':'CBULLS','price':1,});
  FirebaseDatabase.instance.reference().child('api').child('players').child('666656').update({'first_name':"De'Andre",'last_name':'Hunter','position':'F','team_id':'AHAWKS','price':22,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('450').update({'first_name':'PJ','last_name':'Tucker','position':'F','team_id':'HROCKETS','price':25,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('340').update({'first_name':'Larry','last_name':'Nance Jr.','position':'F','team_id':'CCAVALIERS','price':38,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('451').update({'first_name':'Evan','last_name':'Turner','position':'G-F','team_id':'AHAWKS','price':56,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666517').update({'first_name':'Tyler','last_name':'Cook','position':'C','team_id':'CCAVALIERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('341').update({'first_name':'Shabazz','last_name':'Napier','position':'G','team_id':'MTIMBERWOLVES','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('230').update({'first_name':'Wes','last_name':'Iwundu','position':'F','team_id':'OMAGIC','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('452').update({'first_name':'Myles','last_name':'Turner','position':'C-F','team_id':'IPACERS','price':54,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('30').update({'first_name':'Harrison','last_name':'Barnes','position':'F','team_id':'SKINGS','price':73,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('31').update({'first_name':'Will','last_name':'Barton','position':'G','team_id':'DNUGGETS','price':39,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('231').update({'first_name':'Jaren','last_name':'Jackson Jr.','position':'F-C','team_id':'MGRIZZLIES','price':21,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2215').update({'first_name':'Malcolm','last_name':'Miller','position':'F','team_id':'TRAPTORS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666965').update({'first_name':'Grant','last_name':'Williams','position':'F','team_id':'BCELTICS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('120').update({'first_name':'Dewayne','last_name':'Dedmon','position':'C','team_id':'SKINGS','price':40,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666743').update({'first_name':'Terance','last_name':'Mann','position':'G','team_id':'LCLIPPERS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('32').update({'first_name':'Keita','last_name':'Bates-Diop','position':'F','team_id':'MTIMBERWOLVES','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('33').update({'first_name':'Nicolas','last_name':'Batum','position':'F-G','team_id':'CHORNETS','price':77,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('343').update({'first_name':'Raul','last_name':'Neto','position':'G','team_id':'P76ERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666459').update({'first_name':'Brian','last_name':'Bowen II','position':'F','team_id':'IPACERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('35').update({'first_name':'Aron','last_name':'Baynes','position':'C-F','team_id':'PSUNS','price':17,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('344').update({'first_name':'Georges','last_name':'Niang','position':'F','team_id':'UJAZZ','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666604').update({'first_name':'Javonte','last_name':'Green','position':'G-F','team_id':'BCELTICS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2216').update({'first_name':'Kadeem','last_name':'Allen','position':'G','team_id':'NKNICKS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('233').update({'first_name':'Frank','last_name':'Jackson','position':'G','team_id':'NPELICANS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('36').update({'first_name':'Kent','last_name':'Bazemore','position':'G','team_id':'PBLAZERS','price':58,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2225').update({'first_name':'Josh','last_name':'Gray','position':'G','team_id':'NPELICANS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('455').update({'first_name':'Jonas','last_name':'Valanciunas','position':'C','team_id':'MGRIZZLIES','price':48,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('37').update({'first_name':'Bradley','last_name':'Beal','position':'G','team_id':'WWIZARDS','price':81,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('345').update({'first_name':'Nerlens','last_name':'Noel','position':'F-C','team_id':'OTHUNDER','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('123').update({'first_name':'Matthew','last_name':'Dellavedova','position':'G','team_id':'CCAVALIERS','price':29,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('456').update({'first_name':'Denzel','last_name':'Valentine','position':'G','team_id':'CBULLS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2208').update({'first_name':'Derrick','last_name':'Walton Jr.','position':'G','team_id':'LCLIPPERS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('38').update({'first_name':'Malik','last_name':'Beasley','position':'G','team_id':'DNUGGETS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('235').update({'first_name':'Justin','last_name':'Jackson','position':'F','team_id':'DMAVERICKS','price':10,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('347').update({'first_name':'Frank','last_name':'Ntilikina','position':'G','team_id':'NKNICKS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('125').update({'first_name':'DeMar','last_name':'DeRozan','position':'G','team_id':'SSPURS','price':83,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('458').update({'first_name':'Fred','last_name':'VanVleet','position':'G','team_id':'TRAPTORS','price':28,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('237').update({'first_name':'LeBron','last_name':'James','position':'F','team_id':'LLAKERS','price':112,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('459').update({'first_name':'Noah','last_name':'Vonleh','position':'F','team_id':'MTIMBERWOLVES','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('238').update({'first_name':'Amile','last_name':'Jefferson','position':'F','team_id':'OMAGIC','price':4,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('127').update({'first_name':'Cheick','last_name':'Diallo','position':'F','team_id':'PSUNS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666633').update({'first_name':'Tyler','last_name':'Herro','position':'G','team_id':'MHEAT','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('128').update({'first_name':'Hamidou','last_name':'Diallo','position':'G','team_id':'OTHUNDER','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('129').update({'first_name':'Gorgui','last_name':'Dieng','position':'C','team_id':'MTIMBERWOLVES','price':49,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666464').update({'first_name':'Ignas','last_name':'Brazdeikis','position':'F','team_id':'NKNICKS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666831').update({'first_name':'Eric','last_name':'Paschall','position':'F','team_id':'GWARRIORS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('91').update({'first_name':'Willie','last_name':'Cauley-Stein','position':'C','team_id':'GWARRIORS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('460').update({'first_name':'Nikola','last_name':'Vucevic','position':'C','team_id':'OMAGIC','price':84,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('94').update({'first_name':'Tyson','last_name':'Chandler','position':'C','team_id':'HROCKETS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666551').update({'first_name':'Carsen','last_name':'Edwards','position':'G','team_id':'BCELTICS','price':4,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('350').update({'first_name':'David','last_name':'Nwaba','position':'G','team_id':'BNETS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('97').update({'first_name':'Marquese','last_name':'Chriss','position':'F','team_id':'GWARRIORS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('240').update({'first_name':'Alize','last_name':'Johnson','position':'F','team_id':'IPACERS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666523').update({'first_name':'Jarrett','last_name':'Culver','position':'G','team_id':'MTIMBERWOLVES','price':18,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('462').update({'first_name':'Moritz','last_name':'Wagner','position':'C','team_id':'WWIZARDS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('98').update({'first_name':'Gary','last_name':'Clark','position':'F','team_id':'HROCKETS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('351').update({'first_name':'Royce','last_name':"O'Neale",'position':'F','team_id':'UJAZZ','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('130').update({'first_name':'Spencer','last_name':'Dinwiddie','position':'G','team_id':'BNETS','price':32,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666860').update({'first_name':'Cameron','last_name':'Reddish','position':'F-G','team_id':'AHAWKS','price':13,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2080').update({'first_name':'JaKarr','last_name':'Sampson','position':'F-G','team_id':'IPACERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('352').update({'first_name':'Kyle','last_name':"O'Quinn",'position':'C','team_id':'P76ERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('242').update({'first_name':'James','last_name':'Johnson','position':'F','team_id':'MHEAT','price':46,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('131').update({'first_name':'Donte','last_name':'DiVincenzo','position':'G','team_id':'MBUCKS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('464').update({'first_name':'Lonnie','last_name':'Walker IV','position':'G','team_id':'SSPURS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('353').update({'first_name':'Semi','last_name':'Ojeleye','position':'F','team_id':'BCELTICS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2148').update({'first_name':'Thanasis','last_name':'Antetokounmpo','position':'F','team_id':'MBUCKS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666610').update({'first_name':'Devon','last_name':'Hall','position':'G','team_id':'OTHUNDER','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('132').update({'first_name':'Luka','last_name':'Doncic','position':'F-G','team_id':'DMAVERICKS','price':23,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('465').update({'first_name':'Kemba','last_name':'Walker','position':'G','team_id':'BCELTICS','price':98,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('354').update({'first_name':'Jahlil','last_name':'Okafor','position':'C','team_id':'NPELICANS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('50661').update({'first_name':'Chris','last_name':'Chiozza','position':'G','team_id':'WWIZARDS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2175').update({'first_name':'Danuel','last_name':'House Jr.','position':'F-G','team_id':'HROCKETS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('244').update({'first_name':'Tyler','last_name':'Johnson','position':'G','team_id':'PSUNS','price':58,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('466').update({'first_name':'Tyrone','last_name':'Wallace','position':'G','team_id':'AHAWKS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('355').update({'first_name':'Elie','last_name':'Okobo','position':'G','team_id':'PSUNS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('134').update({'first_name':'Damyean','last_name':'Dotson','position':'G','team_id':'NKNICKS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('356').update({'first_name':'Josh','last_name':'Okogie','position':'G','team_id':'MTIMBERWOLVES','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666885').update({'first_name':'Admiral','last_name':'Schofield','position':'F','team_id':'WWIZARDS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('246').update({'first_name':'Nikola','last_name':'Jokic','position':'C','team_id':'DNUGGETS','price':83,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('468').update({'first_name':'Brad','last_name':'Wanamaker','position':'G','team_id':'BCELTICS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('357').update({'first_name':'Victor','last_name':'Oladipo','position':'G','team_id':'IPACERS','price':63,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('667378').update({'first_name':'Naz','last_name':'Reid','position':'F-C','team_id':'MTIMBERWOLVES','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('40').update({'first_name':'Marco','last_name':'Belinelli','position':'G-F','team_id':'SSPURS','price':18,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2194').update({'first_name':'Josh','last_name':'Magette','position':'G','team_id':'OMAGIC','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('247').update({'first_name':'Derrick','last_name':'Jones Jr.','position':'F-G','team_id':'MHEAT','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('3091').update({'first_name':'Brandon','last_name':'Goodwin','position':'G','team_id':'AHAWKS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('41').update({'first_name':'Jordan','last_name':'Bell','position':'F','team_id':'MTIMBERWOLVES','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('136').update({'first_name':'Goran','last_name':'Dragic','position':'G','team_id':'MHEAT','price':58,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('469').update({'first_name':'T.J.','last_name':'Warren','position':'F','team_id':'IPACERS','price':33,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('358').update({'first_name':'Kelly','last_name':'Olynyk','position':'F','team_id':'MHEAT','price':38,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('42').update({'first_name':"DeAndre'",'last_name':'Bembry','position':'F','team_id':'AHAWKS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('248').update({'first_name':'Damian','last_name':'Jones','position':'C','team_id':'AHAWKS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('137').update({'first_name':'Andre','last_name':'Drummond','position':'C','team_id':'DPISTONS','price':81,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('359').update({'first_name':'Cedi','last_name':'Osman','position':'F','team_id':'CCAVALIERS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('43').update({'first_name':'Dragan','last_name':'Bender','position':'F','team_id':'MBUCKS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('44').update({'first_name':'Davis','last_name':'Bertans','position':'F','team_id':'WWIZARDS','price':21,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('249').update({'first_name':'Tyus','last_name':'Jones','position':'G','team_id':'MGRIZZLIES','price':28,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('138').update({'first_name':'Jared','last_name':'Dudley','position':'F','team_id':'LLAKERS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666607').update({'first_name':'Marko','last_name':'Guduric','position':'G','team_id':'MGRIZZLIES','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('45').update({'first_name':'Patrick','last_name':'Beverley','position':'G','team_id':'LCLIPPERS','price':37,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666577').update({'first_name':'Daniel','last_name':'Gafford','position':'F','team_id':'CBULLS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('46').update({'first_name':'Khem','last_name':'Birch','position':'C','team_id':'OMAGIC','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('139').update({'first_name':'Kris','last_name':'Dunn','position':'G','team_id':'CBULLS','price':16,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666692').update({'first_name':'Mfiondu','last_name':'Kabengele','position':'F','team_id':'LCLIPPERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666581').update({'first_name':'Darius','last_name':'Garland','position':'G','team_id':'CCAVALIERS','price':20,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('48').update({'first_name':'Bismack','last_name':'Biyombo','position':'C','team_id':'CHORNETS','price':51,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('49').update({'first_name':'Nemanja','last_name':'Bjelica','position':'F','team_id':'SKINGS','price':21,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666442').update({'first_name':'Goga','last_name':'Bitadze','position':'C','team_id':'IPACERS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('470').update({'first_name':'Yuta','last_name':'Watanabe','position':'G','team_id':'MGRIZZLIES','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('667302').update({'first_name':'Nicolo','last_name':'Melli','position':'F','team_id':'NPELICANS','price':13,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('360').update({'first_name':'Kelly','last_name':'Oubre Jr.','position':'F','team_id':'PSUNS','price':47,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('472').update({'first_name':'Russell','last_name':'Westbrook','position':'G','team_id':'HROCKETS','price':115,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666751').update({'first_name':'Kelan','last_name':'Martin','position':'F','team_id':'MTIMBERWOLVES','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('250').update({'first_name':'DeAndre','last_name':'Jordan','position':'C','team_id':'BNETS','price':30,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666608').update({'first_name':'Kyle','last_name':'Guy','position':'G','team_id':'SKINGS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('473').update({'first_name':'Derrick','last_name':'White','position':'G','team_id':'SSPURS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('362').update({'first_name':'Jabari','last_name':'Parker','position':'F','team_id':'AHAWKS','price':20,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('251').update({'first_name':'Cory','last_name':'Joseph','position':'G','team_id':'SKINGS','price':36,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('474').update({'first_name':'Hassan','last_name':'Whiteside','position':'C','team_id':'PBLAZERS','price':81,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('252').update({'first_name':'Frank','last_name':'Kaminsky','position':'F-C','team_id':'PSUNS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('475').update({'first_name':'Andrew','last_name':'Wiggins','position':'F-G','team_id':'MTIMBERWOLVES','price':83,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('364').update({'first_name':'Chandler','last_name':'Parsons','position':'F','team_id':'AHAWKS','price':75,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('253').update({'first_name':'Enes','last_name':'Kanter','position':'C','team_id':'BCELTICS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('143').update({'first_name':'Henry','last_name':'Ellenson','position':'F','team_id':'BNETS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('476').update({'first_name':'Robert','last_name':'Williams III','position':'C-F','team_id':'BCELTICS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('365').update({'first_name':'Patrick','last_name':'Patterson','position':'F','team_id':'LCLIPPERS','price':10,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('254').update({'first_name':'Luke','last_name':'Kennard','position':'G','team_id':'DPISTONS','price':12,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('3089').update({'first_name':'Gary','last_name':'Trent Jr.','position':'G','team_id':'PBLAZERS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2099').update({'first_name':'Bruno','last_name':'Caboclo','position':'F','team_id':'MGRIZZLIES','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('144').update({'first_name':'Wayne','last_name':'Ellington','position':'G','team_id':'NKNICKS','price':24,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('366').update({'first_name':'Justin','last_name':'Patton','position':'C','team_id':'OTHUNDER','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('255').update({'first_name':'Michael','last_name':'Kidd-Gilchrist','position':'F','team_id':'CHORNETS','price':39,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666891').update({'first_name':'Marial','last_name':'Shayok','position':'G','team_id':'P76ERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('145').update({'first_name':'Joel','last_name':'Embiid','position':'F-C','team_id':'P76ERS','price':83,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('367').update({'first_name':'Chris','last_name':'Paul','position':'G','team_id':'OTHUNDER','price':115,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666748').update({'first_name':'Cody','last_name':'Martin','position':'F','team_id':'CHORNETS','price':4,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('146').update({'first_name':'James','last_name':'Ennis III','position':'F','team_id':'P76ERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('257').update({'first_name':'Maxi','last_name':'Kleber','position':'F','team_id':'DMAVERICKS','price':24,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666530').update({'first_name':'Terence','last_name':'Davis','position':'G','team_id':'TRAPTORS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666641').update({'first_name':'Jaylen','last_name':'Hoard','position':'F','team_id':'PBLAZERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('147').update({'first_name':'Drew','last_name':'Eubanks','position':'F','team_id':'SSPURS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666609').update({'first_name':'Rui','last_name':'Hachimura','position':'F','team_id':'WWIZARDS','price':14,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('258').update({'first_name':'Brandon','last_name':'Knight','position':'G','team_id':'CCAVALIERS','price':47,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666468').update({'first_name':'Oshae','last_name':'Brissett','position':'F','team_id':'TRAPTORS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('148').update({'first_name':'Jacob','last_name':'Evans','position':'G','team_id':'GWARRIORS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('259').update({'first_name':'Kevin','last_name':'Knox','position':'F','team_id':'NKNICKS','price':14,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666502').update({'first_name':'Zylan','last_name':'Cheatham','position':'F','team_id':'NPELICANS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666950').update({'first_name':'P.J.','last_name':'Washington','position':'F','team_id':'CHORNETS','price':12,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('400').update({'first_name':'Rajon','last_name':'Rondo','position':'G','team_id':'LLAKERS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('401').update({'first_name':'Derrick','last_name':'Rose','position':'G','team_id':'DPISTONS','price':22,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('402').update({'first_name':'Terrence','last_name':'Ross','position':'G-F','team_id':'OMAGIC','price':38,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('480').update({'first_name':'Kenrich','last_name':'Williams','position':'G-F','team_id':'NPELICANS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('403').update({'first_name':'Terry','last_name':'Rozier','position':'G','team_id':'CHORNETS','price':60,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('51').update({'first_name':'Eric','last_name':'Bledsoe','position':'G','team_id':'MBUCKS','price':47,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('370').update({'first_name':'Theo','last_name':'Pinson','position':'G-F','team_id':'BNETS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('481').update({'first_name':'Lou','last_name':'Williams','position':'G','team_id':'LCLIPPERS','price':24,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('404').update({'first_name':'Ricky','last_name':'Rubio','position':'G','team_id':'PSUNS','price':49,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('53').update({'first_name':'Bogdan','last_name':'Bogdanovic','position':'G','team_id':'SKINGS','price':26,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('54').update({'first_name':'Bojan','last_name':'Bogdanovic','position':'F','team_id':'UJAZZ','price':51,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('371').update({'first_name':'Mason','last_name':'Plumlee','position':'F-C','team_id':'DNUGGETS','price':42,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('260').update({'first_name':'Furkan','last_name':'Korkmaz','position':'G-F','team_id':'P76ERS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('405').update({'first_name':"D'Angelo",'last_name':'Russell','position':'G','team_id':'GWARRIORS','price':82,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('482').update({'first_name':'Marvin','last_name':'Williams','position':'F','team_id':'CHORNETS','price':45,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('55').update({'first_name':'Jonah','last_name':'Bolden','position':'F','team_id':'P76ERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('261').update({'first_name':'Luke','last_name':'Kornet','position':'F-C','team_id':'CBULLS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('56').update({'first_name':'Isaac','last_name':'Bonga','position':'G','team_id':'WWIZARDS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('406').update({'first_name':'Domantas','last_name':'Sabonis','position':'F','team_id':'IPACERS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('57').update({'first_name':'Devin','last_name':'Booker','position':'G','team_id':'PSUNS','price':82,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('373').update({'first_name':'Jakob','last_name':'Poeltl','position':'C','team_id':'SSPURS','price':12,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('262').update({'first_name':'Kyle','last_name':'Korver','position':'G-F','team_id':'MBUCKS','price':18,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('58').update({'first_name':'Chris','last_name':'Boucher','position':'F','team_id':'TRAPTORS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('407').update({'first_name':'Dario','last_name':'Saric','position':'F','team_id':'PSUNS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('151').update({'first_name':'Dante','last_name':'Exum','position':'G','team_id':'UJAZZ','price':29,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('484').update({'first_name':'D.J.','last_name':'Wilson','position':'F','team_id':'MBUCKS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666919').update({'first_name':'Matt','last_name':'Thomas','position':'G','team_id':'TRAPTORS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('485').update({'first_name':'Justise','last_name':'Winslow','position':'F','team_id':'MHEAT','price':39,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('408').update({'first_name':'Tomas','last_name':'Satoransky','position':'G-F','team_id':'CBULLS','price':30,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('375').update({'first_name':'Michael','last_name':'Porter Jr.','position':'F','team_id':'DNUGGETS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666923').update({'first_name':'Matisse','last_name':'Thybulle','position':'G-F','team_id':'P76ERS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('264').update({'first_name':'Rodions','last_name':'Kurucs','position':'F','team_id':'BNETS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('409').update({'first_name':'Dennis','last_name':'Schroder','position':'G','team_id':'OTHUNDER','price':47,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('153').update({'first_name':'Derrick','last_name':'Favors','position':'F-C','team_id':'NPELICANS','price':53,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('486').update({'first_name':'Christian','last_name':'Wood','position':'F','team_id':'DPISTONS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('265').update({'first_name':'Kyle','last_name':'Kuzma','position':'F','team_id':'LLAKERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('487').update({'first_name':'Delon','last_name':'Wright','position':'G','team_id':'DMAVERICKS','price':29,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('377').update({'first_name':'Bobby','last_name':'Portis','position':'F','team_id':'NKNICKS','price':45,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('266').update({'first_name':'Skal','last_name':'Labissiere','position':'F','team_id':'PBLAZERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666976').update({'first_name':'Justin','last_name':'Wright-Foreman','position':'G','team_id':'UJAZZ','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('378').update({'first_name':'Kristaps','last_name':'Porzingis','position':'F-C','team_id':'DMAVERICKS','price':82,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('267').update({'first_name':'Jeremy','last_name':'Lamb','position':'G','team_id':'IPACERS','price':32,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('156').update({'first_name':'Terrance','last_name':'Ferguson','position':'G','team_id':'OTHUNDER','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('489').update({'first_name':'Thaddeus','last_name':'Young','position':'F','team_id':'CBULLS','price':39,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('379').update({'first_name':'Dwight','last_name':'Powell','position':'F-C','team_id':'DMAVERICKS','price':31,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('268').update({'first_name':'Zach','last_name':'LaVine','position':'G','team_id':'CBULLS','price':59,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666837').update({'first_name':'Norvel','last_name':'Pelle','position':'F','team_id':'P76ERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('157').update({'first_name':'Yogi','last_name':'Ferrell','position':'G','team_id':'SKINGS','price':10,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('269').update({'first_name':'Jake','last_name':'Layman','position':'F','team_id':'MTIMBERWOLVES','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('158').update({'first_name':'Dorian','last_name':'Finney-Smith','position':'F','team_id':'DMAVERICKS','price':12,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666952').update({'first_name':'Tremont','last_name':'Waters','position':'G','team_id':'BCELTICS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('159').update({'first_name':'Bryn','last_name':'Forbes','position':'G','team_id':'SSPURS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666809').update({'first_name':'Jaylen','last_name':'Nowell','position':'G','team_id':'MTIMBERWOLVES','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('410').update({'first_name':'Mike','last_name':'Scott','position':'F','team_id':'P76ERS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666894').update({'first_name':'Chris','last_name':'Silva','position':'F','team_id':'MHEAT','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('411').update({'first_name':'Thabo','last_name':'Sefolosha','position':'F','team_id':'HROCKETS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666672').update({'first_name':'Justin','last_name':'James','position':'G-F','team_id':'SKINGS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('301').update({'first_name':'Wesley','last_name':'Matthews','position':'G-F','team_id':'MBUCKS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('490').update({'first_name':'Trae','last_name':'Young','position':'G','team_id':'AHAWKS','price':19,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('413').update({'first_name':'Collin','last_name':'Sexton','position':'G','team_id':'CCAVALIERS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('491').update({'first_name':'Cody','last_name':'Zeller','position':'C','team_id':'CHORNETS','price':44,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('380').update({'first_name':'Norman','last_name':'Powell','position':'F-G','team_id':'TRAPTORS','price':31,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('303').update({'first_name':'CJ','last_name':'McCollum','position':'G','team_id':'PBLAZERS','price':83,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('270').update({'first_name':'TJ','last_name':'Leaf','position':'F','team_id':'IPACERS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('492').update({'first_name':'Ante','last_name':'Zizic','position':'C','team_id':'CCAVALIERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('415').update({'first_name':'Iman','last_name':'Shumpert','position':'G','team_id':'BNETS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('304').update({'first_name':'T.J.','last_name':'McConnell','position':'G','team_id':'IPACERS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666505').update({'first_name':'Brandon','last_name':'Clarke','position':'F','team_id':'MGRIZZLIES','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666697').update({'first_name':'Stanton','last_name':'Kidd','position':'F','team_id':'UJAZZ','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('271').update({'first_name':'Courtney','last_name':'Lee','position':'G','team_id':'DMAVERICKS','price':39,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('160').update({'first_name':'Evan','last_name':'Fournier','position':'G-F','team_id':'OMAGIC','price':51,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('416').update({'first_name':'Pascal','last_name':'Siakam','position':'F','team_id':'TRAPTORS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('305').update({'first_name':'Doug','last_name':'McDermott','position':'F','team_id':'IPACERS','price':22,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('493').update({'first_name':'Ivica','last_name':'Zubac','position':'C','team_id':'LCLIPPERS','price':20,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('383').update({'first_name':'Taurean','last_name':'Prince','position':'F','team_id':'BNETS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('417').update({'first_name':'Ben','last_name':'Simmons','position':'G-F','team_id':'P76ERS','price':25,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('306').update({'first_name':'JaVale','last_name':'McGee','position':'C','team_id':'LLAKERS','price':12,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('273').update({'first_name':'Alex','last_name':'Len','position':'C','team_id':'AHAWKS','price':13,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('162').update({'first_name':'Melvin','last_name':'Frazier Jr.','position':'G-F','team_id':'OMAGIC','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('307').update({'first_name':'Rodney','last_name':'McGruder','position':'F-G','team_id':'LCLIPPERS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('274').update({'first_name':'Kawhi','last_name':'Leonard','position':'F','team_id':'LCLIPPERS','price':98,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('163').update({'first_name':'Tim','last_name':'Frazier','position':'G','team_id':'DPISTONS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('419').update({'first_name':'Anfernee','last_name':'Simons','position':'G','team_id':'PBLAZERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('60').update({'first_name':'Tony','last_name':'Bradley','position':'C','team_id':'UJAZZ','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('308').update({'first_name':'Alfonzo','last_name':'McKinnie','position':'F','team_id':'CCAVALIERS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('61').update({'first_name':'Mikal','last_name':'Bridges','position':'F','team_id':'PSUNS','price':13,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('275').update({'first_name':'Meyers','last_name':'Leonard','position':'F-C','team_id':'MHEAT','price':34,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('309').update({'first_name':'Ben','last_name':'McLemore','position':'G','team_id':'HROCKETS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666423').update({'first_name':'RJ','last_name':'Barrett','position':'F-G','team_id':'NKNICKS','price':24,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('62').update({'first_name':'Miles','last_name':'Bridges','position':'F','team_id':'CHORNETS','price':12,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('165').update({'first_name':'Markelle','last_name':'Fultz','position':'G','team_id':'OMAGIC','price':30,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('387').update({'first_name':'Julius','last_name':'Randle','position':'F','team_id':'NKNICKS','price':54,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666871').update({'first_name':'Justin','last_name':'Robinson','position':'G','team_id':'WWIZARDS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('64').update({'first_name':'Ryan','last_name':'Broekhoff','position':'G-F','team_id':'DMAVERICKS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('166').update({'first_name':'Wenyen','last_name':'Gabriel','position':'F','team_id':'SKINGS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('65').update({'first_name':'Malcolm','last_name':'Brogdon','position':'G','team_id':'IPACERS','price':60,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('66').update({'first_name':'Dillon','last_name':'Brooks','position':'G-F','team_id':'MGRIZZLIES','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666476').update({'first_name':'Moses','last_name':'Brown','position':'C','team_id':'PBLAZERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('278').update({'first_name':'Damian','last_name':'Lillard','position':'G','team_id':'PBLAZERS','price':89,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('167').update({'first_name':'Danilo','last_name':'Gallinari','position':'F','team_id':'OTHUNDER','price':68,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('389').update({'first_name':'JJ','last_name':'Redick','position':'G','team_id':'NPELICANS','price':41,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('68').update({'first_name':'Troy','last_name':'Brown Jr.','position':'F','team_id':'WWIZARDS','price':10,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('168').update({'first_name':'Langston','last_name':'Galloway','position':'G','team_id':'DPISTONS','price':22,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('69').update({'first_name':'Bruce','last_name':'Brown','position':'G','team_id':'DPISTONS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('169').update({'first_name':'Marc','last_name':'Gasol','position':'C','team_id':'TRAPTORS','price':77,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('420').update({'first_name':'Marcus','last_name':'Smart','position':'G','team_id':'BCELTICS','price':38,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('50815').update({'first_name':'BJ','last_name':'Johnson','position':'F','team_id':'OMAGIC','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('310').update({'first_name':'Jordan','last_name':'McRae','position':'G','team_id':'WWIZARDS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('421').update({'first_name':'Dennis','last_name':'Smith Jr.','position':'G','team_id':'NKNICKS','price':14,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('200').update({'first_name':'Tobias','last_name':'Harris','position':'F','team_id':'P76ERS','price':98,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('422').update({'first_name':'Ish','last_name':'Smith','position':'G','team_id':'WWIZARDS','price':18,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('201').update({'first_name':'Isaiah','last_name':'Hartenstein','position':'F-C','team_id':'HROCKETS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666729').update({'first_name':'Nassir','last_name':'Little','position':'F','team_id':'PBLAZERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('313').update({'first_name':"De'Anthony",'last_name':'Melton','position':'G','team_id':'MGRIZZLIES','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('202').update({'first_name':'Josh','last_name':'Hart','position':'G','team_id':'NPELICANS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('50927').update({'first_name':'Kendrick','last_name':'Nunn','position':'G','team_id':'MHEAT','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('10').update({'first_name':'Al-Farouq','last_name':'Aminu','position':'F','team_id':'OMAGIC','price':28,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('391').update({'first_name':'Josh','last_name':'Richardson','position':'G-F','team_id':'P76ERS','price':31,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666400').update({'first_name':'Nickeil','last_name':'Alexander-Walker','position':'G','team_id':'NPELICANS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('314').update({'first_name':'Chimezie','last_name':'Metu','position':'F','team_id':'SSPURS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('203').update({'first_name':'Udonis','last_name':'Haslem','position':'F','team_id':'MHEAT','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('425').update({'first_name':'Zhaire','last_name':'Smith','position':'G','team_id':'P76ERS','price':10,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('12').update({'first_name':'Kyle','last_name':'Anderson','position':'F','team_id':'MGRIZZLIES','price':28,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('315').update({'first_name':'Khris','last_name':'Middleton','position':'F','team_id':'MBUCKS','price':92,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('426').update({'first_name':'Tony','last_name':'Snell','position':'G','team_id':'DPISTONS','price':34,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('393').update({'first_name':'Austin','last_name':'Rivers','position':'G','team_id':'HROCKETS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('282').update({'first_name':'Kevon','last_name':'Looney','position':'F','team_id':'GWARRIORS','price':14,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('316').update({'first_name':'CJ','last_name':'Miles','position':'F-G','team_id':'WWIZARDS','price':27,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('171').update({'first_name':'Rudy','last_name':'Gay','position':'F','team_id':'SSPURS','price':44,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666564').update({'first_name':'Bruno','last_name':'Fernando','position':'F','team_id':'AHAWKS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666675').update({'first_name':'DaQuan','last_name':'Jeffries','position':'F','team_id':'SKINGS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('15').update({'first_name':'Giannis','last_name':'Antetokounmpo','position':'F','team_id':'MBUCKS','price':78,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666786').update({'first_name':'Ja','last_name':'Morant','position':'G','team_id':'MGRIZZLIES','price':27,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('172').update({'first_name':'Paul','last_name':'George','position':'F','team_id':'LCLIPPERS','price':99,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('283').update({'first_name':'Brook','last_name':'Lopez','position':'C','team_id':'MBUCKS','price':37,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('206').update({'first_name':'Juancho','last_name':'Hernangomez','position':'F','team_id':'DNUGGETS','price':10,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('428').update({'first_name':'Omari','last_name':'Spellman','position':'F','team_id':'GWARRIORS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('17').update({'first_name':'Carmelo','last_name':'Anthony','position':'F','team_id':'PBLAZERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('173').update({'first_name':'Taj','last_name':'Gibson','position':'F','team_id':'NKNICKS','price':27,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('395').update({'first_name':'Glenn','last_name':'Robinson III','position':'G-F','team_id':'GWARRIORS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('318').update({'first_name':'Paul','last_name':'Millsap','position':'F','team_id':'DNUGGETS','price':90,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('207').update({'first_name':'Willy','last_name':'Hernangomez','position':'C','team_id':'CHORNETS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('284').update({'first_name':'Robin','last_name':'Lopez','position':'C','team_id':'MBUCKS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('18').update({'first_name':'OG','last_name':'Anunoby','position':'F','team_id':'TRAPTORS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('19').update({'first_name':'Ryan','last_name':'Arcidiacono','position':'G','team_id':'CBULLS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('174').update({'first_name':'Harry','last_name':'Giles III','position':'F-C','team_id':'SKINGS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('285').update({'first_name':'Kevin','last_name':'Love','position':'F-C','team_id':'CCAVALIERS','price':87,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('319').update({'first_name':'Patty','last_name':'Mills','position':'G','team_id':'SSPURS','price':38,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('208').update({'first_name':'Mario','last_name':'Hezonja','position':'F','team_id':'PBLAZERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('175').update({'first_name':'Shai','last_name':'Gilgeous-Alexander','position':'G','team_id':'OTHUNDER','price':12,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('397').update({'first_name':'Duncan','last_name':'Robinson','position':'F','team_id':'MHEAT','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666508').update({'first_name':'Nicolas','last_name':'Claxton','position':'F-C','team_id':'BNETS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('176').update({'first_name':'Rudy','last_name':'Gobert','position':'C','team_id':'UJAZZ','price':73,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('398').update({'first_name':'Jerome','last_name':'Robinson','position':'G','team_id':'LCLIPPERS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666956').update({'first_name':'Coby','last_name':'White','position':'G','team_id':'CBULLS','price':16,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('177').update({'first_name':'Aaron','last_name':'Gordon','position':'F','team_id':'OMAGIC','price':60,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('399').update({'first_name':'Mitchell','last_name':'Robinson','position':'C','team_id':'NKNICKS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('288').update({'first_name':'Timothe','last_name':'Luwawu-Cabarrot','position':'G-F','team_id':'BNETS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('3').update({'first_name':'Steven','last_name':'Adams','position':'C','team_id':'OTHUNDER','price':78,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('4').update({'first_name':'Bam','last_name':'Adebayo','position':'C-F','team_id':'MHEAT','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666454').update({'first_name':'Jordan','last_name':'Bone','position':'G','team_id':'DPISTONS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666676').update({'first_name':'Ty','last_name':'Jerome','position':'G','team_id':'PSUNS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('6').update({'first_name':'LaMarcus','last_name':'Aldridge','position':'F','team_id':'SSPURS','price':78,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('8').update({'first_name':'Grayson','last_name':'Allen','position':'G','team_id':'MGRIZZLIES','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('70').update({'first_name':'Jaylen','last_name':'Brown','position':'G','team_id':'BCELTICS','price':20,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('9').update({'first_name':'Jarrett','last_name':'Allen','position':'C','team_id':'BNETS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('320').update({'first_name':'Shake','last_name':'Milton','position':'G','team_id':'P76ERS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('72').update({'first_name':'Sterling','last_name':'Brown','position':'G','team_id':'MBUCKS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('73').update({'first_name':'Jalen','last_name':'Brunson','position':'G','team_id':'DMAVERICKS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('210').update({'first_name':'Buddy','last_name':'Hield','position':'G','team_id':'SKINGS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('432').update({'first_name':'Edmond','last_name':'Sumner','position':'G','team_id':'IPACERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('74').update({'first_name':'Thomas','last_name':'Bryant','position':'C','team_id':'WWIZARDS','price':24,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666509').update({'first_name':'Chris','last_name':'Clemons','position':'G','team_id':'HROCKETS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('211').update({'first_name':'George','last_name':'Hill','position':'G','team_id':'MBUCKS','price':31,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('100').update({'first_name':'Jordan','last_name':'Clarkson','position':'G','team_id':'CCAVALIERS','price':41,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('433').update({'first_name':'Caleb','last_name':'Swanigan','position':'F','team_id':'SKINGS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('322').update({'first_name':'Donovan','last_name':'Mitchell','position':'G','team_id':'UJAZZ','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('76').update({'first_name':'Trey','last_name':'Burke','position':'G','team_id':'P76ERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666846').update({'first_name':'Vincent','last_name':'Poirier','position':'C','team_id':'BCELTICS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('212').update({'first_name':'Solomon','last_name':'Hill','position':'F','team_id':'MGRIZZLIES','price':40,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('77').update({'first_name':'Alec','last_name':'Burks','position':'G','team_id':'GWARRIORS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('434').update({'first_name':'Jayson','last_name':'Tatum','position':'F','team_id':'BCELTICS','price':24,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('323').update({'first_name':'Naz','last_name':'Mitrou-Long','position':'G','team_id':'IPACERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('78').update({'first_name':'Deonte','last_name':'Burton','position':'G','team_id':'OTHUNDER','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('290').update({'first_name':'Trey','last_name':'Lyles','position':'F','team_id':'SSPURS','price':17,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('213').update({'first_name':'Aaron','last_name':'Holiday','position':'G','team_id':'IPACERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('435').update({'first_name':'Jeff','last_name':'Teague','position':'G','team_id':'MTIMBERWOLVES','price':57,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('79').update({'first_name':'Jimmy','last_name':'Butler','position':'G-F','team_id':'MHEAT','price':98,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('324').update({'first_name':'Malik','last_name':'Monk','position':'G','team_id':'CHORNETS','price':13,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('180').update({'first_name':"Devonte'",'last_name':'Graham','position':'G','team_id':'CHORNETS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('214').update({'first_name':'Jrue','last_name':'Holiday','position':'G','team_id':'NPELICANS','price':78,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('436').update({'first_name':'Garrett','last_name':'Temple','position':'G-F','team_id':'BNETS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666788').update({'first_name':'Juwan','last_name':'Morgan','position':'F','team_id':'UJAZZ','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('181').update({'first_name':'Treveon','last_name':'Graham','position':'F','team_id':'MTIMBERWOLVES','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('215').update({'first_name':'Justin','last_name':'Holiday','position':'F-G','team_id':'IPACERS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('104').update({'first_name':'Mike','last_name':'Conley','position':'G','team_id':'UJAZZ','price':97,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('326').update({'first_name':"E'Twaun",'last_name':'Moore','position':'G','team_id':'NPELICANS','price':26,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('182').update({'first_name':'Jerami','last_name':'Grant','position':'F','team_id':'DNUGGETS','price':28,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('216').update({'first_name':'Rondae','last_name':'Hollis-Jefferson','position':'F','team_id':'TRAPTORS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('105').update({'first_name':'Pat','last_name':'Connaughton','position':'G','team_id':'MBUCKS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('294').update({'first_name':'Ian','last_name':'Mahinmi','position':'C','team_id':'WWIZARDS','price':47,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('217').update({'first_name':'Richaun','last_name':'Holmes','position':'F-C','team_id':'SKINGS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('106').update({'first_name':'Quinn','last_name':'Cook','position':'G','team_id':'LLAKERS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('439').update({'first_name':'Daniel','last_name':'Theis','position':'F','team_id':'BCELTICS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('328').update({'first_name':'Marcus','last_name':'Morris','position':'F','team_id':'NKNICKS','price':45,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('295').update({'first_name':'Thon','last_name':'Maker','position':'F','team_id':'DPISTONS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('184').update({'first_name':'Danny','last_name':'Green','position':'G-F','team_id':'LLAKERS','price':44,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('218').update({'first_name':'Rodney','last_name':'Hood','position':'G','team_id':'PBLAZERS','price':18,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('329').update({'first_name':'Markieff','last_name':'Morris','position':'F','team_id':'DPISTONS','price':10,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('296').update({'first_name':'Boban','last_name':'Marjanovic','position':'C','team_id':'DMAVERICKS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('185').update({'first_name':'Draymond','last_name':'Green','position':'F','team_id':'GWARRIORS','price':56,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('219').update({'first_name':'Al','last_name':'Horford','position':'C-F','team_id':'P76ERS','price':84,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('108').update({'first_name':'Robert','last_name':'Covington','position':'F','team_id':'MTIMBERWOLVES','price':34,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('20').update({'first_name':'Trevor','last_name':'Ariza','position':'F','team_id':'SKINGS','price':37,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666847').update({'first_name':'Shamorie','last_name':'Ponds','position':'G','team_id':'TRAPTORS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('21').update({'first_name':'D.J.','last_name':'Augustin','position':'G','team_id':'OMAGIC','price':22,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('297').update({'first_name':'Lauri','last_name':'Markkanen','position':'F','team_id':'CBULLS','price':16,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('109').update({'first_name':'Allen','last_name':'Crabbe','position':'G-F','team_id':'AHAWKS','price':56,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('22').update({'first_name':'Deandre','last_name':'Ayton','position':'C','team_id':'PSUNS','price':29,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('23').update({'first_name':'Dwayne','last_name':'Bacon','position':'G-F','team_id':'CHORNETS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('187').update({'first_name':'JaMychal','last_name':'Green','position':'F','team_id':'LCLIPPERS','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('299').update({'first_name':'Frank','last_name':'Mason','position':'G','team_id':'MBUCKS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('188').update({'first_name':'Jeff','last_name':'Green','position':'F','team_id':'UJAZZ','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666460').update({'first_name':'Ky','last_name':'Bowman','position':'G','team_id':'GWARRIORS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666682').update({'first_name':'Keldon','last_name':'Johnson','position':'F','team_id':'SSPURS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('189').update({'first_name':'Blake','last_name':'Griffin','position':'F','team_id':'DPISTONS','price':103,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('27').update({'first_name':'Lonzo','last_name':'Ball','position':'G','team_id':'NPELICANS','price':27,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('28').update({'first_name':'Mo','last_name':'Bamba','position':'C','team_id':'OMAGIC','price':17,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('440').update({'first_name':'Isaiah','last_name':'Thomas','position':'G','team_id':'WWIZARDS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('29').update({'first_name':'J.J.','last_name':'Barea','position':'G','team_id':'DMAVERICKS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('115').update({'first_name':'Stephen','last_name':'Curry','position':'G','team_id':'GWARRIORS','price':120,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('467').update({'first_name':'John','last_name':'Wall','position':'G','team_id':'WWIZARDS','price':114,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('140').update({'first_name':'Kevin','last_name':'Durant','position':'F','team_id':'BNETS','price':111,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('286').update({'first_name':'Kyle','last_name':'Lowry','position':'G','team_id':'TRAPTORS','price':100,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('443').update({'first_name':'Klay','last_name':'Thompson','position':'G','team_id':'GWARRIORS','price':98,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('204').update({'first_name':'Gordon','last_name':'Hayward','position':'F','team_id':'BCELTICS','price':98,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('228').update({'first_name':'Kyrie','last_name':'Irving','position':'G','team_id':'BNETS','price':95,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('376').update({'first_name':'Otto','last_name':'Porter Jr.','position':'F','team_id':'CBULLS','price':82,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('236').update({'first_name':'Reggie','last_name':'Jackson','position':'G','team_id':'DPISTONS','price':54,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('224').update({'first_name':'Andre','last_name':'Iguodala','position':'G-F','team_id':'MGRIZZLIES','price':52,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('178').update({'first_name':'Eric','last_name':'Gordon','position':'G','team_id':'HROCKETS','price':42,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('372').update({'first_name':'Miles','last_name':'Plumlee','position':'C','team_id':'MGRIZZLIES','price':37,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('463').update({'first_name':'Dion','last_name':'Waiters','position':'G','team_id':'MHEAT','price':37,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('349').update({'first_name':'Jusuf','last_name':'Nurkic','position':'C','team_id':'PBLAZERS','price':36,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('394').update({'first_name':'Andre','last_name':'Roberson','position':'G-F','team_id':'OTHUNDER','price':33,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('342').update({'first_name':'Nene','last_name':'','position':'C-F','team_id':'HROCKETS','price':30,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666969').update({'first_name':'Zion','last_name':'Williamson','position':'F','team_id':'NPELICANS','price':30,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('205').update({'first_name':'John','last_name':'Henson','position':'F','team_id':'CCAVALIERS','price':30,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('24').update({'first_name':'Marvin','last_name':'Bagley III','position':'F','team_id':'SKINGS','price':26,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('154').update({'first_name':'Cristiano','last_name':'Felicio','position':'F-C','team_id':'CBULLS','price':25,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('369').update({'first_name':'Elfrid','last_name':'Payton','position':'G','team_id':'NKNICKS','price':24,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('170').update({'first_name':'Pau','last_name':'Gasol','position':'C-F','team_id':'PBLAZERS','price':23,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('317').update({'first_name':'Darius','last_name':'Miller','position':'F','team_id':'NPELICANS','price':22,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('234').update({'first_name':'Josh','last_name':'Jackson','position':'F','team_id':'MGRIZZLIES','price':22,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('59').update({'first_name':'Avery','last_name':'Bradley','position':'G','team_id':'LLAKERS','price':21,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1771').update({'first_name':'Joakim','last_name':'Noah','position':'F-C','team_id':'MGRIZZLIES','price':20,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('161').update({'first_name':"De'Aaron",'last_name':'Fox','position':'G','team_id':'SKINGS','price':20,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('13').update({'first_name':'Ryan','last_name':'Anderson','position':'F','team_id':'HROCKETS','price':18,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('332').update({'first_name':'Timofey','last_name':'Mozgov','position':'C','team_id':'OMAGIC','price':17,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1601').update({'first_name':'Deron','last_name':'Williams','position':'G','team_id':'UJAZZ','price':17,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1541').update({'first_name':'Josh','last_name':'Smith','position':'F','team_id':'AHAWKS','price':16,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('124').update({'first_name':'Luol','last_name':'Deng','position':'F','team_id':'MTIMBERWOLVES','price':15,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('102').update({'first_name':'Zach','last_name':'Collins','position':'F-C','team_id':'PBLAZERS','price':13,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('75').update({'first_name':'Reggie','last_name':'Bullock','position':'G-F','team_id':'NKNICKS','price':12,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2158').update({'first_name':'Patrick','last_name':'McCaw','position':'F-G','team_id':'TRAPTORS','price':12,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('243').update({'first_name':'Stanley','last_name':'Johnson','position':'F','team_id':'TRAPTORS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('107').update({'first_name':'DeMarcus','last_name':'Cousins','position':'C','team_id':'LLAKERS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666713').update({'first_name':'Romeo','last_name':'Langford','position':'G','team_id':'BCELTICS','price':11,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('276').update({'first_name':'Jon','last_name':'Leuer','position':'F','team_id':'DPISTONS','price':10,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1895').update({'first_name':'Omer','last_name':'Asik','position':'F-C','team_id':'CBULLS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2012').update({'first_name':'Andrew','last_name':'Nicholson','position':'F','team_id':'OMAGIC','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666881').update({'first_name':'Luka','last_name':'Samanic','position':'F','team_id':'SSPURS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('101').update({'first_name':'John','last_name':'Collins','position':'F-C','team_id':'AHAWKS','price':9,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('221').update({'first_name':'Kevin','last_name':'Huerter','position':'G','team_id':'AHAWKS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('277').update({'first_name':'Caris','last_name':'Levert','position':'G','team_id':'BNETS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('95').update({'first_name':'Wilson','last_name':'Chandler','position':'F','team_id':'BNETS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('186').update({'first_name':'Gerald','last_name':'Green','position':'G-F','team_id':'HROCKETS','price':8,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1635').update({'first_name':'Monta','last_name':'Ellis','position':'G','team_id':'GWARRIORS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1522').update({'first_name':'Matt','last_name':'Barnes','position':'F','team_id':'LCLIPPERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666971').update({'first_name':'Dylan','last_name':'Windler','position':'G-F','team_id':'CCAVALIERS','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('86').update({'first_name':'Michael','last_name':'Carter-Williams','position':'G','team_id':'OMAGIC','price':7,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1775').update({'first_name':'Spencer','last_name':'Hawes','position':'C','team_id':'SKINGS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('414').update({'first_name':'Landry','last_name':'Shamet','position':'G','team_id':'LCLIPPERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1557').update({'first_name':'Anderson','last_name':'Varejao','position':'F-C','team_id':'CCAVALIERS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1894').update({'first_name':'Larry','last_name':'Sanders','position':'F-C','team_id':'MBUCKS','price':6,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('47').update({'first_name':'Jabari','last_name':'Bird','position':'G','team_id':'GWARRIORS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666873').update({'first_name':'Isaiah','last_name':'Roby','position':'F','team_id':'DMAVERICKS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('50').update({'first_name':'Antonio','last_name':'Blakeney','position':'G','team_id':'CBULLS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('424').update({'first_name':'JR','last_name':'Smith','position':'G-F','team_id':'CCAVALIERS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('441').update({'first_name':'Khyri','last_name':'Thomas','position':'G','team_id':'DPISTONS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('457').update({'first_name':'Jarred','last_name':'Vanderbilt','position':'F','team_id':'DNUGGETS','price':5,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('488').update({'first_name':'Guerschon','last_name':'Yabusele','position':'F','team_id':'BCELTICS','price':4,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2069').update({'first_name':'Justin','last_name':'Hamilton','position':'C','team_id':'CHORNETS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('418').update({'first_name':'Jonathon','last_name':'Simmons','position':'F','team_id':'P76ERS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1991').update({'first_name':'Kyle','last_name':'Singler','position':'F','team_id':'DPISTONS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666489').update({'first_name':'Vlatko','last_name':'Cancar','position':'F','team_id':'DNUGGETS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666900').update({'first_name':'Alen','last_name':'Smailagic','position':'F','team_id':'GWARRIORS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666650').update({'first_name':'Talen','last_name':'Horton-Tucker','position':'G','team_id':'LLAKERS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666821').update({'first_name':'KZ','last_name':'Okpala','position':'F','team_id':'MHEAT','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666720').update({'first_name':'Jalen','last_name':'Lecque','position':'G','team_id':'PSUNS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666747').update({'first_name':'Caleb','last_name':'Martin','position':'F','team_id':'CHORNETS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666762').update({'first_name':'Jalen','last_name':'McDaniels','position':'F','team_id':'CHORNETS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('427').update({'first_name':'Ray','last_name':'Spalding','position':'F','team_id':'PSUNS','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1896').update({'first_name':'Cole','last_name':'Aldrich','position':'C','team_id':'OTHUNDER','price':3,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('280').update({'first_name':'Shaun','last_name':'Livingston','position':'G','team_id':'GWARRIORS','price':2,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2199').update({'first_name':'Dakari','last_name':'Johnson','position':'C','team_id':'OTHUNDER','price':2,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1788').update({'first_name':'C.J.','last_name':'Watson','position':'G','team_id':'GWARRIORS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1998').update({'first_name':'Festus','last_name':'Ezeli','position':'C','team_id':'GWARRIORS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2162').update({'first_name':'Deyonta','last_name':'Davis','position':'F-C','team_id':'AHAWKS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1364').update({'first_name':'Joe','last_name':'Johnson','position':'F-G','team_id':'DPISTONS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('368').update({'first_name':'Cameron','last_name':'Payne','position':'G','team_id':'TRAPTORS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('483').update({'first_name':'Troy','last_name':'Williams','position':'F','team_id':'SKINGS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2').update({'first_name':'Jaylen','last_name':'Adams','position':'G','team_id':'MBUCKS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('300').update({'first_name':'Yante','last_name':'Maten','position':'F','team_id':'BCELTICS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('232').update({'first_name':'Demetrius','last_name':'Jackson','position':'G','team_id':'LLAKERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666560').update({'first_name':'Tacko','last_name':'Fall','position':'C','team_id':'BCELTICS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666570').update({'first_name':'Robert','last_name':'Franks','position':'F','team_id':'CHORNETS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2202').update({'first_name':'Kobi','last_name':'Simmons','position':'G','team_id':'CHORNETS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666783').update({'first_name':'Adam','last_name':'Mokoka','position':'G','team_id':'CBULLS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('2211').update({'first_name':'Antonius','last_name':'Cleveland','position':'G','team_id':'DMAVERICKS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666859').update({'first_name':'Josh','last_name':'Reaves','position':'G','team_id':'DMAVERICKS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666451').update({'first_name':'Bol','last_name':'Bol','position':'C','team_id':'DNUGGETS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('135').update({'first_name':'PJ','last_name':'Dozier','position':'G','team_id':'DNUGGETS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666698').update({'first_name':'Louis','last_name':'King','position':'F','team_id':'DPISTONS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('272').update({'first_name':'Damion','last_name':'Lee','position':'G','team_id':'GWARRIORS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('50729').update({'first_name':'Michael','last_name':'Frazier','position':'G','team_id':'HROCKETS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666511').update({'first_name':'Amir','last_name':'Coffey','position':'G','team_id':'LCLIPPERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('331').update({'first_name':'Johnathan','last_name':'Motley','position':'F','team_id':'LCLIPPERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('16').update({'first_name':'Kostas','last_name':'Antetokounmpo','position':'F','team_id':'LLAKERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666808').update({'first_name':'Zach','last_name':'Norvell Jr.','position':'G','team_id':'LLAKERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666703').update({'first_name':'John','last_name':'Konchar','position':'G','team_id':'MGRIZZLIES','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('292').update({'first_name':'Daryl','last_name':'Macon','position':'G','team_id':'MHEAT','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('50966').update({'first_name':'Cameron','last_name':'Reynolds','position':'G','team_id':'OMAGIC','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666767').update({'first_name':'Jordan','last_name':'McLaughlin','position':'G','team_id':'MTIMBERWOLVES','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('385').update({'first_name':'Ivan','last_name':'Rabb','position':'F','team_id':'NKNICKS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666541').update({'first_name':'Luguentz','last_name':'Dort','position':'G','team_id':'OTHUNDER','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666616').update({'first_name':'Jared','last_name':'Harper','position':'G','team_id':'PSUNS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666953').update({'first_name':'Quinndary','last_name':'Weatherspoon','position':'G','team_id':'SSPURS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666463').update({'first_name':'Jarrell','last_name':'Brantley','position':'F','team_id':'UJAZZ','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666754').update({'first_name':'Garrison','last_name':'Mathews','position':'G','team_id':'WWIZARDS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('96').update({'first_name':'Joe','last_name':'Chealey','position':'G','team_id':'CHORNETS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('289').update({'first_name':'Tyler','last_name':'Lydon','position':'F','team_id':'SKINGS','price':1,});
      //
      FirebaseDatabase.instance.reference().child('api').child('players').child('2189').update({'first_name':'Gary','last_name':'Payton II','position':'G','team_id':'WWIZARDS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666486').update({'first_name':'Devontae','last_name':'Cacok','position':'F-C','team_id':'LLAKERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1358055').update({'first_name':'Anzejs','last_name':'Pasecniks','position':'C','team_id':'WWIZARDS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('1280857').update({'first_name':'Kevin','last_name':'Hervey','position':'F','team_id':'OTHUNDER','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('479').update({'first_name':'Johnathan','last_name':'Williams','position':'F','team_id':'LLAKERS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666474').update({'first_name':'Charles','last_name':'Brown','position':'G','team_id':'AHAWKS','price':1,});
      FirebaseDatabase.instance.reference().child('api').child('players').child('666930').update({'first_name':'Rayjon','last_name':'Tucker','position':'F','team_id':'UJAZZ','price':1,});
}