package;

/**
 * ...
 * @author Kyrasuum
 */
class Main {
    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var depth = 0;
        var pos = 0;
        var aim = 0;

        for (line in content.split("\n")){
            var words = line.split(" ");
            var cmd = words[0].charAt(0);
            if (cmd == 'u'){
                aim -= Std.parseInt(words[1]);
            } else if (cmd == 'd'){
                aim += Std.parseInt(words[1]);
            } else if (cmd == 'f'){
                pos += Std.parseInt(words[1]);
                depth += aim * Std.parseInt(words[1]);
            }
        }
        trace(depth);
        trace(pos);
        trace(depth*pos);
        #end
    }
}
