package;

/**
 * ...
 * @author Kyrasuum
 */

class Main {
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

        var maxX = 0;
        var maxY = 0;
        var minX = 0;
        var minY = 0;

        var vents: Array<{x1: Int, y1: Int, x2: Int, y2: Int}> = [];
        var board: Array<Array<Int>> = [];

        var lines = content.split("\n");
        for (i in 0...lines.length){
            var ends = lines[i].split("->");
            for (j in 0...ends.length){
                var vec2 = ends[j].split(",");
                if (vec2.length < 2){
                    continue;
                }
                for (k in 0...vec2.length){
                    if (j == 0){
                        if (k == 0) {
                            vents[i] = {x1: 0, y1: 0, x2: 0, y2: 0};
                            vents[i].x1 = Std.parseInt(vec2[k]);
                            if (maxX < vents[i].x1){
                                maxX = vents[i].x1;
                            }
                            
                            if (minX > vents[i].x1){
                                minX = vents[i].x1;
                            }
                        } else {
                            vents[i].y1 = Std.parseInt(vec2[k]);
                            if (maxY < vents[i].y1){
                                maxY = vents[i].y1;
                            }
                            
                            if (minY > vents[i].y1){
                                minY = vents[i].y1;
                            }
                        }
                    } else {
                        if (k == 0){
                            vents[i].x2 = Std.parseInt(vec2[k]);
                            if (maxX < vents[i].x2){
                                maxX = vents[i].x2;
                            }
                            
                            if (minX > vents[i].x2){
                                minX = vents[i].x2;
                            }
                        } else {
                            vents[i].y2 = Std.parseInt(vec2[k]);
                            if (maxY < vents[i].y2){
                                maxY = vents[i].y2;
                            }
                            
                            if (minY > vents[i].y2){
                                minY = vents[i].y2;
                            }
                        }
                    }
                }
            }
        }

        for (x in minX...(maxX+1)){
            board[x] = [];
            for (y in minY...(maxY+1)){
                board[x][y] = 0;
            }
        }

        for (vent in vents){
            var distX = vent.x2 - vent.x1;
            var distY = vent.y2 - vent.y1;
            var length: Int = cast Math.max(Math.abs(distX), Math.abs(distY));
            var dX: Int = cast distX / length;
            var dY: Int = cast distY / length;
            length++;

            for (i in 0...length){
                board[cast vent.y1 + dY * i][cast vent.x1 + dX * i]++;
            }
        }


        var count = 0;
        for (x in 0...board.length){
            for (y in 0...board[x].length){
                if (board[x][y] > 1){
                    count++;
                }
            }
        }

        trace(count);

        #end
    }
}
