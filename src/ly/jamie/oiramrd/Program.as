package ly.jamie.oiramrd {
  import flash.display.*;

  class Program extends MovieClip {
    public function gameStart(): void {
        var gameMC:MovieClip = new MovieClip();
        this.addChild(gameMC);

        var OIRAMRD:Oiramrd = new Oiramrd(10, 20);
        var INTERFACE:Interface = new Interface(OIRAMRD); 

        var DISPLAY:Display = new Display(OIRAMRD, gameMC);
        trace(this + ": Created display object.");
        gameMC.x = 85;
        gameMC.y = 175;

        DISPLAY.initialize();
        trace(this + ": Initialized display object.");

        trace(this + ": BF = " + BF);
        Oiramrd.BF.mc = DISPLAY.blocks;

        OIRAMRD.viriiFill(.01);

        OIRAMRD.setScore( 0 );
        clock = 0;

        DISPLAY.setLevel(1);

    }

    public function GetCongratulationsText( s:Number ): void {
        var t = "";
        if ( s < 1000 ) {
            t = "Try again.";
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



    public function onEnterFrame(): void {
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

}

