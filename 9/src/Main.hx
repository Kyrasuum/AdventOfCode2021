package;

/**
 * ...
 * @author Kyrasuum
 */
class Basin {
    public var points: Array<Point>;

    public function new(){
        points = [];
    }

    //find all points in contigious region from pit
    public function fill(point: Point, arr: Array<Array<Int>>){
        trace("");
        trace("");
        trace("Pit: " + point.print());
        trace("==================");
        this.points.push(point);

        var depth = point.n+1;
        while (depth < 10){
            var ridge: Array<Point> = []; //points going to be added this loop cycle
            var slice: Array<Point> = []; //points being looked at currently
            //find initial points at next depth
            for (i in 0...this.points.length){
                var edge = neighbors(this.points[i], depth, arr);
                for (p in edge){
                    if (!contains(slice, p)){
                        slice.push(p);
                    }
                }
                trace("edge:");
                trace(edge);
                for (a in edge){
                    trace("\t" + a.print());
                }
                trace("");
                
            }
            trace("slice:");
            trace(slice);
            for (a in slice){
                trace("\t" + a.print());
            }
            trace("");
            while(slice.length != 0){
                //check for boundaries
                for (p in slice){
                    var edge = [p.left(arr), p.right(arr), p.up(arr), p.down(arr)];
                    edge = edge.filter(a -> a != null && !contains(slice, a) && !contains(ridge, a) && !contains(this.points, a) && p.ridge(a));
                    if (edge.length != 0){
                        //found a boundary to another basin
                        slice = [];
                        depth = 9;
                        break;
                    }
                }

                //find connected same depth regions
                ridge = ridge.concat(slice);
                slice = [];
                for (i in 0...ridge.length){
                    var edge = neighbors(ridge[i], depth, arr);
                    edge = edge.filter(a -> a != null && !contains(slice, a) && !contains(ridge, a) && !contains(this.points, a));
                    slice = slice.concat(edge);
                }
                trace("slice:");
                trace(slice);
                for (a in slice){
                    trace("\t" + a.print());
                }
                trace("");
                
                trace("ridge:");
                trace(ridge);
                for (a in ridge){
                    trace("\t" + a.print());
                }
                trace("");
            }
            //add ridge to basin
            this.points = this.points.concat(ridge);

            trace("points:");
            trace(points);
            for (a in points){
                trace("\t" + a.print());
            }
            trace("Depth: " + depth);
            trace("==================");
            depth++;
        }
    }

    public function contains(arr: Array<Point>, point: Point): Bool{
        return arr.filter(a -> a.equals(point)).length > 0;
    }

    public function neighbors(point: Point, depth: Int, arr: Array<Array<Int>>): Array<Point>{
        var slice: Array<Point> = [];

        var p = up(point, depth, arr);
        if (p != null){
            slice.push(p);
        }
        
        p = down(point, depth, arr);
        if (p != null){
            slice.push(p);
        }
        
        p = left(point, depth, arr);
        if (p != null){
            slice.push(p);
        }

        p = right(point, depth, arr);
        if (p != null){
            slice.push(p);
        }

        return slice;
    }
    
    public function up(point: Point, depth: Int, arr: Array<Array<Int>>): Point{
        var p = point.up(arr);
        if (p != null && p.n == depth && !this.points.contains(p)){
            return p;
        }
        return null;
    }
    
    public function down(point: Point, depth: Int, arr: Array<Array<Int>>): Point{
        var p = point.down(arr);
        if (p != null && p.n == depth && !this.points.contains(p)){
            return p;
        }
        return null;
    }
    
    public function left(point: Point, depth: Int, arr: Array<Array<Int>>): Point{
        var p = point.left(arr);
        if (p != null && p.n == depth && !this.points.contains(p)){
            return p;
        }
        return null;
    }
    
    public function right(point: Point, depth: Int, arr: Array<Array<Int>>): Point{
        var p = point.right(arr);
        if (p != null && p.n == depth && !this.points.contains(p)){
            return p;
        }
        return null;
    }
}

class Point {
    public var x: Int;
    public var y: Int;
    public var n: Int;

    public function new(x: Int, y: Int, n: Int){
        this.x = x;
        this.y = y;
        this.n = n;
    }

    static public function inBounds(x: Int, y: Int, arr: Array<Array<Int>>): Bool{
        return (x >= 0 && y >= 0 && x < arr.length && y < arr[x].length);
    }
    
    public function pit(arr: Array<Array<Int>>): Bool{
        return smaller(up(arr)) && smaller(down(arr)) && smaller(left(arr)) && smaller(right(arr));
    }

    public function smaller(point: Point): Bool{
        if (point != null){
            return this.n < point.n;
        }
        return true;
    }

    public function ridge(point: Point): Bool{
        if (point != null){
            return this.n >= point.n;
        }
        return true;
    }

    public function up(arr: Array<Array<Int>>): Point{
        if (Point.inBounds(this.x, this.y-1, arr)){
            return new Point(this.x, this.y-1, arr[this.x][this.y-1]);
        }
        return null;
    }
    
    public function down(arr: Array<Array<Int>>): Point{
        if (Point.inBounds(this.x, this.y+1, arr)){
            return new Point (this.x, this.y+1, arr[this.x][this.y+1]);
        }
        return null;
    }
    
    public function left(arr: Array<Array<Int>>): Point{
        if (Point.inBounds(this.x-1, this.y, arr)){
            return new Point (this.x-1, this.y, arr[this.x-1][this.y]);
        }
        return null;
    }
    
    public function right(arr: Array<Array<Int>>): Point{
        if (Point.inBounds(this.x+1, this.y, arr)){
            return new Point (this.x+1, this.y, arr[this.x+1][this.y]);
        }
        return null;
    }

    public function equals(point: Point): Bool{
        return this.x == point.x && this.y == point.y && this.n == point.n;
    }

    public function print(): String{
        return "Point: " + this.x + ", " + this.y + ", " + this.n;
    }
}

class Main {

    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        var height: Array<Array<Int>> = [];

        for (i in 0...lines.length){
            var line = lines[i].split("");
            for (j in 0...line.length){
                if (j == 0){
                    height[i] = [];
                }
                height[i][j] = Std.parseInt(line[j]);
            }
        }

        var pits: Array<Point> = [for (x in 0...height.length) for (y in 0...height[x].length) {
            var p = new Point(x, y, height[x][y]); if (p.pit(height)) p;}];

        var risk = 0;
        var basins: Array<Basin> = [for (pit in pits) {var b = new Basin(); b.fill(pit, height); b;}];
        var sizes: Array<Int> = [];

        for (pit in pits){
            risk += pit.n + 1;
        }

        for (basin in basins){
            sizes[sizes.length] = basin.points.length;
        }
        sizes.sort(function (a,b) return a - b);
        var answer = sizes[sizes.length-1] * sizes[sizes.length-2] * sizes[sizes.length-3];

        trace(height);
        trace("Pits: " + pits);
        trace("Risk: " + risk);
        trace("Sizes: " + sizes);
        trace("Greatest Sizes: " + answer);

        #end
    }
}
