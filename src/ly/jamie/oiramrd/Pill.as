package ly.jamie.oiramrd{
  class Pill{
    /**
     * Class to contain myPill information,  A myPill consists of two blocks.
     */
    function Pill(b1, b2) {
        this.block1 = b1;
        this.block2 = b2;
        this.blocks = new Array(b1, b2);
        
        trace("b1 = " + b1 + " b2 = " + b2);
        
        b1.setLinkedBlock(b2); // blocks are connected
        
    }
    
    public function toString(): void {
        return "<" + this.block1 + " : " + this.block2 + ">";
    }
    
    public function copy(): void { 
        return new Pill(this.block1.copy(), this.block2.copy());
    }
  }
}
