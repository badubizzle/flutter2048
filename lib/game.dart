import 'dart:math' as math;

class GameCell {
  int value;
  int index = -1;
  GameCell({this.index, this.value});

  @override
  String toString() {
    //if (this.value != null) {
    return "(i: ${this.index}, v: ${this.value})";
    //}
    //return "(${this.index} ";
  }

  GameCell copyWithValue(int value) {
    return GameCell(index: this.index, value: value);
  }

  String stringValue() {
    return this.toString();

    if (this.value == null) {
      return "";
    }
    return "${this.value}";
  }

  GameCell copyWithIndex(int index) {
    return GameCell(index: index, value: this.value);
  }
}

enum MoveDirection { up, down, left, right }

class GameRow {
  List<GameCell> cells = [];

  factory GameRow.withCount(int columns) {
    List<GameCell> cells = List.generate(columns, (i) {
      return GameCell(index: i, value: null);
    }).toList();
    var g = GameRow(cells: cells);

    return g;
  }

  GameRow({this.cells});

  @override
  String toString() {
    List<String> row = this.cells.map((r) {
      return r.toString();
    }).toList();

    return "|${row.join("|")}|";
  }
}

class Game {
  List<GameCell> board = [];
  int rows = 4;
  int columns = 4;
  int totalMoves = 0;

  bool _isOver = false;

  factory Game.withRowsAndColumns({int rows, int columns}) {
//    var board = List.generate(rows * columns, (i) {
//      return GameCell(i);
//    }).toList();

    return Game(rows: rows, columns: columns);
  }

  Game({this.rows, this.columns}) {
    this.loadGame();
    this.regenerateGame();
  }

//  get rows {
//    return board.length;
//  }
//
//  get columns {
//    return board[0].cells.length;
//  }

  @override
  String toString() {
    List<String> rows = this.board.map((r) {
      return r.toString();
    }).toList();

    /*
    0   1   2   3
    4   5   6   7
    8   9  10  11
    12  13 14  15
     */

    List<List<GameCell>> items = getRowItems();

    List<String> parts = items.map((l) {
      return l.map((c) {
        return c.toString();
      }).join("|");
    }).toList();

    return parts.join("\n\nOver: ${_isOver}");
  }

  void move(MoveDirection direction) {
    switch (direction) {
      case MoveDirection.up:
        moveUp();
        break;
      case MoveDirection.down:
        moveDown();
        break;
      case MoveDirection.left:
        moveLeft();
        break;
      case MoveDirection.right:
        moveRight();
        break;
    }
  }

  bool get isGameOver => _isOver;

  bool _checkGameOver() {
    /*
    0   1   2   3
    4   5   6   7
    8   9  10  11
    12  13 14  15
     */

    bool isOver = true;

    List<List<GameCell>> colItems = [];

    List<List<GameCell>> rowItems = [];

    for (var i = 0; i < this.board.length; i++) {
      //check empty space
      if (this.board[i].value == null) {
        isOver = false;
        print("Found null");
        break;
      }

      //check column
      var colIndex = i % this.columns;

      if (colItems.length - 1 < colIndex) {
        colItems.add([]);
      }

      if (colItems[colIndex] == null) {
        colItems[colIndex] = [];
      }

      GameCell prevCol =
          (colItems[colIndex].length > 0) ? colItems[colIndex].last : null;

      if (prevCol != null && prevCol.value == this.board[i].value) {
        isOver = false;

        print("Col: ${prevCol} ${board[i]}");
        break;
      }

      colItems[colIndex].add(this.board[i]);

      //check row
      var rowIndex = (i / this.rows).floor();
      if (rowItems.length - 1 < rowIndex) {
        rowItems.add([]);
      }
      if (rowItems[rowIndex] == null) {
        rowItems[rowIndex] = [];
      }
      GameCell prevRow =
          (rowItems[rowIndex].length > 0) ? rowItems[rowIndex].last : null;

      if (prevRow != null && prevRow.value == this.board[i].value) {
        isOver = false;

        print("Row: ${prevRow} ${board[i]}");
        break;
      }

      rowItems[rowIndex].add(this.board[i]);
    }

//    for (var i = 0; i < this.board.length; i++) {
//      if (this.board[i].value == null) {
//        isOver = false;
//        break;
//      }
//
//      int rowIndex = (i / this.rows).floor();
//      int columnIndex = i % this.columns;
//
//      var currentItem = this.board[i];
//
//      try {
//        var nextRow = this.board[rowIndex + i + 1];
//        if (currentItem.value == nextRow.value) {
//          isOver = false;
//          break;
//        }
//      } catch (_) {}
//
//      try {
//        var nextCol = this.board[columnIndex + this.columns];
//        if (currentItem.value == nextCol.value) {
//          isOver = false;
//          break;
//        }
//      } catch (_) {}
//
//      /*
//      if (items.length - 1 < colIndex) {
//        items.add([]);
//      }
//      if (items[colIndex] == null) {
//        items[colIndex] = [];
//      }
//      items[colIndex].add(this.board[i]);
//
//      if (items.length - 1 < rowIndex) {
//        items.add([]);
//      }
//      if (items[rowIndex] == null) {
//        items[rowIndex] = [];
//      }
//      items[rowIndex].add(this.board[i]);
//      */
//
//    }

    _isOver = isOver;

    print("Is Over: ${_isOver}");
    return _isOver;
  }

  void moveDown() {
    List<List<GameCell>> columnCells = getColumnCells();

    print("Columns: ${columnCells}");

    List<GameCell> newBoard = [];
    for (var i = 0; i < columnCells.length; i++) {
      var items = columnCells[i];
      List<GameCell> result = moveItems(items.reversed.toList(), reverse: true);
      newBoard.addAll(result);
    }

    for (var i = 0; i < newBoard.length; i++) {
      var c = newBoard[i];
      this.board[c.index] = c;
    }

    //this.board = newBoard;
    this.regenerateGame();
  }

  void moveRight() {
    List<List<GameCell>> items = getRowItems();

    List<GameCell> newBoard = [];
    for (var i = 0; i < items.length; i++) {
      List<GameCell> result =
          moveItems(items[i].reversed.toList(), reverse: true);
      newBoard.addAll(result);
    }

    for (var i = 0; i < newBoard.length; i++) {
      var c = newBoard[i];
      this.board[c.index] = c;
    }

    //this.board = newBoard;
    this.regenerateGame();
  }

  List<List<GameCell>> getRowItems() {
    List<List<GameCell>> items = [];

    for (var i = 0; i < this.board.length; i++) {
      var rowIndex = (i / this.rows).floor();
      if (items.length - 1 < rowIndex) {
        items.add([]);
      }
      if (items[rowIndex] == null) {
        items[rowIndex] = [];
      }
      items[rowIndex].add(this.board[i]);
    }
    return items;
  }

  void loadGame() {
    this.board = List.generate(this.rows * this.columns, (i) {
      return GameCell(index: i, value: null);
    }).toList();
  }

  void moveLeft() {
    List<List<GameCell>> items = getRowItems();

    List<GameCell> newBoard = [];
    for (var i = 0; i < items.length; i++) {
      List<GameCell> result = moveItems(items[i]);
      newBoard.addAll(result);
    }

    for (var i = 0; i < newBoard.length; i++) {
      var c = newBoard[i];
      this.board[c.index] = c;
    }

    //this.board = newBoard;
    this.regenerateGame();
  }

  void moveUp() {
    /*
    0   1   2   3
    4   5   6   7
    8   9  10  11
    12  13 14  15
     */

    List<List<GameCell>> columns = getColumnCells();

    print("Columns: ${columns}");

    List<GameCell> newBoard = [];
    for (var i = 0; i < columns.length; i++) {
      var items = columns[i];
      List<GameCell> result = moveItems(items);
      newBoard.addAll(result);
    }

    for (var i = 0; i < newBoard.length; i++) {
      var c = newBoard[i];
      this.board[c.index] = c;
    }

    //this.board = newBoard;
    this.regenerateGame();
  }

  List<List<GameCell>> getColumnCells() {
    List<List<GameCell>> items = [];

    for (var i = 0; i < this.board.length; i++) {
      var colIndex = i % this.columns;
      if (items.length - 1 < colIndex) {
        items.add([]);
      }
      if (items[colIndex] == null) {
        items[colIndex] = [];
      }
      items[colIndex].add(this.board[i]);
    }
    return items;
  }

  List<GameCell> moveItems(List<GameCell> row, {reverse = false}) {
    var total = row.length;

    print("Row: ${row.map((r) {
      return "(i: ${r.index}, v: ${r.value})";
    }).toList()}");

    List<GameCell> result = [];
    List<GameCell> empty = [];
    var i = 0;
    while (i < total) {
      GameCell c = row[i];

      if (c.value != null) {
        GameCell nextItem;
        try {
          nextItem = row[i + 1];
        } catch (_) {
          //print(e);
        }

        if (nextItem == null) {
          result.add(c.copyWithValue(c.value));
          i = i + 1;
          continue;
        }

        if (nextItem.value != null) {
          if (nextItem.value == c.value) {
            result.add(c.copyWithValue(c.value + nextItem.value));
            row[i + 1] = nextItem.copyWithValue(null);
          } else {
            result.add(c.copyWithValue(c.value));
          }
        } else {
          var x = 2;
          while (true) {
            try {
              nextItem = row[i + x];
              if (nextItem.value == null) {
                x = x + 1;
                continue;
              }

              if (nextItem.value == c.value) {
                result.add(c.copyWithValue(c.value + nextItem.value));
                row[i + x] = nextItem.copyWithValue(null);
                break;
              } else {
                result.add(c.copyWithValue(c.value));
                break;
              }
            } catch (_) {
              result.add(c.copyWithValue(c.value));
              break;
            }
          }
        }
      } else {
        empty.add(c.copyWithValue(c.value));
      }
      i = i + 1;
    }

    result.addAll(empty);

    // re-arrange indexes
    List<int> indexes = result.map((c) {
      return c.index;
    }).toList()
      ..sort();

    if (reverse) {
      indexes = indexes.reversed.toList();
    }
    print("Indexes: ${indexes}");

    List<GameCell> finalResult = [];
    for (var x = 0; x < result.length; x++) {
      GameCell c = result[x];
      finalResult.add(c.copyWithIndex(indexes[x]));
    }

    print("Result: ${finalResult.map((r) {
      return "(i: ${r.index}, v: ${r.value})";
    }).toList()}");

    return finalResult;
  }

  void regenerateGame() {
    var r = math.Random();

    var emptySlots = this.board.where((c) {
      return c.value == null;
    }).toList();

    if (emptySlots.length == 0) {
      _checkGameOver();
      return;
    }

    var index = r.nextInt(emptySlots.length);

    GameCell c = emptySlots[index];

    this.board[c.index] = c.copyWithValue(2);

    //emptySlots.removeAt(index);

    if (emptySlots.length == 1) {
      _checkGameOver();
      return;
    }
    emptySlots = emptySlots.where((cc) {
      return cc.index != c.index;
    }).toList();

    index = r.nextInt(emptySlots.length);

    c = emptySlots[index];

    this.board[c.index] = c.copyWithValue(2);

    _checkGameOver();
  }
}
