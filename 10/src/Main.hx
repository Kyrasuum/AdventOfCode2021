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

        var score = 0;
        var scores: Array<haxe.Int64> = [];
        
        for (i in 0...lines.length){
            var syntax: Array<String> = [];
            var line = lines[i].split("");
            for (j in 0...line.length){
                switch (line[j]){
                    case char = '[' |  '(' | '{' | '<':
                        syntax.push(char);
                    case char = ']' |  ')' | '}' | '>':{
                        var opening = syntax.pop();
                        var expected = '';
                        switch (opening){
                            case '[': expected = ']';
                            case '(': expected = ')';
                            case '{': expected = '}';
                            case '<': expected = '>';
                        }
                        if (char != expected){
                            switch (char){
                                case ']': score += 57;
                                case ')': score += 3;
                                case '}': score += 1197;
                                case '>': score += 25137;
                            }
                            syntax = [];
                            break;
                        }
                    }
                }
            }
            scores[i] = 0;
            while (syntax.length > 0){
                var opening = syntax.pop();
                scores[i] *= 5;
                switch (opening){
                    case '[': scores[i] += 2;
                    case '(': scores[i] += 1; 
                    case '{': scores[i] += 3;
                    case '<': scores[i] += 4;
                }
            }
        }
        scores = scores.filter(a -> a > 0);
        scores.sort(function (a, b) return a < b ? -1 : a > b ? 1 : 0);
        
        trace(score);
        trace(scores);
        trace(scores[cast scores.length / 2]);
        #end
    }
}
