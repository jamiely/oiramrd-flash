package ly.jamie.oiramrd{
  class VirusFactory{
    /**
     * Class to build virii.
     */
    function VirusFactory() {
        this.blockFactory = BF;
    }
    public function getVirus(position:Point, colorIndex:Number): void {
        blk = this.blockFactory.getBlock(position, colorIndex);
        blk.canFall = false;
        return blk;
    }
    public function toString(): void {
        return "<VirusFactory>" + this.blockFactory + "</VirusFactory>";
    }
  }
}
