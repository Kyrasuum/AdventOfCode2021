package;
/**
 * ...
 * @author Kyrasuum
 */
typedef Pos = {
    var x: Int;
    var y: Int;
    var z: Int;    
}

typedef Dist = {
    var off: Pos;
    var len: Int;
}

typedef Reorient = {
    var translate: Array<Dynamic>;
}

function length(p: Pos): Int{
    return cast Math.sqrt(
        Math.pow(p.x, 2) +
        Math.pow(p.y, 2) +
        Math.pow(p.z, 2));
}

function reorient(p: Pos, rel: Reorient): Pos{
    var arr = [p.x, p.y, p.z];
    return {
        x: cast rel.translate[0](arr),
        y: cast rel.translate[1](arr),
        z: cast rel.translate[2](arr)
    };
}

function get_rel(from: Pos, to: Pos): Reorient{
    var arr1 = [from.x, from.y, from.z];
    var arr2 = [to.x, to.y, to.z];

    var rel = {translate: []};
    for (fromindex in 0...arr1.length){
        var toindex = cast Math.max(arr2.indexOf(arr1[fromindex]), arr2.indexOf(arr1[fromindex]*-1));
        rel.translate[toindex] = function(p: Array<Int>){
            return p[fromindex] * ((arr1[fromindex] == arr2[toindex])?1:-1);
        }
    }

    return rel;
}

class Beacon {
    public var dists: Array<Dist> = [];
    public var lobs: Map<Probe, Pos> = [];

    public function new(p: Probe, pos: Pos){
        lobs[p] = pos;
    }
    
    public function comp_beacons(from: Pos, to: Pos, other: Beacon){
        var off = {
            x: cast from.x - to.x,
            y: cast from.y - to.y,
            z: cast from.z - to.z
        };
        var len = length(off);

        this.dists.push({
            off: off,
            len: len
        });
        other.dists.push({
            off: {x: off.x*-1, y: off.y*-1, z: off.z*-1},
            len: len
        });
    }

    public function merge(other: Beacon){
        //find a set of offset we can use to translate between the beacons
        var matches = distMatches(other);
        matches = matches.filter(match -> 
            !(match.from.off.x == match.from.off.y ||
            match.from.off.x == match.from.off.z ||
            match.from.off.x*-1 == match.from.off.y ||
            match.from.off.x*-1 == match.from.off.z ||
            match.from.off.y == match.from.off.z ||
            match.from.off.y*-1 == match.from.off.z)
        );
        var rel = get_rel(matches[0].from.off, matches[0].to.off);

        for (probe in other.lobs.keys()){
            lobs[probe] = reorient(other.lobs[probe], rel);
        }
    }

    public function vecMatch(pos1: Pos, pos2: Pos){
        var arr1 = [pos1.x, pos1.y, pos1.z];
        var arr2 = [pos2.x, pos2.y, pos2.z];

        for (dim in arr2){
            if (arr1.contains(dim)){
                arr1.remove(dim);
            } else if (arr1.contains(dim*-1)){
                arr1.remove(dim*-1);
            }
        }
        return arr1.length == 0;
    }

    public function distMatches(other: Beacon): Array<{from: Dist, to: Dist}>{
        var matches = [];
        for (dist1 in dists){
            var to_dists = other.dists.filter(dist2 -> (dist1.len == dist2.len && vecMatch(dist1.off, dist2.off)));
            for (dist2 in to_dists){
                matches.push({from: dist1, to: dist2});
            }
        }
        return matches;
    }
}

class Probe {
    public var num: Int = 0;
    public var beacons: Map<Pos, Beacon> = [];
    public var dists: Map<Probe, Dist> = [];

    public function new(n: Int){
        num = n;
    }

    public function add_dist(from: Pos, to: Pos, other: Probe){
        var off: Pos = {
            x: from.x - to.x,
            y: from.y - to.y,
            z: from.z - to.z
        };
        var len: Int = cast Math.abs(off.x) + Math.abs(off.y) + Math.abs(off.z);
        var dist: Dist = {off: off, len: len};
        dists[other] = dist;
    }

    public function add_beacon(str: String){
        var pos = (str+",0,0,0").split(",");
        if (pos.length <= 4) return;

        var x = Std.parseInt(pos[0]);
        var y = Std.parseInt(pos[1]);
        var z = Std.parseInt(pos[2]);

        var off = {x: x, y: y, z: z};
        var beacon = new Beacon(this, off);
        beacons[off] = beacon;

        for (key in beacons.keys()){
            if (key == off) continue;
            beacon.comp_beacons(off, key, beacons[key]);
        }
    }
}

class Main {
    static public function main() {
        #if sys
        var content = sys.io.File.getContent('input.txt').split("\n");

        var probes: Array<Probe> = [];
        var cur_probe = -1;

        for (i in 0...content.length){
            //verify line has content
            if (content[i].length < 2) continue;
            //check for scanner header
            if (content[i].indexOf("scanner") >= 0){
                cur_probe++;
                probes[cur_probe] = new Probe(cur_probe);
            }else{
                //add beacon positions
                probes[cur_probe].add_beacon(content[i]);
            }
        }

        //find unique beacons from all beacon sightings
        var all_beacons: Array<Beacon> = [];
        var unq_beacons: Array<Beacon> = [];
        
        for (probe in probes){
            all_beacons = all_beacons.concat([for (key in probe.beacons.keys()) probe.beacons[key]]);
        }

        //find duplicate beacons
        while(all_beacons.length > 0){
            var beacon = all_beacons.pop();
            unq_beacons.push(beacon);
            all_beacons = all_beacons.filter(other -> {
                //check if beacon has a duplicate
                var matches = beacon.distMatches(other);
                if (matches.length > 1){
                    beacon.merge(other);
                    return false;
                }
                return true;
            });
        }
        Console.examine(unq_beacons.length);

        //map probe distances from line of bearings
        for (beacon in unq_beacons){
            for (from in beacon.lobs.keys()){
                for (to in beacon.lobs.keys()){
                    //add distances
                    from.add_dist(beacon.lobs[from], beacon.lobs[to], to);
                    to.add_dist(beacon.lobs[to], beacon.lobs[from], from);
                }
            }
        }

        //ensure probes know distance to all other probes
        for (root in probes){
            var len = 0;
            for (key in root.dists.keys()) len++;

            while (len < probes.length){
                for (probe1 => dist1 in root.dists){
                    for (probe2 in probe1.dists.keys()){
                        if (!root.dists.exists(probe2)){
                            var dist2 = probe2.dists[probe1];
                            root.add_dist(dist1.off, dist2.off, probe2);
                            probe2.add_dist(dist2.off, dist1.off, root);
                            len++;
                        }
                    }
                }
            }
        }
        
        //find max distance
        var max_dist = 0;
        for (probe in probes){
            trace(probe.dists);
            for (dist in probe.dists){
                if (dist.len == 3787){
                    trace(dist);
                    trace(probe.num);
                }
                if (dist.len > max_dist) max_dist = dist.len;
            }
        }
        Console.examine(max_dist);
        Console.examine(probes[2].dists[probes[3]]);
        #end
    }
}
