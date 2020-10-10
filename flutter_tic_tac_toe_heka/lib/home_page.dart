import 'dart:math';

import 'package:flutter/material.dart';

import 'custom_dialog.dart';
import 'game_button.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;
  var gameType;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();

  }


  List<GameButton> doInit() {
    player1 = new List();
    player2 = new List();
    activePlayer=1;

    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9)
    ];
    return gameButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tic tac toe heka"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 9.0,
                  mainAxisSpacing: 9.0
                ),
                itemBuilder: (context, i) => SizedBox(
                      width: 100,
                      height: 100,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        onPressed: buttonsList[i].enabled ?()=>playGame(buttonsList[i]):null,
                        child: Text( buttonsList[i].text, style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        color: buttonsList[i].bg,
                        disabledColor: buttonsList[i].bg,
                      ),
                    ),
                itemCount: buttonsList.length),
          ),
          RaisedButton(
            child: Text("Reset",
            style: TextStyle(color: Colors.white, fontSize: 20.0),),
            color: Colors.red,
            padding: const EdgeInsets.all(20.0),
            onPressed: resetGame,
          )
        ],
      ),
    );
  }

  playGame(GameButton gb) {
    setState(() {
      if(activePlayer ==1){
        gb.text ="X";
        gb.bg=Colors.lightGreen;
        activePlayer=2;
        player1.add(gb.id);
      }else{
        gb.text="0";
        gb.bg= Colors.lightBlue;
        activePlayer=1;
        player2.add(gb.id);
      }
      gb.enabled=false;
    int whoIsWinner =  checkWinnder();

    if(whoIsWinner == -1){
      if(buttonsList.every((p)=> p.text != "")){
        showDialog(context: context,
        builder: (_)=> CustomDialog("Game tied!",
        "Press reset button to start again", resetGame));
      }else{
        activePlayer == 2? autoPlay():null;
      }
    }
    });
  }

   checkWinnder() {
    var winner= -1;
    //Horizontal win types
    if(player1.contains(1) && player1.contains(2) && player1.contains(3))  winner =1;
    if(player2.contains(1) && player2.contains(2) && player2.contains(3))  winner =2;
    if(player1.contains(4) && player1.contains(5) && player1.contains(6))  winner =1;
    if(player2.contains(4) && player2.contains(5) && player2.contains(6))  winner =2;
    if(player1.contains(7) && player1.contains(8) && player1.contains(9))  winner =1;
    if(player2.contains(7) && player2.contains(8) && player2.contains(9))  winner =2;

    //vertical win types
    if(player1.contains(1) && player1.contains(4) && player1.contains(7))  winner =1;
    if(player2.contains(1) && player2.contains(4) && player2.contains(7))  winner =2;
    if(player1.contains(2) && player1.contains(5) && player1.contains(8))  winner =1;
    if(player2.contains(2) && player2.contains(5) && player2.contains(8))  winner =2;
    if(player1.contains(3) && player1.contains(6) && player1.contains(9))  winner =1;
    if(player2.contains(3) && player2.contains(6) && player2.contains(9))  winner =2;

    //diagonal win types
    if(player1.contains(1) && player1.contains(5) && player1.contains(9))  winner =1;
    if(player2.contains(1) && player2.contains(5) && player2.contains(9))  winner =2;

    if(player1.contains(3) && player1.contains(5) && player1.contains(7))  winner =1;
    if(player2.contains(3) && player2.contains(5) && player2.contains(7))  winner =2;

    if(winner != -1){
      if(winner == 1){
        showDialog(
            context: context,
            builder: (_)=> CustomDialog("Player 1 won", "Press the reset button start again",resetGame));
      }else{
        showDialog(
            context: context,
            builder: (_)=> CustomDialog("Player 2 won", "Press the reset button start again",resetGame));
      }
    }

    return winner;
  }

  void resetGame() {
    if(Navigator.canPop(context))Navigator.pop(context);
    setState(() {
     buttonsList= doInit();
    });
  }

  autoPlay() {
    var emptycells = new List();
    var list = new List.generate(9, (i)=> i+1);
    for(var cellId in list){
      if(!(player1.contains(cellId)) || (player2.contains(cellId))){
        emptycells.add(cellId);
      }
    }
  var r = new Random();
  var randIndex = r.nextInt(emptycells.length-1);
  var cellID = emptycells[randIndex];
  int i = buttonsList.indexWhere((p)=> p.id == cellID);
  playGame(buttonsList[i]);

  }

   gameModeSelector(){
    //https://coflutter.com/flutter-how-to-show-dialog/
  showDialog(context: context,
  builder: (_)=>
      AlertDialog(
        title: Text("Game Type"),
        content:Text("Select game type") ,
        actions: <Widget>[
          FlatButton(
            child: Text("2P"),
            onPressed: (){},
          ),
          FlatButton(
            child: Text("1P"),
            onPressed: (){},
          )
        ],
      ));

  }
}
