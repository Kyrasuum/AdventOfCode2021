package;

using thx.Ints;
using thx.BigInt;
import haxe.io.Bytes;
import haxe.crypto.BaseCode;

/**
 * ...
 * @author Kyrasuum
 */
typedef Data = {
    var nums: Array<haxe.Int64>;
    var bin: String;
    var vertotal: Int;
}

class Main {
    static function hextobin(str: String){
        var basehex = Bytes.ofString("0123456789abcdef");
        var basebin = Bytes.ofString("01");
        var bytes = new BaseCode(basehex).decodeBytes(Bytes.ofString(str.toLowerCase()));
        return new BaseCode(basebin).encodeString(bytes.toString());
    }

    static function parseheader(data: Data){
        if (data.bin.length <= 6){
            return data;
        }
    
        var version = Ints.parse(data.bin.substr(0, 3), 2);
        var type = Ints.parse(data.bin.substr(3, 3), 2);
        Console.println("ParseHeader");
        Console.log("Version: " + version);
        Console.log("Type: " + type);

        data.bin = data.bin.substr(6);
        data.vertotal += version;
        if (type == 4){
            data = parsenumber(data);
        } else {
            data = parseoperator(data, type);
        }
        return data;
    }

    static function parsenumber(data: Data){
        if (data.bin.length < 1){
            return data;
        }
        Console.println("ParseNumber");
        var packet = "";
        for (i in 0...Math.floor(data.bin.length / 5)){
            var last = Ints.parse(data.bin.substr(i*5, 1), 2);
            packet += data.bin.substr(i*5 + 1, 4);

            if (last == 0){
                break;
            }
        }
        var packets: Int = cast packet.length / 4;
        var num = BigInt.fromStringWithBase(packet, 2).toInt64();
        Console.log("Literal Number: " + num);
        data.nums.push(num);
        data.bin = data.bin.substr(packets*5);

        return data;
    }

    static function parseoperator(data: Data, type: Int){
        if (data.bin.length <= 12){
            return data;
        }
        var ltype = Ints.parse(data.bin.substr(0, 1), 2);
        Console.println("ParseOperator");

        var old_nums = data.nums;
        data.nums = [];
        if (ltype == 0){
            var length = Ints.parse(data.bin.substr(1, 15), 2);
            Console.log("Length: " + length);

            data.bin = data.bin.substr(16);
            var old_length = data.bin.length;

            while (data.bin.length > old_length - length){
                data = parseheader(data);
            }
        } else {
            var count = Ints.parse(data.bin.substr(1, 11), 2);
            Console.log("Count: " + count);

            data.bin = data.bin.substr(12);
            
            for (i in 0...count){
                data = parseheader(data);
            }
        }

        switch(type){
            case 0:{
                //sum
                var res: haxe.Int64 = cast 0;
                if (data.nums.length > 0){
                    res = data.nums[0];
                    if (data.nums.length > 1){
                        for (i in 1...data.nums.length){
                            res += data.nums[i];
                        }
                    }
                }
                old_nums.push(res);
            }
            case 1:{
                //product
                var res: haxe.Int64 = cast 0;
                if (data.nums.length > 0){
                    res = data.nums[0];
                    if (data.nums.length > 1){
                        for (i in 1...data.nums.length){
                            res *= data.nums[i];
                        }
                    }
                }
                old_nums.push(res);
            }
            case 2:{
                //min
                data.nums.sort(function(a,b){
                    if (a < b) return -1;
                    if (a > b) return 1;
                    return 0;
                });
                old_nums.push(data.nums[0]);
            }
            case 3:{
                //max
                data.nums.sort(function(a,b){
                    if (a < b) return 1;
                    if (a > b) return -1;
                    return 0;
                });
                old_nums.push(data.nums[0]);
            }
            case 5:{
                //greater-than
                old_nums.push((data.nums[0] > data.nums[1]?1:0));
            }
            case 6:{
                //less-than
                old_nums.push((data.nums[0] < data.nums[1]?1:0));
            }
            case 7:{
                //equal-to
                old_nums.push((data.nums[0] == data.nums[1]?1:0));
            }
        }
        data.nums = old_nums;
        
        return data;
    }

    static public function main() {
        #if sys
        var content: String = sys.io.File.getContent('input.txt').split("\n")[0];
        if (content.length % 2 != 0) {
            content += "0";
        }
        var bin = hextobin(content);

        Console.log(bin);
        var data: Data = {nums: [], bin: bin, vertotal: 0};
        data = parseheader(data);
        Console.println("Done");
        Console.log("Version Total: " + data.vertotal);
        Console.log("Result: " + data.nums[0]);
        #end
    }
}
