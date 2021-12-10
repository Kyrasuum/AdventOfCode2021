package;

/**
 * ...
 * @author Kyrasuum
 */

class Knowledge{
    public var nums: Array<Array<String>>;
    public var segs: Map<String, Int>;

    public function new(){
        this.nums = [for (i in 0...10) []];
        this.segs = [];
    }

    public function learn(combo: String) {
        switch (combo.length){
            case 2:
                add_knowledge(combo, [1]);
            case 3:
                add_knowledge(combo, [7]);
            case 4:
                add_knowledge(combo, [4]);
            case 7:
                add_knowledge(combo, [8]);
            case 5:
                add_knowledge(combo, [2,3,5]);
            case 6:
                add_knowledge(combo, [0,6,9]);
        }
    }

    public function add_knowledge(combo: String, nums: Array<Int>){
        for (num in nums){
            if (!this.nums[num].contains(combo)){
                this.nums[num].push(combo);
            }
        }
        deduce();
    }

    public function remember(combo: String): Int{
        return this.segs[combo];
    }

    public function deduce(){
        if (this.nums[1].length == 1){
            this.segs[this.nums[1][0]] = 1;
        }
        if (this.nums[4].length == 1){
            this.segs[this.nums[4][0]] = 4;
        }
        if (this.nums[7].length == 1){
            this.segs[this.nums[7][0]] = 7;
        }
        if (this.nums[8].length == 1){
            this.segs[this.nums[8][0]] = 8;
        }
        if (this.nums[9].length != 1){
            deduce_9();
        }
        if (this.nums[6].length != 1){
            deduce_6();
        }
        if (this.nums[0].length == 1){
            this.segs[this.nums[0][0]] = 0;
        }
        if (this.nums[3].length != 1){
            deduce_3();
        }
        if (this.nums[5].length != 1){
            deduce_5();
        }
        if (this.nums[2].length == 1){
            this.segs[this.nums[2][0]] = 2;
        }
    }

    private function deduce_3(){
        if (this.nums[1].length == 1){
            var segs = this.nums[1][0].split("");

            for (i in 0...this.nums[3].length){
                var combo = this.nums[3][i];
                var set = combo.split("").filter(function (char) return segs.contains(char));
                if (set.length == segs.length){
                    this.nums[3] = [combo];
                    this.segs[combo] = 3;

                    this.nums[2].remove(combo);
                    this.nums[5].remove(combo);
                    return;
                }
            }
        }
    }

    private function deduce_5(){
        if (this.nums[6].length == 1){
            var segs = this.nums[6][0];

            for (i in 0...this.nums[5].length){
                var combo = this.nums[5][i];
                var set = segs.split("").filter(function (char) return combo.split("").contains(char));
                if (set.length == combo.length){
                    this.nums[5] = [combo];
                    this.segs[combo] = 5;

                    this.nums[2].remove(combo);
                    this.nums[3].remove(combo);
                    return;
                }
            }
        }
    }

    private function deduce_6(){
        if (this.nums[1].length == 1){
            var segs = this.nums[1][0].split("");

            for (i in 0...this.nums[6].length){
                var combo = this.nums[6][i];
                for (char in segs){
                    if (!combo.split("").contains(char)){
                        this.nums[6] = [combo];
                        this.segs[combo] = 6;

                        this.nums[0].remove(combo);
                        this.nums[9].remove(combo);
                        return;
                    }
                }
            }
        }
    }

    private function deduce_9(){
        if (this.nums[4].length == 1){
            var segs = this.nums[4][0].split("");

            for (i in 0...this.nums[9].length){
                var combo = this.nums[9][i];
                var set = combo.split("").filter(function (char) return segs.contains(char));
                if (set.length == segs.length){
                    this.nums[9] = [combo];
                    this.segs[combo] = 9;

                    this.nums[0].remove(combo);
                    this.nums[6].remove(combo);
                    return;
                }
            }
        }
    }
}

class Main {
    

    static public function main() {
        #if sys
        var content:String = sys.io.File.getContent('input.txt');
        var lines = content.split("\n");

        var count = 0;

        for (i in 0...lines.length){
            if (lines[i].length < 1){
                continue;
            }

            trace("Line: " + i);

            var parts = lines[i].split(" | ");
            var know: Knowledge = new Knowledge();
            var iter = 0;

            for (j in 0...parts.length){
                var combos = parts[j].split(" ");
                for (k in 0...combos.length){
                    var combo = combos[k];
                    var letters = combo.split("");
                    letters.sort(function (a, b) return a.charCodeAt(0) - b.charCodeAt(0));
                    combo = letters.join("");

                    if (j == 0){
                        know.learn(combo);
                    } else {
                        var val = know.remember(combo);
                        trace("Combo: " + combo);
                        trace("Val: " + val);
                        trace("Count: " + count);
                        if (val != null){
                            iter += cast val * Math.pow(10, combos.length - 1 - k);
                        } else {
                            trace("error");
                            trace("Nums: " + know.nums);
                            trace("Segs: " + know.segs);
                            return;
                        }
                    }
                }
            }
            trace("Iter: " + iter);
            count += iter;
            trace("Nums: " + know.nums);
            trace("Segs: " + know.segs);
        }

        trace(count);

        #end
    }
}
