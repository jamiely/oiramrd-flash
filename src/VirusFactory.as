/**
 * Class to build virii.
 */
function VirusFactory() {
    this.blockFactory = BF;
    this.getVirus = function(position, colorIndex) {
        blk = this.blockFactory.getBlock(position, colorIndex);
        blk.canFall = false;
        return blk;
    }
    this.toString = function() {
        return "<VirusFactory>" + this.blockFactory + "</VirusFactory>";
    }
}
