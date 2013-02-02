package ly.jamie.oiramrd {
  public class BlockBullier {
    public function BlockBullier() {
    }

    public function toString(): String {
        return "<BlockBullier>";
    }
    public function resetpos(game:Oiramrd, blk:Block): void {
        var x:Number = blk.position.x;
        var y:Number = blk.position.y;

        game.board[x][y] = Constants.BRD_EMPTY;
        game.mcs[x][y] = null;
    }
    public function down(game:Oiramrd, blk:Block): void {
        this.resetpos(game, blk);
        blk.position.y ++;
        this.updateBlock(game, blk);
    }
    public function right(game:Oiramrd, blk:Block): void {
        this.resetpos(game, blk);
        blk.position.x++;
        this.updateBlock(game, blk);
    }
    public function left(game:Oiramrd, blk:Block): void {
        this.resetpos(game, blk);
        blk.position.x--;
        this.updateBlock(game, blk);
    }
    public function updateBlock(game:Oiramrd, blk:Block): void {
        var x:Number = blk.position.x;
        var y:Number = blk.position.y;
        game.board[x][y] = Constants.BRD_BLOCK;
        game.mcs[x][y] = blk;
    }
  }
}
