package;

/**
 * ...
 * @author Kyrasuum
 */

class Main {
    static public function checkBoardWin(board: Array<Array<{Num: Int, Called: Bool}>>): Bool {
        var rows = board.filter(line -> line.filter(space -> space.Called == true).length == line.length);
        var cols = [for (col in 0...board[0].length) if ([for (row in board) if (row[col].Called) row].length == board[0].length) col];
        return rows.length >= 1 || cols.length >= 1;
    }

    static public function binToDec(arr: Array<Int>): Int {
        var num = 0;
        for (i in 0...arr.length){
            if (arr[i] == 1){
                num += Std.int(Math.pow(2, arr.length-i-1));
            }
        }
        return num;
    }

    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        var draws = lines[0].split(",");
        var boards: Array<Array<Array<{Num: Int, Called: Bool}>>> = [];

        for (i in 1...lines.length){
            if (lines[i].length == 0){
                boards[boards.length] = [];
            } else {
                var line = lines[i].split(" ").filter(elem -> elem != "");
                var board = boards.length - 1;
                var boardLine = boards[board].length;
                for (j in 0...line.length){
                    if (j == 0){
                        boards[board][boardLine] = [];
                    }
                    boards[board][boardLine][j] = {Num: Std.parseInt(line[j]), Called: false};
                }
            }
        }
        boards = boards.filter(board -> board.length != 0);


        var lastboard = -1;
        for (draw in draws){
            for (board in boards){
                for (line in board){
                    for (space in line){
                        if (space.Num == Std.parseInt(draw)){
                            space.Called = true;
                        }
                    }
                }
            }
            var wins = boards.filter(board -> checkBoardWin(board));
            if (lastboard == -1){
                if (wins.length == boards.length - 1){
                    for (board in boards){
                        if (wins.indexOf(board) < 0){
                            lastboard = boards.indexOf(board);            
                        }
                    }
                }
            } else {
                if (wins.length == boards.length){
                    var board = boards[lastboard];
                    var sum = 0;
                    for (row in board){
                        for (space in row){
                            if (!space.Called){
                                sum += space.Num;
                            }
                        }
                    }
                    trace(sum * Std.parseInt(draw));
                    break;
                }
            }
        }

        #end
    }
}
