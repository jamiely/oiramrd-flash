#include "Oiramrd.as"

// oiramrd.as
_root.createEmptyMovieClip("game", 10);
trace(this + ": Created empty movie clip for game.")

OIRARMD = new Oiramrd(10, 20);
trace(this + ": Created game object.");
INTERFACE = new Interface(OIRARMD); 

DISPLAY = new Display(OIRARMD, _root.game);
trace(this + ": Created display object.");
_root.game._x = 55;
_root.game._y = 105;

DISPLAY.initialize();
trace(this + ": Initialized display object.");

trace(this + ": BF = " + BF);
BF.mc = DISPLAY.blocks;

// myPill = new Pill(
    // new Block(new Point(1, 1), 1, null),
    // new Block(new Point(1, 2), 1, null))
    
// trace(myPill)

// cpy = myPill.copy();
// cpy.block1.position.x = 10;

// trace(myPill);
// trace(cpy);


// myBlk = new Pill(new Block(new Point(1, 1), 1, null));
// cpy = myBlk.copy();
// cpy.position.x = 10;

// trace(myBlk);
// trace(cpy);

clock = 0;
this.onEnterFrame = function() {
    this.clock ++;    
    if ( this.clock % 6 == 0 ) 
        OIRARMD.applyGravity();
}