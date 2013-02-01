#include "Oiramrd.as"


function gameStart() {
    // oiramrd.as
    _root.createEmptyMovieClip("game", 10);
    trace(this + ": Created empty movie clip for game.")

    OIRAMRD = new Oiramrd(10, 20);
    trace(this + ": Created game object.");
    INTERFACE = new Interface(OIRAMRD); 

    DISPLAY = new Display(OIRAMRD, _root.game);
    trace(this + ": Created display object.");
    _root.game._x = 85;
    _root.game._y = 175;

    DISPLAY.initialize();
    trace(this + ": Initialized display object.");

    trace(this + ": BF = " + BF);
    BF.mc = DISPLAY.blocks;

    OIRAMRD.viriiFill(.01);
    
    OIRAMRD.setScore( 0 );
    clock = 0;
    
    DISPLAY.setLevel(1);
    
    this.onEnterFrame = function() {
        this.clock ++;    
        
        if ( this.clock % OIRAMRD.ticksPerStep == 0 )  OIRAMRD.applyGravity();
    }
}

gameStart();