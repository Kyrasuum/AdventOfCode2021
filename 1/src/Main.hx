package;

/**
 * ...
 * @author Kyrasuum
 */
class Main {
    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var depth_1 = -1;
        var depth_2 = -1;
        var depth_3 = -1;
        var depth_4 = -1;
        var decreases = 0;
        for (line in content.split("\n")){
            var depth = Std.parseInt(line);
            if (depth != null){
                depth_1 = depth_2;
                depth_2 = depth_3;
                depth_3 = depth_4;
                depth_4 = depth;
                if (depth_1 != -1){
                    if (depth_1 + depth_2 + depth_3 < depth_2 + depth_3 + depth_4) {
                        decreases = decreases + 1;
                    }
                }
            }
        }
        trace(decreases);
        #end
    }
}
