/**
 * Directions
 */
 
SB_NORTH = 1;
SB_EAST = 2;
SB_SOUTH = 3;
SB_WEST = 4;

function SearchedBlock ( blk ) {
    this.block = blk;
    this.searched = {SB_NORTH: false, SB_EAST: false, SB_SOUTH: false, SB_WEST: false};
    this.matched = false;
    
    this.reset = function() {
        this.searched = {SB_NORTH: false, SB_EAST: false, SB_SOUTH: false, SB_WEST: false};
        this.matched = false;
    }
    
    this.toString = function() {
        return "SearchedBlock: " + this.block.toString();
    }
}