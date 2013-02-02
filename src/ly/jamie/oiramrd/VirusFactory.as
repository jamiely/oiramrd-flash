package ly.jamie.oiramrd{
  /**
   * Class to build virii.
   */
  public class VirusFactory{
    private var blockFactory: BlockFactory;
    public function VirusFactory() {
        this.blockFactory = Oiramrd.BF;
    }
    public function getVirus(position:Point, colorIndex:Number): Block {
        var blk: Block = this.blockFactory.getBlock(position, colorIndex);
        blk.canFall = false;
        return blk;
    }
    public function toString(): String {
        return "<VirusFactory>" + this.blockFactory + "</VirusFactory>";
    }
  }
}
