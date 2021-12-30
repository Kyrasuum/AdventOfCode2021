package;

/**
 * ...
 * @author Kyrasuum
 */

class Count {
    public var count: Map<String, haxe.Int64>;

    public function new(){
        this.count = [];
    }
}

class Main {
    static public function add_counts(lpair: Count, rpair: Count): Count{
        var npair = new Count();
        for (lkey in lpair.count.keys()){
            npair.count[lkey] = lpair.count[lkey];
        }
        for (rkey in rpair.count.keys()){
            if (npair.count[rkey] != null){
                npair.count[rkey] += rpair.count[rkey];
            } else {
                npair.count[rkey] = rpair.count[rkey];
            }
        }
        return npair;
    }

    static public function discover_pattern(start: String, pairs: Map<String, String>):Array<String> {
        var pair = start;
        var cycle: Array<String> = [];
        var res = pairs[pair];

        while(res != pair.charAt(1) || cycle.length == 0){
            cycle.push(res);
            pair = start.charAt(0) + res;
            res = pairs[pair];

            //find cyclic character patterns
            if (cycle.contains(res)){
                var index = cycle.lastIndexOf(res);
                var post = cycle.slice(index);
                var pre = cycle.slice(0, index).filter(res -> post.contains(res));
                if (post.length == pre.length){
                    index = cycle.indexOf(res);
                    res = res + cycle[cycle.length-1];
                    cycle = cycle.slice(0, index);
                    cycle.push(res);
                    break;
                }
            }
        }
        return cycle;
    }

    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        //setup template and pairs
        var template: String = lines[0];
        var pairs: Map<String, String> = [];

        //read pair insertions
        for (i in 2...lines.length){
            var line = lines[i].split(" -> ");
            if (line.length == 2){
                var pair = line[0];
                var insertion = line[1];
                pairs[pair] = insertion;
            }
        }

        //discover generation patterns
        var patterns: Array<Map<String, Count>> = [];
        var levels = 40;

        for (level in 0...levels){
            patterns[level] = [];
            for (pair in pairs.keys()){
                if (level != 0){
                    var lpair = patterns[level-1][pair.charAt(0) + pairs[pair]];
                    var rpair = patterns[level-1][pairs[pair] + pair.charAt(1)];
                    if (lpair == null){
                        trace(pair.charAt(0) + pairs[pair]);
                        trace(level-1);
                        continue;
                    }
                    if (rpair == null){
                        trace(pairs[pair] + pair.charAt(1));
                        trace(level-1);
                        continue;
                    }
                    patterns[level][pair] = add_counts(lpair, rpair);
                } else {
                    patterns[level][pair] = new Count();
                }
                if (patterns[level][pair].count[pairs[pair]] == null){
                    patterns[level][pair].count[pairs[pair]] = haxe.Int64.ofInt(0);
                }
                patterns[level][pair].count[pairs[pair]] += haxe.Int64.ofInt(1);
            }
        }

        var count = new Count();
        count.count[template.charAt(0)] = 1;
        for (i in 0...(template.length-1)){
            var subtemp = template.substring(i, i+2);
            if (count.count[subtemp.charAt(1)] == null){
                count.count[subtemp.charAt(1)] = haxe.Int64.ofInt(0);
            }
            count.count[subtemp.charAt(1)]+= haxe.Int64.ofInt(1);
            count = add_counts(count, patterns[levels-1][subtemp]);
        }
        Console.println(count.count.toString());

        var max: haxe.Int64 = 0;
        var min: haxe.Int64 = 0;
        for (num in count.count){
            if (num > max){
                max = num;
            }
            if (num < min || min == 0){
                min = num;
            }
        }
        Console.log("Min: " + min);
        Console.log("Max: " + max);
        Console.log(max - min);
        #end
    }
}
