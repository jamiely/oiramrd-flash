package ly.jamie.oiramrd {
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;

  public class Program extends MovieClip {
    private var game: MovieClip;
    private var boundOnEnterFrame: Function;
    private var clock: Number;
    private var oiramrd: Oiramrd;
    private var txtDebug: TextField;
    private var isPaused: Boolean = false;

    public function Program() {
      //this.drawBackground();
      //debug("Background drawn");
      try {
        this.startGame();
        debug("Game started");
      }
      catch(ex: *) {
        debug("Problem starting game: " + ex.message);
      }
    }

    private function debug(msg: String): void {
      if(!this.txtDebug) {
        this.txtDebug = new TextField();
        this.txtDebug.width = 400;
        this.txtDebug.height = 800;
        this.txtDebug.x = 200;
        this.txtDebug.opaqueBackground = 0xeeeeee;
        this.addChild(this.txtDebug);
      }
      this.txtDebug.text = msg + "\n" + this.txtDebug.text;
    }

    private function drawBackground(): void {
      var g:Graphics = this.graphics;
      g.beginFill(0xff0000);
      g.drawRect(0, 0, 500, 500);
      g.endFill();
    }

    private function paused(): void {
      this.isPaused = ! this.isPaused;
    }

    public function startGame(): void {
        var gameMC:MovieClip = new MovieClip();
        var self: Program = this;

        this.game = gameMC;
        this.addChild(gameMC);

        this.oiramrd = new Oiramrd(10, 20);
        var boundDebug: Function = function(msg: String): void {
          self.debug.call(self, msg);
        };
        this.oiramrd.debug = boundDebug;

        var INTERFACE:Interface = new Interface(this.oiramrd, gameMC); 
        INTERFACE.trace = boundDebug;
        INTERFACE.paused = function(): void { self.paused(); };

        var DISPLAY:Display = new Display(this.oiramrd, gameMC);
        gameMC.x = 85;
        gameMC.y = 175;

        DISPLAY.initialize();
        Oiramrd.BF.mc = DISPLAY.blocks;

        this.oiramrd.viriiFill(.01);
        this.oiramrd.setScore( 0 );
        this.clock = 0;

        DISPLAY.setLevel(1);

        this.boundOnEnterFrame = function(): void {
          try {
            self.onEnterFrame.call(self);
          }
          catch(ex: *) {
            debug("Exception in enter frame : " + ex.message);
          }
        };
        this.addEventListener(Event.ENTER_FRAME, this.boundOnEnterFrame);
    }

    public function GetCongratulationsText( s:Number ): String {
        var t: String = "";
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
      if(this.isPaused) return;

        this.clock ++;

        //debug("Clock: " + this.clock + " Ticks per step: " + this.oiramrd.ticksPerStep);

        if ( this.oiramrd.isGameOver() ) {
          debug("Game over");
            var tf: TextField = new TextField();
            tf.width = 200;
            tf.height = 200;

            var tform: TextFormat = new TextFormat();
            tform.bold = true;
            tform.url = "http://jamie.ly";
            tf.setTextFormat ( tform );

            tf.multiline = true;
            tf.text = "Game Over.\n" + this.GetCongratulationsText(this.oiramrd.score) 
              + "\nYour Score: " + this.oiramrd.score + "\n\nangelforge.com";

            this.game.parent.removeChild(this.game);
            this.game = null;
        } else if ( this.clock % this.oiramrd.ticksPerStep == 0 )  {
          this.oiramrd.applyGravity();
        } else {
        }
    }
  }

}

