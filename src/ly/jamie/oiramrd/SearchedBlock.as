package ly.jamie.oiramrd{
  class SearchedBlock{
    /**
     * Directions
     */
    function SearchedBlock ( blk ) {
        this.block = blk;
        this.searched = {DIR_UP: false, DIR_RIGHT: false, DIR_DOWN: false, DIR_LEFT: false};
        this.matched = false;
        
        this.reset = function() {
            this.searched = {DIR_UP: false, DIR_RIGHT: false, DIR_DOWN: false, DIR_LEFT: false};
            this.matched = false;
        }
        
        this.toString = function() {
            return "SearchedBlock: " + this.block.toString();
        }
    }
  }
}
