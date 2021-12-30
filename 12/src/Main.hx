package;

/**
 * ...
 * @author Kyrasuum
 */
class Cave {
    public var start: Bool;
    public var end: Bool;
    public var big: Bool;
    public var name: String;
    public var paths: Array<Cave>;

    public function new(){
        start = false;
        end = false;
        big = false;
        name = "";
        paths = [];
    }

    public function explore(curpath: String, revisit: Bool): Array<String>{
        var paths: Array<String> = [];
        if (!this.start){
            curpath += "-";
        }
        curpath += this.name;
        
        if (this.end){
            paths.push(curpath);
            return paths;
        }
        for (path in this.paths){
            var cur_revisit = revisit;
            //dont visit small caves more than once
            if (!path.big && curpath.indexOf(path.name + "-") >= 0){
                if (path.start || cur_revisit){
                    continue;
                }
                cur_revisit = true;
            }
            //visit the cave
            paths = paths.concat(path.explore(curpath, cur_revisit));
        }
        return paths;
    }
}

class Main {
    static public function sort(a: String, b: String):Int {
        if (a < b) {
            return -1;
        }
        else if (a > b) {
            return 1;
        } else {
            return 0;
        }
    }
    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        var caves: Map<String, Cave> = [];
        var names: Array<String> = [];

        for (i in 0...lines.length){
            var line = lines[i].split("-");
            for (j in 0...line.length){
                var name = line[j];
                if (!names.contains(name) && name.length > 0){
                    var cave = new Cave();
                    cave.name = name;
                    if (name == "start"){
                        cave.start = true;
                    }
                    if (name == "end"){
                        cave.end = true;
                    }
                    cave.big = name != name.toLowerCase();
                    names.push(name);
                    caves[name] = cave;
                }
            }
            if (line.length > 1){
                var start = line[0];
                var end = line[1];
                caves[start].paths.push(caves[end]);
                caves[end].paths.push(caves[start]);
            }
        }

        var paths: Array<String> = caves["start"].explore("", false);
        paths.sort(function(a,b) return sort(a,b));

        Console.println(names.toString());
        Console.println(caves.toString());

        for (path in paths){
            Console.println(path);
        }
        Console.log(paths.length);
        #end
    }
}
