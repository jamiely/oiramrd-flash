package ly.jamie.oiramrd{
  /**
   * Class to contain myPill information,  A myPill consists of two blocks.
   */
  public class Pill{
    public var block1: Block;
    public var block2: Block;
    private var blocks: Array;

    public function Pill(b1: Block, b2: Block) {
        this.block1 = b1;
        this.block2 = b2;
        this.blocks = new Array(b1, b2);

        trace("b1 = " + b1 + " b2 = " + b2);

        b1.setLinkedBlock(b2); // blocks are connected
    }

    public function toString(): String {
        return "<" + this.block1 + " : " + this.block2 + ">";
    }

    public function copy(): Pill { 
        return new Pill(this.block1.copy(), this.block2.copy());
    }
  }
}
