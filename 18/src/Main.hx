package;

/**
 * ...
 * @author Kyrasuum
 */
class Pair {
    static var expl: Int = 0;
    static var expr: Int = 0;

    public var lp: Dynamic;
    public var rp: Dynamic;

    public function new(lpi: Dynamic, rpi: Dynamic){
        lp = lpi;
        rp = rpi;
    }

    public function add_l(ni: Int){
        lp.add_l(ni);
    }
    
    public function add_r(ni: Int){
        rp.add_r(ni);
    }

    public function magnitude(): Int{
        return cast 3*lp.magnitude() + 2*rp.magnitude();
    }

    public function explode(parent: Pair, depth: Int): Bool{
        //left exploding check
        if (lp.explode(this, depth+1)){
            if (expr != 0){
                rp.add_l(expr);
                expr = 0;
            }
            return true;
        }
        
        //right exploding check
        if (rp.explode(this, depth+1)){
            if (expl != 0){
                lp.add_r(expl);
                expl = 0;
            }
            return true;
        }
        
        //self exploding check
        if (depth > 3){
            expl = cast(lp, Num).n;
            expr = cast(rp, Num).n;
            if (parent.lp == this){
                parent.lp = cast new Num(0);
            }else{
                parent.rp = cast new Num(0);
            }
            return true;
        }
        return false;
    }

    public function split(): Bool{
        //left split
        if (Std.isOfType(lp, Num)){
            var a = cast(lp, Num).n;
            if (a > 9) {
                var b = Math.floor(a/2);
                lp = new Pair(new Num(b), new Num(a-b));
                return true;
            }
        } else {
            if (lp.split()) return true;
        }

        //right split
        if (Std.isOfType(rp, Num)){
            var a = cast(rp, Num).n;
            if (a > 9) {
                var b = Math.floor(a/2);
                rp = new Pair(new Num(b), new Num(a-b));
                return true;
            }
        } else {
            if (rp.split()) return true;
        }
        
        return false;
    }
}
class Num {
    public var n: Int = 0;

    public function new(ni: Int){n = ni;}
    
    public function add_l(ni: Int){
        n += ni;
    }
    
    public function add_r(ni: Int){
        n += ni;
    }
    
    public function magnitude(): Int{
        return n;
    }

    public function explode(parent: Pair, depth: Int): Bool{
        return false;
    }
    
    public function split(): Bool{
        return false;
    }
}

class Main {
    static public function center(str: String): Int{
        var depth = 0;
        for (i in 0...str.length){
            switch(str.charAt(i)){
                case "[": depth++;
                case "]": depth--;
                case ",": if (depth == 1) return i;
                default: continue;
            }
        }
        return -1;
    }

    static public function parse(str: String): Dynamic{
        var opening = str.indexOf("[");
        var closing = str.lastIndexOf("]");
        
        if (opening < 0 || closing < 0){
            //simple number
            return new Num(Std.parseInt(str));
        }

        var center = center(str);

        return new Pair(
            parse(str.substr(opening+1, center-opening-1)),
            parse(str.substr(center+1, closing-center-1))
        );
    }

    static public function print(p: Pair): String{
        if (Std.isOfType(p, Num)){
            return "" + cast(p, Num).n;
        }
        return "[" + print(p.lp) + "," + print(p.rp) + "]";
    }
    
    static public function main() {
        #if sys
        var content = sys.io.File.getContent('input.txt').split("\n");

        var ladd = parse(content[0]);
        Console.println(print(ladd)+"\n");
        for (i in 1...content.length){
            if (content[i].length < 2) continue;
            var radd = parse(content[i]);
            var sum = new Pair(ladd, radd);
            
            Console.println("   " + print(ladd) + "\n + " + print(radd));
            while (sum.explode(sum, 0) || sum.split()){}
            ladd = sum;
        }
        Console.println("\n = " + print(ladd) + "\n");
        Console.log(ladd.magnitude());

        var max = 0;
        for (i in 0...content.length){
            if (content[i].length < 2) continue;
            var lp = parse(content[i]);
            for (j in 0...content.length){
                if (content[j].length < 2) continue;
                if (i != j){
                    var rp = parse(content[j]);
                    var sum = new Pair(lp, rp);
                    while (sum.explode(sum, 0) || sum.split()){}
                    var mag = sum.magnitude();
                    if (mag > max) max = mag;
                }
            }
        }
        Console.log(max);
        #end
    }
}
