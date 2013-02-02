package ly.jamie.oiramrd{
  public class PillPusher{
    public function PillPusher() {

    }
    public function down(game:Oiramrd, myPill:Pill): void {
        var bb:BlockBullier = new BlockBullier();

        // top most
        var b1:Block = ( myPill.block1.position.y > myPill.block2.position.y ) ? myPill.block1 : myPill.block2;
        // bottom most
        var b2:Block = ( b1 == myPill.block1 ) ? myPill.block2 : myPill.block1;

        bb.down(game, b2);
        bb.down(game, b1);
        trace(this + ": Down! myPill = " + myPill);
    }
    public function right(game: Oiramrd, myPill: Pill): void {
        var bb:BlockBullier = new BlockBullier();

        // right most
        var b1:Block = ( myPill.block1.position.x > myPill.block2.position.x ) ? myPill.block1 : myPill.block2;
        // left most
        var b2:Block = ( b1 == myPill.block1 ) ? myPill.block2 : myPill.block1;

        // move right most first
        bb.right(game, b1);
        bb.right(game, b2);

        trace(this + ": Down! myPill = " + myPill);
    }
    public function left(game: Oiramrd, myPill: Pill): void {
        var bb:BlockBullier = new BlockBullier();

        // right most
        var b1:Block = ( myPill.block1.position.x > myPill.block2.position.x ) ? myPill.block1 : myPill.block2;
        // left most
        var b2:Block = ( b1 == myPill.block1 ) ? myPill.block2 : myPill.block1;

        // move left most first
        bb.left(game, b2);
        bb.left(game, b1);
        trace(this + ": Down! myPill = " + myPill);
    }

    public function clockwise(game: Oiramrd, myPill: Pill): void {
        this.rotate(game, myPill, true);
    }

    public function counterClockwise(game: Oiramrd, myPill: Pill): void {
        this.rotate(game, myPill, false);
    }

    public function rotate(game: Oiramrd, myPill: Pill, clockwise: Boolean = true): void {
        trace ( this + ":rotate myPill=" + myPill + " clcokwise=" + clockwise);

        var bb:BlockBullier = new BlockBullier();
        // resets position in global memory and screen

        game.dumpBoard();

        trace( "\treset block positions block1=" + myPill.block1 + " block2=" +myPill.block2);
        bb.resetpos(game, myPill.block1);
        game.dumpBoard();
        bb.resetpos(game, myPill.block2);
        game.dumpBoard();

        game.rotatePill(myPill, clockwise);
        // updates position in global memory and screen

        bb.updateBlock(game, myPill.block1);
        bb.updateBlock(game, myPill.block2);
        trace( "\tUpdated block positions block1=" + myPill.block1 + " block2=" +myPill.block2 );

        game.dumpBoard();
    }

    public function toString(): String {
        return "<Pill Pusher>";
    }
  }
}
