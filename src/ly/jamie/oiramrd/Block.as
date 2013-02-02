package ly.jamie.oiramrd {
  import flash.display.MovieClip;
  /**
   * Class to contain block information.
   */
  public class Block {
    public var colorIndex:Number;
    public var mc:MovieClip;
    public var position: Point;
    public var canFall: Boolean;
    public var linkedBlock: Block;
    public var grav: Boolean;

    function Block(position:Point, colorIndex:Number, mc:MovieClip) {
        this.colorIndex = colorIndex;
        this.mc = mc;
        this.position = position;
        this.canFall = true;
        this.grav = false;

        this.linkedBlock = null;
    }

    public function setLinkedBlock (b: Block): void {
        this.linkedBlock = b;
        if( b != null) b.linkedBlock = this;
    }

    public function breakLinks(): void {
        if ( this.linkedBlock ) {
            this.linkedBlock.linkedBlock = null; 
            this.linkedBlock = null;
        }
    }

    public function toString(): String {
        var tmp:Array = new Array("Block", this.position, this.mc, this.colorIndex);
        return "<" + tmp.join(" ") + ">";
    }

    public function copy(): Block {
        return new Block(this.position.copy(), this.colorIndex, this.mc);
    }
    public function getX(): Number {
        return this.position.x;
    }
    public function getY(): Number {
        return this.position.y;
    }


  }
}

