package;

/**
 * ...
 * @author Kyrasuum
 */

class Main {

    static public function distance(crabs: Array<Int>, cache: Array<Int>, point: Int): Int {
        var dist = 0.0;
        for (crab in crabs){
            dist += cache[cast Math.abs(crab - point)];
        }
        return cast dist;
    }

    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        var crabs: Array<Int> = [];

        for (i in 0...lines.length){
            var positions = lines[i].split(",");
            for (j in 0...positions.length){
                if (null != Std.parseInt(positions[j])){
                    crabs[crabs.length] = Std.parseInt(positions[j]);
                }
            }
        }
        crabs.sort((a,b) -> a - b);

        var cache: Array<Int> = [];
        for (i in crabs[0]...(crabs[crabs.length-1]+1)){
            if (i == 0){
                cache[i-crabs[0]] = 0;
            } else {
                cache[i-crabs[0]] = cache[i-crabs[0]-1] + i-crabs[0];
            }
        }
        trace(cache);

        var fuel = 0.0;
        var median = 0;
        for (point in crabs[0]...crabs[crabs.length-1]){
            var dist = distance(crabs, cache, point);
            if (fuel == 0.0 || dist < fuel){
                fuel = dist;
                median = point;
            }
        }

        trace("Crabs: " + crabs);
        trace("Median: " + median);
        trace("Fuel: " + fuel);

        #end
    }
}
