package;

/**
 * ...
 * @author Kyrasuum
 */
class Main {
    static public function main() {
        #if sys
        var content: String = sys.io.File.getContent('input.txt').split("\n")[0];
        
        var x1_ind = content.indexOf("x=");
        var x2_ind = content.substr(x1_ind).indexOf("..") + x1_ind;

        var y1_ind = content.indexOf("y=");
        var y2_ind = content.substr(y1_ind).indexOf("..") + y1_ind;

        var x1 = Std.parseInt(content.substr(x1_ind+2, x2_ind-x1_ind-2));
        var x2 = Std.parseInt(content.substr(x2_ind+2, y1_ind-x2_ind-2));

        var y1 = Std.parseInt(content.substr(y1_ind+2, y2_ind-y1_ind-2));
        var y2 = Std.parseInt(content.substr(y2_ind+2));

        var farx: Int = cast Math.max(Math.abs(x1), Math.abs(x2));
        var clsx: Int = cast Math.min(Math.abs(x1), Math.abs(x2));
        var fary: Int = cast Math.max(Math.abs(y1), Math.abs(y2));

        //ensure x2 is left of x1
        if (x2 > x1){
            var tx = x2;
            x2 = x1;
            x1 = tx;
        }

        //ensure y2 is below y1
        if (y2 > y1){
            var ty = y2;
            y2 = y1;
            y1 = ty;
        }

        //calcuate x components
        var velx = 0;
        var steps = 0;
        var distx = 0;
        var validx: Array<Int> = [];
        for (i in 1...cast Math.abs(farx)){
            if (distx + i > Math.abs(farx)) break;
            velx = i;
            steps++;
            distx += i;
        }
        //apply sign component for x
        var signx = (x2 < 0)?-1:1;
        velx *= signx;
        distx *= signx;

        //calculate y component
        var vely = 0;
        var maxy = 0;
        for (i in 1...cast Math.abs(fary)){
            var ty = 0;
            var tvely = i + steps;
            var tmaxy = 0;
            while (true){
                if (ty <= y1 && ty >= y2 && ty+tvely < y2){
                    vely = i + steps;
                    maxy = tmaxy;
                    break;
                }
                if (ty > tmaxy){
                    tmaxy = ty;
                }
                ty += tvely;
                tvely--;
                if (ty < y2 && tvely < 0) break;
            }
        }

        //just brute force the combos... :(
        var valid_vel: Array<{x: Int, y: Int}> = [];
        for (vx in 0...cast Math.abs(farx)+1){
            for (vy in (cast Math.min(0,y2))... cast Math.abs(fary)+1){
                var px = 0;
                var py = 0;
                var vxi = signx * vx;
                var vyi = vy;
                while (vyi >= Math.min(0,y2) || py >= y2){
                    if (px <= x1 && px >= x2 && py <= y1 && py >= y2){
                        valid_vel.push({x: vx, y: vy});
                        break;
                    }
                    px += vxi;
                    py += vyi;
                    vxi = (vxi > 0)? vxi-1: (vxi < 0)? vxi+1: 0;
                    vyi--;
                }
            }
        }

        Console.println("Velocity: (" + velx + "," + vely + ")\nSteps: " + steps);
        Console.log(maxy);
        Console.log(valid_vel);
        Console.log(valid_vel.length);

        #end
    }
}
