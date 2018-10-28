import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

import 'game.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: '2048'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class GameCellWidget extends StatelessWidget {
  GameCellWidget();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Game game;

  List<Widget> gameBoard = [];

  String title;

  @override
  void initState() {
    super.initState();
    game = Game.withRowsAndColumns(rows: 4, columns: 4);

    title = widget.title;
//    var width = MediaQuery.of(context).size.width / 5.0;
//
//    gameBoard = game.board.map((c) {
//      return new Padding(
//        padding: const EdgeInsets.all(1.0),
//        child: new AnimatedContainer(
//          decoration: new BoxDecoration(
//              color: _getColor(c),
//              borderRadius: new BorderRadius.all(Radius.circular(4.0))),
//          duration: Duration(seconds: 1),
//          width: width,
//          height: width,
//          //color: _getColor(c),
//          child: Text(
//            "${c.value ?? ""}",
//            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//          ),
//          alignment: Alignment.center,
//        ),
//      );
//    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text(title),
//          leading: IconButton(
//            onPressed: () {},
//            icon: Icon(Icons.undo),
//          ),
//          actions: <Widget>[
//            new FlatButton(
//                onPressed: () {
//                  resetGame();
//                },
//                child: Text("Reset"))
//          ],
        ),
        body: _buildGameBoard(context));
  }

  Color _getColor(GameCell c) {
    if (c.value == null) {
      return Color.fromRGBO(Colors.white30.red, Colors.white30.blue,
          Colors.white30.green, 0.2); // Colors.white);
    }
    if (c.value == 4) {
      return Colors.orange;
    }
    if (c.value == 2) {
      return Colors.orangeAccent;
    }

    if (c.value == 16) {
      return Colors.deepOrange;
    }
    if (c.value == 8) {
      return Colors.deepOrangeAccent;
    }

    if (c.value == 32) {
      return Colors.purpleAccent;
    }
    if (c.value == 64) {
      return Colors.purple;
    }

    if (c.value == 128) {
      return Colors.deepPurpleAccent;
    }
    if (c.value == 256) {
      return Colors.deepPurple;
    }

    return Colors.green;
  }

  Widget _buildGameBoard(BuildContext context) {
    print(this.game);

    var h = (MediaQuery.of(context).size.width);
    if (game.isGameOver()) {
      Future.delayed(Duration(milliseconds: 100), () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (c) {
              return AlertDialog(
                title: Text("Game Over"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        resetGame();
                        Navigator.of(context).pop();
                      },
                      child: Text("Reset")),
                ],
              );
            });
      });

//      return Scaffold(
//          body: Padding(
//        padding: const EdgeInsets.only(top: 25.0, left: 8.0, right: 8.0),
//        child: Container(
//            height: h,
//            child: Center(
//              child: new Column(
//                children: <Widget>[
//                  new Text(
//                    "Game Over!",
//                    style: TextStyle(fontSize: 30.0),
//                  ),
//                  new SizedBox(
//                    height: 10.0,
//                  ),
//                  new FlatButton(
//                      onPressed: () {
//                        resetGame();
//                      },
//                      child: Text("Reset Game"))
//                ],
//              ),
//            )),
//      ));
    }
    var width = (MediaQuery.of(context).size.width / 5.0) / (game.columns / 4);
    var items = game.board.map((c) {
      return new Padding(
        padding: const EdgeInsets.all(5.0),
        child: new AnimatedContainer(
          decoration: new BoxDecoration(
              color: _getColor(c),
              borderRadius: new BorderRadius.all(Radius.circular(4.0))),
          duration: Duration(milliseconds: 300),
          width: width,
          height: width,
          child: Text(
            "${c.value ?? ""}",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.center,
        ),
      );
    }).toList();

    double verticalSwipeMaxWidthThreshold = 50.0;
    double verticalSwipeMinDisplacement = 50.0;
    double verticalSwipeMinVelocity = 100.0;

    //Horizontal swipe configuration options
    double horizontalSwipeMaxHeightThreshold = 50.0;
    double horizontalSwipeMinDisplacement = 50.0;
    double horizontalSwipeMinVelocity = 50.0;

    //154.5 13.0 0.0 0.0

    var grd = SwipeDetector(
      swipeConfiguration: SwipeConfiguration(
        horizontalSwipeMaxHeightThreshold: horizontalSwipeMaxHeightThreshold,
        horizontalSwipeMinDisplacement: horizontalSwipeMinDisplacement,
        verticalSwipeMaxWidthThreshold: verticalSwipeMaxWidthThreshold,
        verticalSwipeMinDisplacement: verticalSwipeMinDisplacement,
        verticalSwipeMinVelocity: verticalSwipeMinVelocity,
        horizontalSwipeMinVelocity: horizontalSwipeMinVelocity,
      ),
      onSwipeUp: () {
        moveUp();
      },
      onSwipeDown: () {
        moveDown();
      },
      onSwipeRight: () {
        moveRight();
      },
      onSwipeLeft: () {
        moveLeft();
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(width: 4.0, color: Colors.grey),
              color: Colors.grey),
          child: Wrap(
            children: items,
          ),
        ),
      ),
    );
//    new GridView.count(
//        shrinkWrap: true,
//        physics: NeverScrollableScrollPhysics(),
//        crossAxisCount: game.rows,
//        scrollDirection: Axis.vertical,
//        childAspectRatio: 1.0,
//        children: items);

    var gridView = new GridView.builder(
        itemCount: game.rows * game.columns,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100.0),
        itemBuilder: (BuildContext context, int index) {
          GameCell c = this.game.board[index];
          return InkWell(
            onTap: () {
              print(game);
              var g = game;
              g.moveUp();
              setState(() {
                game = g;
              });
            },
            child: new Padding(
              padding: const EdgeInsets.all(1.0),
              child: new Container(
                color: c.value == null ? Colors.grey : Colors.teal,
                child: Text(
                  "${c.stringValue()}",
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
              ),
            ),
          );
        });
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Container(child: grd),
    ));
  }

  void moveUp() {
    setState(() {
      var g = game;
      g.moveUp();
      game = g;
    });
    checkGameOver();
  }

  void regenerateGame() {
    setState(() {
      var g = game;
      g.regenerateGame();
      game = g;
    });
  }

  _gameRow(int row) {}

  void moveLeft() {
    setState(() {
      var g = game;
      g.moveLeft();
      game = g;
    });

    checkGameOver();
  }

  void checkGameOver() {
    if (game.isGameOver()) {
      setState(() {
        title = "Game Over";
      });
    }
  }

  void moveRight() {
    setState(() {
      var g = game;
      g.moveRight();
      game = g;
    });
    checkGameOver();
  }

  void moveDown() {
    setState(() {
      var g = game;
      g.moveDown();
      game = g;
    });
    checkGameOver();
  }

  void _updateBoard(Widget widget, GameCell cell) {}

  void resetGame() {
    setState(() {
      var g = Game.withRowsAndColumns(rows: game.rows, columns: game.columns);
      game = g;
    });
  }
}
