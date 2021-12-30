package;

/**
 * ...
 * @author Kyrasuum
 */
class Path {
    public var cost: Int;
    public var pathcost: Int;
    public var x: Int;
    public var y: Int;
    public var fromX: Int;
    public var fromY: Int;
    public var ideal: Bool;

    public function new(c: Int, x: Int, y: Int){
        this.cost = c;
        this.pathcost = -1;
        this.x = x;
        this.y = y;
        this.fromX = -1;
        this.fromY = -1;
        this.ideal = false;
    }

    public function neighbors(map: Array<Array<Path>>):Array<Path> {
        var n: Array<Path> = [];

        var p = up(map);
        if (p != null){
            n.push(p);
        }
        
        p = down(map);
        if (p != null){
            n.push(p);
        }
        
        p = left(map);
        if (p != null){
            n.push(p);
        }
        
        p = right(map);
        if (p != null){
            n.push(p);
        }

        return n;
    }

    public function up(map: Array<Array<Path>>):Path {
        if (this.x - 1 >= 0){
            return map[this.x-1][this.y];
        }
        return null;
    }

    public function down(map: Array<Array<Path>>):Path {
        if (this.x + 1 < map.length){
            return map[this.x+1][this.y];
        }
        return null;
    }

    public function left(map: Array<Array<Path>>):Path {
        if (this.y - 1 >= 0){
            return map[this.x][this.y-1];
        }
        return null;
    }

    public function right(map: Array<Array<Path>>):Path {
        if (this.y + 1 < map[this.x].length){
            return map[this.x][this.y+1];
        }
        return null;
    }

    public function print():String {
        return "Point:\n\tX:" + this.x + "\n\tY:" + this.y;
    }
}


class Main {
    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        var map: Array<Array<Path>> = [];

        for (i in 0...lines.length){
            var line = lines[i].split("");
            if (line.length < 2){
                continue;
            }
            map[i] = [];
            for (j in 0...line.length){
                map[i][j] = new Path(Std.parseInt(line[j]), i, j);
            }
        }

        //tile map
        var tiles = 5;
        var tiled_map = [for (i in 0...map.length*tiles) []];
        for (i in 0...map.length){
            for (j in 0...map[i].length){
                for (k in 0...tiles){
                    for (l in 0...tiles){
                        var x = i+map.length*k;
                        var y = j+map[i].length*l;
                        tiled_map[x][y] = new Path((map[i][j].cost + k + l) % 10 + ((map[i][j].cost + k + l) > 9?1:0), x, y);
                    }
                }
            }
        }
        var orig_lenx = map.length;
        var orig_leny = map[0].length;
        map = tiled_map;

        //find cost of each point
        var start = map[0][0];
        start.pathcost = 0;
        start.ideal = true;
        var slice = [start];
        while (slice.length > 0){
            var next: Array<Path> = [];
            var point = slice[0];
            var surrounding = point.neighbors(map);
            for (neighbor in surrounding){
                var cost = point.pathcost + neighbor.cost;

                if (neighbor.pathcost > cost || neighbor.pathcost < 0){
                    neighbor.pathcost = cost;
                    neighbor.fromX = point.x;
                    neighbor.fromY = point.y;
                    
                    slice.push(neighbor);
                }
            }
            slice.remove(point);
            slice.sort(function(a,b){
                if (a.pathcost < 0 && b.pathcost < 0){
                    return a.cost - b.cost;
                }
                if (a.pathcost < 0){
                    return 1;
                }
                if (b.pathcost < 0){
                    return -1;
                }
                return a.pathcost - b.pathcost;
            });

        }

        //track backwards for lowest cost route
        var end = map[map.length-1][map[map.length-1].length-1];
        var point = end;
        while (point != start){
            point.ideal = true;
            point = map[point.fromX][point.fromY];
        }
        //print point costs
        if (0 == 1){
            Console.println("Points Cost");
            for (row in map){
                var print = "";
                for (point in row){
                    if (point.ideal){
                        print += "<red>" + point.cost + "</>";
                    } else {
                        if ((point.y+1) % orig_leny == 0 || (point.x+1) % orig_lenx == 0 || point.x == 0 || point.y == 0){
                            print += "<blue>" + point.cost + "</>";
                        } else {
                            print += point.cost + "";
                        }
                    }
                }
                Console.printlnFormatted(print);
            }
        }

        Console.log(end.pathcost);
        #end
    }
}
