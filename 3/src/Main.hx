package;

/**
 * ...
 * @author Kyrasuum
 */
class Main {
    static public function binToDec(arr: Array<Int>): Int {
        var num = 0;
        for (i in 0...arr.length){
            if (arr[i] == 1){
                num += Std.int(Math.pow(2, arr.length-i-1));
            }
        }
        return num;
    }

    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");
        var numbers: Array<Array<Int>> = [];

        for (i in 0...lines.length){
            var line = lines[i];
            for (j in 0...line.length){
                if (j == 0){
                    numbers[i] = [];
                }
                var char = line.charAt(j);
                numbers[i][j] = Std.parseInt(char);
            }
        }

        var lslines: Array<Int> = [for(i in 0...numbers.length) i];
        var o2lines: Array<Int> = [for(i in 0...numbers.length) i];

        var x = 0;
        while(lslines.length > 1){
            var total = lslines.length;
            var count = 0;
            for (line in lslines){
                count+=numbers[line][x];
            }
            if (total / 2 > count){
                lslines = lslines.filter(y -> numbers[y][x] == 0);
            } else {
                lslines = lslines.filter(y -> numbers[y][x] == 1);                
            }
            x++;
        }
        
        x = 0;
        while(o2lines.length > 1){
            var total = o2lines.length;
            var count = 0;
            for (line in o2lines){
                count+=numbers[line][x];
            }
            if (total / 2 > count){
                o2lines = o2lines.filter(y -> numbers[y][x] == 1);
            } else {
                o2lines = o2lines.filter(y -> numbers[y][x] == 0);                
            }
            x++;
        }

        trace(numbers[lslines[0]]);
        trace(binToDec(numbers[lslines[0]]));
        
        trace(numbers[o2lines[0]]);
        trace(binToDec(numbers[o2lines[0]]));

        trace(binToDec(numbers[lslines[0]]) * binToDec(numbers[o2lines[0]]));

        #end
    }
}
