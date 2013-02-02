package ly.jamie.oiramrd{
  public class SearchedBlock{
    public var block: Block;
    public var searched: Object;
    public var matched: Boolean;

    function SearchedBlock ( blk: Block ) {
        this.block = blk;
        this.searched = {
          DIR_UP: false, 
          DIR_RIGHT: false, 
          DIR_DOWN: false, 
          DIR_LEFT: false
        };
        this.matched = false;
    }

    public function reset(): void {
        this.searched = {DIR_UP: false, DIR_RIGHT: false, DIR_DOWN: false, DIR_LEFT: false};
        this.matched = false;
    }

    public function toString(): String {
        return "SearchedBlock: " + this.block.toString();
    }
  }
}
