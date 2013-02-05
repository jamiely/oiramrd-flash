package ly.jamie.oiramrd{
  import flash.display.*;
  import flash.events.*;
  import flash.ui.*;

  public class Interface {

    private var isPaused: Boolean = false;
    public var game: Oiramrd;
    private var ap: Pill;
    private var pp: PillPusher;
    public var trace: Function;
    public var paused: Function = function(): void {};
    public var step: Function = function(): void {};
 
    public function Interface(game: Oiramrd, root: MovieClip) {
        this.game = game;
        var self: Interface = this;
        root.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:Event): void {
          self.onKeyboardDown.call(self, e);
        });
    }

    public function toString(): String {
        return "<Interface>" + this.game + "</Interface>";
    }

    public function onPause(): void {
      isPaused = !isPaused;
      this.paused();
    }

    public function onStep(): void {
      this.step();
    }

    public function onKeyboardDown(e: KeyboardEvent): void {
      switch(e.charCode) {
          case "p".charCodeAt(0):
          case "P".charCodeAt(0):
            this.onPause();
            break;
      }

      switch ( e.charCode ) {
        case "z".charCodeAt(0):
          if ( this.game.canRotate(ap, true) ){
            pp.counterClockwise(this.game, ap);
            this.game.display.updatePill ( ap );
          }
          break;
      }

      ap = this.game.activePill;

      if ( ap == null ) return;

      pp = new PillPusher();

      switch ( e.keyCode ) {
          case Keyboard.RIGHT:
              if ( this.game.canMove ( ap, Constants.DIR_RIGHT ) ) {
                  pp.right(this.game, ap);
                  this.game.display.updatePill(ap);
              }
              break;

          case Keyboard.LEFT:
              if ( this.game.canMove ( ap, Constants.DIR_LEFT ) ) {
                  pp.left(this.game, ap);
                  this.game.display.updatePill(ap);
              }
              break;
          case Keyboard.DOWN:
            this.game.step();
            break;
          case Keyboard.UP:
              if ( this.game.canRotate(ap, true) ) {
                  pp.clockwise(this.game, ap);
                  this.game.display.updatePill(ap);
              }

              break;
          case Keyboard.CONTROL:
              if ( this.game.canRotate(ap, true) ){
                  pp.counterClockwise(this.game, ap);
                  this.game.display.updatePill ( ap );
              }
              break;
      }
    }
  }
}

