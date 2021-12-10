package;

/**
 * ...
 * @author Kyrasuum
 */

class Main {
    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        var fishes: Array<haxe.Int64> = [0,0,0,0,0,0,0,0,0];

        for (i in 0...lines.length){
            var counters = lines[i].split(",");
            for (j in 0...counters.length){
                if (Std.parseInt(counters[j]) != null){
                    fishes[Std.parseInt(counters[j])]++;
                }
            }
        }

        var max_days = 256;
        for (day in 0...max_days){
            fishes = [fishes[1], fishes[2], fishes[3], fishes[4], fishes[5], fishes[6], fishes[0] + fishes[7], fishes[8], fishes[0]];
        }

        var num_fishes: haxe.Int64 = 0;
        for (i in 0...fishes.length){
            num_fishes += fishes[i];
        }
        trace("Fishes: " + num_fishes);

        #end
    }
}
