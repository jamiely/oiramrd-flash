package ly.jamie.oiramrd{
  public class SearchedBlock{
    public var block: Block;
    public var searched: Object;
    public var matched: Boolean;

    function SearchedBlock ( blk: Block ) {
      if(!blk) throw new Error("No null block allowed");
        this.block = blk;
        this.searched = {
          DIR_UP: false, 
          DIR_RIGHT: false, 
          DIR_DOWN: false, 
          DIR_LEFT: false
        };
        this.matched = false;
    }

    public function hasColorIndex(colorIndex: Number): Boolean {
      return this.block && this.block.colorIndex == colorIndex;
    }

    public function reset(): void {
        this.searched = {DIR_UP: false, DIR_RIGHT: false, DIR_DOWN: false, DIR_LEFT: false};
        this.matched = false;
    }

    public function toString(): String {
      return this.block ? "SearchedBlock: " + this.block.toString() : "SearchedBlock with no block";
    }
  }
}
