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
        
        if ( OIRAMRD.isGameOver() ) {
            
            _root.createTextField ( "tf",
                9999,
                0, 
                0,
                200,
                200 );
                
            var tform = new TextFormat();
            tform.bold = true;
            tform.url = "http://www.angelforge.com";
            
            _root.tf.setTextFormat ( tform );
            
            _root.tf.multiline = true;
            _root.tf.text = "Game Over.\n" + this.GetCongratulationsText(OIRAMRD.score) + "\nYour Score: " + OIRAMRD.score + "\n\nangelforge.com";
            
            _root.game.removeMovieClip();
            
            this.onEnterFrame = undefined;
            
            
        }
        if ( this.clock % OIRAMRD.ticksPerStep == 0 )  OIRAMRD.applyGravity();
    }
}

this.GetCongratulationsText = function( s ) {
    var t = "";
    if ( s < 1000 ) {
        t = "You suck.";
    } 
    else if ( s < 5000 ) {
        t = "You're not bad.";
    }
    else if ( s < 10000 ) {
        t = "You're good.";
    }
    else {
        t = "You're too good. You must be Jamie.";
    }
    return t;
}

gameStart();