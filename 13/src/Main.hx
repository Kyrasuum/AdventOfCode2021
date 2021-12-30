package;

/**
 * ...
 * @author Kyrasuum
 */

class Main {
    static public function printBoard(points: Array<{x: Int, y: Int}>, maxX: Int, maxY: Int): Array<{x: Int, y: Int}>{
        var board: Array<Array<{x: Int, y: Int}>> = [for (i in 0...maxY) [for (j in 0...(maxX)) null]];
        var remPoints: Array<{x: Int, y: Int}> = [];
        for (point in points){
            if (point.y >= maxY){
                remPoints.push(point);
                continue;
            }
            if (point.x >= maxX){
                remPoints.push(point);
                continue;
            }
            if (board[point.y][point.x] != null){
                remPoints.push(point);
                continue;
            } else {
                board[point.y][point.x] = point;
            }
        }
        points = points.filter(p -> !remPoints.contains(p));

        for (line in board){
            var out = "";
            for (space in line){
                if (space == null){
                    out += ".";
                } else {
                    out += "#";
                }
            }
            Console.println(out);
        }
        return points;
    }

    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        //read points
        var points: Array<{x: Int, y: Int}> = [];
        for (i in 0...lines.length){
            var line = lines[i].split(",");
            if (line.length < 2){
                lines = lines.slice(i+1, lines.length - 1);
                break;
            }
            var x = Std.parseInt(line[0]);
            var y = Std.parseInt(line[1]);
            points.push({x: x, y: y});
        }

        //build board
        points.sort(function(a,b) return b.x - a.x);
        var maxX = points[0].x+1;

        points.sort(function(a,b) return b.y - a.y);
        var maxY = points[0].y+1;

        //commands
        printBoard(points, maxX, maxY);
        for (i in 0...lines.length){
            var line = lines[i];
            Console.println(line);
            
            var index = line.indexOf("=");
            var direc = line.substr(index-1,1);
            var num = Std.parseInt(line.substr(index+1));

            if (direc == "x"){
                for (point in points){
                    if (point.x > num){
                        point.x = num - (point.x - num);
                    }
                    if (point.x == num || point.x < 0){
                        points.remove(point);
                    }
                }
                maxX = num;
            }
            if (direc == "y"){
                for (point in points){
                    if (point.y > num){
                        point.y = num - (point.y - num);
                    }
                    if (point.y == num || point.y < 0){
                        points.remove(point);
                    }
                }
                maxY = num;
            }
            points = printBoard(points, maxX, maxY);
            Console.log(points.length);
        }
        #end
    }
}
