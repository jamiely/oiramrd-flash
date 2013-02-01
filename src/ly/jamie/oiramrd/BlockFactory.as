package ly.jamie.oiramrd {
  class BlockFactory {
    /**
     * Class to build blocks.
     */
    function BlockFactory() {
        //this.mc =; // the default mc to use to generate blocks
        this.depth = 1;
    }

    public function getBlock(position, colorIndex, mc): Block {
        if ( mc == undefined ) {
            mc = this.mc;
            this.depth ++;
        }
        b = new Block(position, colorIndex, this.mc);
        trace(this + ":getBlock?" + b);
        return b;
    }
    public function toString(): String {
        return "<BlockFactory depth=\"" + this.depth + "\" />";
    }
  }
}
