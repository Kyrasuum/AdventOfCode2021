package;

/**
 * ...
 * @author Kyrasuum
 */
class Octo {
    public var num: Int;
    public var x: Int;
    public var y: Int;

    public function new(n: Int, x: Int, y: Int){
        this.num = n;
        this.x = x;
        this.y = y;
    }

    public function flash(board: Array<Octo>, length: Int): Array<Octo>{
        board = up(board, length);
        board = down(board, length);
        board = left(board, length);
        board = right(board, length);
        board = upleft(board, length);
        board = upright(board, length);
        board = downleft(board, length);
        board = downright(board, length);
        return board;
    }

    public function up(board: Array<Octo>, length: Int): Array<Octo>{
        if (this.x - 1 >= 0){
            board[(x-1) * length + y].num++;
        }
        return board;
    }
    public function down(board: Array<Octo>, length: Int): Array<Octo>{
        if ((this.x + 1) * length + y < board.length){
            board[(x+1) * length + y].num++;
        }
        return board;
    }
    public function left(board: Array<Octo>, length: Int): Array<Octo>{
        if (this.y - 1 >= 0){
            board[x * length + (y-1)].num++;
        }
        return board;
    }
    public function right(board: Array<Octo>, length: Int): Array<Octo>{
        if (this.y + 1 < length){
            board[x * length + (y+1)].num++;
        }
        return board;
    }
    public function upleft(board: Array<Octo>, length: Int): Array<Octo>{
        if (this.x - 1 >= 0 && this.y - 1 >= 0){
            board[(x-1) * length + (y-1)].num++;
        }
        return board;
    }
    public function upright(board: Array<Octo>, length: Int): Array<Octo>{
        if (this.x - 1 >= 0 && this.y + 1 < length){
            board[(x-1) * length + (y+1)].num++;
        }
        return board;
    }
    public function downleft(board: Array<Octo>, length: Int): Array<Octo>{
        if ((this.x + 1) * length + y < board.length && this.y - 1 >= 0){
            board[(x+1) * length + (y-1)].num++;
        }
        return board;
    }
    public function downright(board: Array<Octo>, length: Int): Array<Octo>{
        if ((this.x + 1) * length + y < board.length && this.y + 1 < length){
            board[(x+1) * length + (y+1)].num++;
        }
        return board;
    }
}

class Main {
    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        var board: Array<Octo> = [];
        var length: Int = lines[0].length;

        var flashes = 0;
        
        for (i in 0...lines.length){
            var line = lines[i].split("");
            for (j in 0...line.length){
                board[i*length + j] = new Octo(Std.parseInt(line[j]), i, j);
            }
        }

            
        Console.printlnFormatted("Step 0");
        for (j in 0...cast board.length/length){
            var out: String = "";
            for (k in 0...length){
                var octo = board[j*length+k];
                out += octo.num + " ";
            }
            Console.printlnFormatted(out);
        }

        var i = 0;
        while(true){
            Console.printlnFormatted("Step " + (i+1));
            var flashed: Array<Octo> = [];
            var flashing: Array<Octo> = [];
            do{
                for (octo in flashing){
                    board = octo.flash(board, length);
                    flashed.push(octo);
                }
                flashing = [];
                for (j in 0...cast board.length/length){
                    for (k in 0...length){
                        var octo = board[j*length+k];
                        if (octo.num > 8 && !flashed.contains(octo)){
                            flashing.push(board[j*length+k]);
                        }
                    }
                }
            }while(flashing.length != 0);

            for (j in 0...cast board.length/length){
                for (k in 0...length){
                    var octo = board[j*length+k];
                    octo.num++;
                    if (flashed.contains(octo)){
                        octo.num = 0;
                    }
                }
            }
            
            for (j in 0...cast board.length/length){
                var out: String = "";
                for (k in 0...length){
                    var octo = board[j*length+k];
                    if (flashed.contains(octo)){
                        out += "<white>" + octo.num + "</white> ";
                    } else {
                        out += octo.num + " ";
                    }
                }
                Console.printlnFormatted(out);
            }
            flashes += flashed.length;
            i++;
            if (flashed.length == board.length){
                break;
            }
        }
        Console.log("Flashes: " + flashes);
        #end
    }
}
