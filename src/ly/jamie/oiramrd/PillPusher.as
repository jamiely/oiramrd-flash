package ly.jamie.oiramrd{
  class PillPusher{
    function PillPusher() {

    }
    public function down(game, myPill): void {
        bb = new BlockBullier();

        // top most
        b1 = ( myPill.block1.position.y > myPill.block2.position.y ) ? myPill.block1 : myPill.block2;
        // bottom most
        b2 = ( b1 == myPill.block1 ) ? myPill.block2 : myPill.block1;

        bb.down(game, b2);
        bb.down(game, b1);
        trace(this + ": Down! myPill = " + myPill);
    }
    public function right(game, myPill): void {
        bb = new BlockBullier();

        // right most
        b1 = ( myPill.block1.position.x > myPill.block2.position.x ) ? myPill.block1 : myPill.block2;
        // left most
        b2 = ( b1 == myPill.block1 ) ? myPill.block2 : myPill.block1;

        // move right most first
        bb.right(game, b1);
        bb.right(game, b2);

        trace(this + ": Down! myPill = " + myPill);
    }
    public function left(game, myPill): void {
        bb = new BlockBullier();

        // right most
        b1 = ( myPill.block1.position.x > myPill.block2.position.x ) ? myPill.block1 : myPill.block2;
        // left most
        b2 = ( b1 == myPill.block1 ) ? myPill.block2 : myPill.block1;

        // move left most first
        bb.left(game, b2);
        bb.left(game, b1);
        trace(this + ": Down! myPill = " + myPill);
    }

    public function clockwise(game, myPill): void {
        this.rotate(game, myPill, true);
    }

    public function counterClockwise(game, myPill): void {
        this.rotate(game, myPill, false);
    }

    public function rotate(game, myPill, clockwise): void {
        if ( clockwise == undefined ) clockwise = true;

        trace ( this + ":rotate myPill=" + myPill + " clcokwise=" + clockwise);

        bb = new BlockBullier();
        // resets position in global memory and screen

        game.dumpBoard();

        trace( "\treset block positions block1=" + myPill.block1 + " block2=" +myPill.block2);
        bb.resetPos(game, myPill.block1);
        game.dumpBoard();
        bb.resetPos(game, myPill.block2);
        game.dumpBoard();

        game.rotatePill(myPill, clockwise);
        // updates position in global memory and screen

        bb.updateBlock(game, myPill.block1);
        bb.updateBlock(game, myPill.block2);
        trace( "\tUpdated block positions block1=" + myPill.block1 + " block2=" +myPill.block2 );

        game.dumpBoard();
    }

    public function toString(): void {
        return "<Pill Pusher>";
    }
  }
}
