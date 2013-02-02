package ly.jamie.oiramrd {
  import flash.display.MovieClip;

  public class BlockFactory {

    public var mc: MovieClip;

    /**
     * Class to build blocks.
     */
    public function BlockFactory() {
    }

    // @TODO remove the parameter?
    public function getBlock(position:Point, colorIndex:Number): Block {
        return new Block(position, colorIndex, this.mc);
    }
    public function toString(): String {
        return "<BlockFactory />";
    }
  }
}
