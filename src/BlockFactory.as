
/**
 * Class to build blocks.
 */
function BlockFactory() {
    //this.mc =; // the default mc to use to generate blocks
    this.depth = 1;
    this.getBlock = function(position, colorIndex, mc) {
        if ( mc == undefined ) {
            mc = this.mc;
            this.depth ++;
        }
        b = new Block(position, colorIndex, this.mc);
        trace(this + ":getBlock?" + b);
        return b;
    }
    this.toString = function() {
        return "<BlockFactory depth=\"" + this.depth + "\" />";
    }
}
