function BlockBullier() {
    this.toString = function() {
        return "<BlockBullier>";
    }
    this.resetpos = function(game, blk) {
        x = blk.position.x;
        y = blk.position.y;
        
        game.board[x][y] = BRD_EMPTY;
        game.mcs[x][y] = null;
        
        //trace(this + ": Reseting Position of " + blk);
    }
    this.down = function(game, blk) {
        this.resetpos(game, blk);
        blk.position.y ++;
        this.updateBlock(game, blk);        
    }
    this.right = function(game, blk) {
        this.resetpos(game, blk);
        blk.position.x++;
        this.updateBlock(game, blk);        
    }
    this.left = function(game, blk) {
        this.resetpos(game, blk);
        blk.position.x--;
        this.updateBlock(game, blk);        
    }        
    this.updateBlock = function(game, blk) {
        x = blk.position.x;
        y = blk.position.y;
        game.board[x][y] = BRD_BLOCK;
        game.mcs[x][y] = blk;
        
        //trace(this + ": Updating " + blk);
    }
}
