package ly.jamie.oiramrd{
  /**
   * Class to build pills.  Should make use of block factory.
   */
  public class PillFactory{
    private var blockFactory: BlockFactory;

    function PillFactory() {
        trace("Creating myPill factory");
        this.blockFactory = Oiramrd.BF;
    }
    public function getRandomPill(pos1:Point, boolUpToDown:Boolean = true): Pill {
        var ci1: Number = Math.floor(Math.random() * Settings.Shared.pillColorCount());
        var ci2: Number = Math.floor(Math.random() * Settings.Shared.pillColorCount());

        var pos2: Point = boolUpToDown ? new Point(pos1.x, pos1.y + 1) :
            new Point(pos1.x + 1, pos1.y);

        return this.getPill(pos1, ci1, pos2, ci2);
    }
    public function getPill(pos1: Point, colorIndex1: Number, 
                            pos2: Point, colorIndex2: Number): Pill {
        var bf:BlockFactory = this.blockFactory;

        var b1: Block = bf.getBlock ( pos1, colorIndex1 );
        var b2: Block = bf.getBlock ( pos2, colorIndex2 ); 
        var p: Pill = new Pill ( b1, b2 );

        return p;
    }
    public function toString(): String {
        return "<PillFactory>" + this.blockFactory + "</PillFactory>";
    }
  }
}
