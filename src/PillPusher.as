function PillPusher() {
    this.down = function(game, myPill) {
        bb = new BlockBullier();
        
        // top most
        b1 = ( myPill.block1.position.y > myPill.block2.position.y ) ? myPill.block1 : myPill.block2;
        // bottom most
        b2 = ( b1 == myPill.block1 ) ? myPill.block2 : myPill.block1;
        
        bb.down(game, b2);
        bb.down(game, b1);
        trace(this + ": Down! myPill = " + myPill);
    }
    this.right = function(game, myPill) {
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
    this.left = function(game, myPill) {
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
    
    this.clockwise = function(game, myPill) {
        this.rotate(game, myPill, true);
    }
    
    this.counterClockwise = function(game, myPill) {
        this.rotate(game, myPill, false);
    }
    
    this.rotate = function(game, myPill, clockwise) {
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
    
    this.toString = function() {
        return "<Pill Pusher>";
    }
    
}
