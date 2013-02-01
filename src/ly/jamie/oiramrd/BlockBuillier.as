package ly.jamie.oiramrd {
  class BlockBullier {
    function BlockBullier() {
    }

    public function toString(): String {
        return "<BlockBullier>";
    }
    public function resetpos(game, blk): void {
        x = blk.position.x;
        y = blk.position.y;

        game.board[x][y] = BRD_EMPTY;
        game.mcs[x][y] = null;

        trace(this + ": Reseting Position of " + blk);
    }
    public function down(game, blk): void {
        this.resetpos(game, blk);
        blk.position.y ++;
        this.updateBlock(game, blk);
    }
    public function right(game, blk): void {
        this.resetpos(game, blk);
        blk.position.x++;
        this.updateBlock(game, blk);
    }
    public function left(game, blk): void {
        this.resetpos(game, blk);
        blk.position.x--;
        this.updateBlock(game, blk);
    }
    public function updateBlock(game, blk): void {
        x = blk.position.x;
        y = blk.position.y;
        game.board[x][y] = BRD_BLOCK;
        game.mcs[x][y] = blk;

        trace(this + ": Updating " + blk);
    }
  }
}

