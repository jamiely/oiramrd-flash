
function Interface(game) {
    this.game = game;
    Key.addListener(this);
    
}

Interface.prototype.toString = function () {
    return "<Interface>" + this.game + "</Interface>";
}

Interface.prototype.onKeyDown = function() {
    trace("Keydown! Ascii=" + Key.getAscii() + " Code=" + Key.getCode());
    
    switch ( Key.getAscii() ) {
        case "g".charCodeAt(0):
            this.game.step();
            trace(this + ": stepped!");
            break;
        case "n".charCodeAt(0):
            trace("Game = " + this.game);
            this.game.insertNextPill();
            trace(this + ": inserted new myPill");
            break;
        case "f".charCodeAt(0):
            trace("Virii fill");
            this.game.viriiFill(.1);
            break;
        case "d".charCodeAt(0):
            trace("dump board");
            this.game.dumpBoard();
            break;
            
    }
    
    ap = this.game.activePill;
    
    if ( ap == undefined ) return;
    
    pp = new PillPusher();
    
    switch ( Key.getCode() ) {
        case Key.RIGHT:
            if ( this.game.canMove ( ap, DIR_RIGHT ) ) {
                pp.right(this.game, ap);
                this.game.display.updatePill(ap);
                trace(this + ": KeyDown RIGHT");
            }
            break;
           
        case Key.LEFT:
            if ( this.game.canMove ( ap, DIR_LEFT ) ) {
                pp.left(this.game, ap);
                this.game.display.updatePill(ap);
                trace(this + ": KeyDown LEFT");
            }
            break;
        case Key.DOWN:
            if ( this.game.canMove ( ap, DIR_DOWN ) ) {
                pp.down(this.game, ap);
                this.game.display.updatePill(ap);
                trace(this + ": KeyDown LEFT");
            }
            break;
        case Key.UP:
            trace ( "\tkey=up ap=" + ap );
            if ( this.game.canRotate(ap, true) ) {
                pp.clockwise(this.game, ap);
                this.game.display.updatePill(ap);
                trace ( this + ": KeyDown UP" );
            }
            
            break;
    }
}

Interface.prototype.onKeyUp = function() {
    
}
