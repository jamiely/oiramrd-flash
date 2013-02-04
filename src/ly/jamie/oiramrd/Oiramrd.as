package ly.jamie.oiramrd {
  public class Oiramrd {
    public static var BF:BlockFactory = new BlockFactory();

    public var board: Array;
    public var mcs: Array;
    public var blockMatcher: BlockMatcher;
    public var minimumBlocksToClear: Number;
    public var ticksPerStep: Number;
    public var viriiCount: Number;
    public var density: Number;
    public var level: Number;
    public var gameIsOver: Boolean;
    public var score: Number;
    public var chainLevel: Number;
    public var width: Number;
    public var height: Number;
    public var factoryPill: PillFactory;
    public var display: Display;
    private var pf: PillFactory;
    public var activePill: Pill;
    public var debug: Function;
    private var clock: Number;
    private var matcher: Matcher;

    /**
     * This is the main class
     */
    public function Oiramrd(width: Number, height: Number) {
        trace(this + ": Oiramrd");
        this.board = new Array(width);
        this.mcs = new Array(height);
        this.blockMatcher = undefined;
        this.minimumBlocksToClear = 4;
        this.ticksPerStep = Constants.DEFAULT_TICKSPERSTEP ;
        this.viriiCount = 0;
        this.clock = 0;
        this.density = 0;
        this.level = 1;
        this.gameIsOver = false;



        this.width = width;
        this.height = height; 

        this.score = 0;
        this.chainLevel = 1; // multiplier for score

        for(var i: Number=0; i < width; i++) {

            this.board[i] = new Array(height);
            this.mcs[i] = new Array(height);
        }

        this.initialize();
        this.matcher = new Matcher(this);
    }

    public function toString(): String {
        return "<Oiramrd width=\""+this.width+"\" height=\"" + this.height+"\">";
    }



    /**
     * This function initializes an empty board.
     */
    public function initialize():void {
        trace(this + ": Initialize");
        for(var i:Number=0; i < this.width; i++) {
            for(var j:Number=0; j < this.height; j++) {
                this.board[i][j] = Constants.BRD_EMPTY;
                if(this.mcs[i][j] != null) {
                    this.mcs[i][j].removeMovieClip();
                    this.mcs[i][j] = null;
                }
            }
        }

        this.factoryPill = new PillFactory();
        this.dumpBoard("\t");
    }

    /**
     * This function is used for debugging purposes, it dumps
     * the contents of the board to stdout
     */
    public function dumpBoard(tab:String = ""):void {
        var str:String = ""

        for ( var j:Number = 0; j < this.height; j++) {
            str = str + tab;
            for ( var i:Number=0; i < this.width; i++ ) {
                var char: String = "?";
                switch ( this.board[i][j] ) {
                    case Constants.BRD_EMPTY: char = "."; break;
                    case Constants.BRD_VIRUS: char = "@";  break;
                    case Constants.BRD_BLOCK: char = "#"; break;
                }
                str = str + char;
            }
            str = str + "\n";
        }

        trace(str);
    }

    /** 
     * Increments the board by one.  All blocks that can move will move one space.
     */
    public function step(): void {
        // 1 turn
        this.dumpBoard();
        if ( this.isGameOver() ) return;
        this.applyGravity();
    }

    public function viriiFill(density: Number): void {
        this.density = density;

        var avail:Number = this.width * this.height;
        var vCount:Number = Math.floor(avail * density);
        var vf:VirusFactory = new VirusFactory();

        trace(this + " avail = " + avail + " vCount = " + vCount);
        var empty:Array = this.getRandomEmptyBoardPositions();

        var midy:Number = Math.floor(this.height / 4);

        this.viriiCount = vCount;
        this.display.setViriiCount ( this.viriiCount );

        while(vCount > 0 ) {
            var pos: Point = empty[empty.length-1];



            if ( pos.y >= midy ) { // fill below midpoint of board


                var ci: Number = Math.floor(Math.random() * Settings.Shared.pillColorCount());
                trace ( ci );
                if ( pos == null ) return;
                var virus: Block = vf.getVirus(pos, ci);

                this.setVirus(virus);
                this.display.addVirusToBoard(virus);
                this.display.updateBlock(virus);
                empty.pop();
                vCount --;
            }
            else {
                fisherYates ( empty );
            }
        }



        this.dumpBoard();
    }

    // http://sedition.com/perl/javascript-fy.html
    private function fisherYates ( myArray: Array ): void {
      for ( var i:Number = myArray.length - 1; i >= 0; i-- ) {
         var j:Number = Math.floor( Math.random() * ( i + 1 ) );
         var tempi:* = myArray[i];
         var tempj:* = myArray[j];
         myArray[i] = tempj;
         myArray[j] = tempi;
       }
    }

    public function getRandomEmptyBoardPositions(): Array {
        var positions: Array = this.getEmptyBoardPositions();
        fisherYates(positions);
        return positions;
    }

    public function getEmptyBoardPositions(): Array {
        var empty: Array = new Array();
        for(var i:Number=0; i < this.width; i++) {
            for(var j:Number=0; j< this.height; j++ ) {
                if ( this.board[i][j] == Constants.BRD_EMPTY ) {
                    empty.push( new Point(i, j) );
                }
            }
        }

        return empty;
    }

    public function canRotate(myPill: Pill, clockwise: Boolean = true): Boolean {
        this.dumpBoard();

        var cpyPill: Pill = myPill.copy();
        this.rotatePill(cpyPill, clockwise);

        var pos1: Point = myPill.block1.position;
        var pos2: Point = myPill.block2.position;
        var n1: Point = cpyPill.block1.position;
        var n2: Point = cpyPill.block2.position;
        var b1: Boolean = (this.board[n1.x][n1.y] == Constants.BRD_EMPTY || n1.equals(pos1) || n1.equals(pos2));
        var b2: Boolean = (this.board[n2.x][n2.y] == Constants.BRD_EMPTY || n2.equals(pos1) || n2.equals(pos2));

        var result: Boolean = b1 && b2 ;

        this.dumpBoard();

        return result;
    }

    public function rotatePill(myPill: Pill, clockwise: Boolean): void {
        trace (this + ":rotatePill myPill=" + myPill + " clockwise=" + clockwise );

        var p1: Point = myPill.block1.position;
        var p2: Point = myPill.block2.position;

        var slope:* = p1.slope(p2); 
        var b1: Block, b2: Block;
        if ( slope == undefined ) { // vertical myPill
            if ( p1.y > p2.y ) { b1 = myPill.block1; b2 = myPill.block2; } // block 1 is bottom most
            else if ( p2.y > p1.y ) { b2 = myPill.block1; b1 = myPill.block2; } // block 2 is bottomost
            else { trace ("SERIOUS ERROR !!!!"); }

            b2.position.y = b1.position.y;
            b1.position.x = clockwise ? b1.position.x + 1 : b1.position.x - 1;
        }
        else if ( slope == 0 ) { // horizontal myPill
            //trace ( "\thorizontal pill ")
            //trace ( "\tp1.x=" + p1.x + " p2.x=" + p2.x );

            if ( p1.x > p2.x ) { b1 = myPill.block1; b2 = myPill.block2; } // block1 is rightmost
            else if ( p2.x > p1.x) { b2 = myPill.block1; b1 = myPill.block2; } // block2 is rightmost
            else { trace ("SERIOUS ERROR !!!!"); }

            //trace ( "\tb1=" + b1 + " b2=" + b2);

            //trace ( "\tb1_orig = " + b1 );

            //b2.position.x = b1.position.x;
            b1.position.x = b2.position.x ;
            b1.position.y = clockwise ? b1.position.y - 1 : b1.position.y + 1;
        }
        else { // a somehow disjointed myPill
            trace( "SERIOUS ERROR" );
        }
    }


    public function getRandomEmptyBoardPos(): Point {
        var empty: Array = new Array();
        for(var i:Number=0; i < this.width; i++) {
            for(var j:Number=0; j< this.height; j++ ) {
                if ( this.board[i][j] == Constants.BRD_EMPTY ) {
                    empty.push( new Point(i, j) );
                }
            }
        }

        if ( empty.length == 0 ) return null;
        return empty[Math.floor(Math.random() * empty.length)];
    }

    /*
    33
    22
    11
    00
    */
    public function canFall(blk: Block): Boolean {
        var p: Point = blk.position;
        if ( blk.linkedBlock == null ) {
            return this.board[p.x][p.y + 1] == Constants.BRD_EMPTY;
        }

        var p2: Point = blk.linkedBlock.position;

        var lower:Point = p2.y > p.y ? p2 : p; // lower
        var higher: Point = lower == p2 ? p: p2;

        var result: Boolean = this.board[lower.x][lower.y + 1] == Constants.BRD_EMPTY && 
           (this.board[higher.x][higher.y + 1] == Constants.BRD_EMPTY || (higher.y + 1 == lower.y));

        return result;
    }

    public function setScore( score: Number ): void {
        this.score = score;
        this.display.setScore ( this.score );
    }

    public function addToScore( blocksCleared: Number, chainLevel: Number ): void {
        this.setScore ( (this.getScore() + blocksCleared * 10 * chainLevel) * this.level );
    }

    public function getScore( ): Number {
        return this.score;
    }

    private function stopApplyingGravity(): void {
        for(var x:Number=0; x< this.width; x++) { // iterate over columns 
            for(var y:Number=this.height-1; y >=0 ; y--) {
                if (this.mcs[x][y] != null) {
                  this.mcs[x][y].grav = false;
                }
            }
        }
    }

    public function blockAt(pt: Point): Block {
      if(pt.x < 0 || pt.x > this.mcs.length) return null;
      if(pt.y < 0 || pt.y > this.mcs[pt.x].length) return null;

      return this.mcs[pt.x][pt.y];
    }

    private function dropBlockAt(pt: Point): Number {
      debug("dropBlockAt: startin at pt=" + pt);
      var numberOfBlocksFalling: Number = 0;
      var blk: Block = this.mcs[pt.x][pt.y];
      var bb: BlockBullier = new BlockBullier();
      if ( blk.grav ) return numberOfBlocksFalling;

      bb.down(this, blk);
      blk.grav = true;
      this.display.updateBlock(blk);

      // block has fallen, it becomes a contact point if there are any blocks in the cardinal positions
      this.addContactBlock ( blk );

      numberOfBlocksFalling ++;

      //if ( blk.linkedBlock == null || blk.linkedBlock.grav) return numberOfBlocksFalling;
      if ( blk.linkedBlock == null) {
        debug("dropBlockAt: no linked block available.");
        return numberOfBlocksFalling;
      }

      debug("dropBlockAt: Adding linked block " + blk.linkedBlock + " as contact point");

      bb.down(this, blk.linkedBlock);
      blk.linkedBlock.grav = true;

      this.addContactBlock( blk.linkedBlock );
      this.display.updateBlock(blk.linkedBlock);

      numberOfBlocksFalling ++;

      return numberOfBlocksFalling;
    }

    private function addContactBlock(blk: Block): void {
      if(!blk) return;

      debug("addContactBlock start: " + blk);

      var blks: Array = this.blockMatcher.getContactBlocks();
      for(var i: Number = 0; i<blks.length; i++ ){
        if(blk.position.equals(blks[i].position)) return;
      }

      this.blockMatcher.addContactBlock(blk);
    }

    public function allPositions(): Array {
      var rtn: Array = [];
      for(var x:Number=0; x< this.width; x++) { // iterate over columns 
        for(var y:Number=this.height-1; y >=0 ; y--) {
          rtn.push(new Point(x, y));
        }
      }
      return rtn;
    }

    public function allBlocks(): Array {
      var rtn: Array = [];
      for each(var pt: Point in this.allPositions()) {
        var block: Block = this.blockAt(pt);
        if(block) {
          rtn.push(block);
        }
      }
      return rtn;
    }

    private function isBlockThatCanFallAt(pt: Point): Boolean {
      return this.board[pt.x][pt.y] == Constants.BRD_BLOCK 
        && this.canFall( this.mcs[pt.x][pt.y] );
    }

    private function countNumberOfBlocksThatCanFall(): Number {
      var numberOfBlocksFalling: Number = 0;
      for(var x:Number=0; x< this.width; x++) { // iterate over columns 
          for(var y:Number=this.height-1; y >=0 ; y--) {
            var pt: Point = new Point(x,y);
            if (this.isBlockThatCanFallAt(pt)) { // block && all blocks above must fall
              numberOfBlocksFalling += this.dropBlockAt(pt);
            }
          }
      }
      return numberOfBlocksFalling;
    }

    /**
     * Causes all blocks that can fall due to gravity to fall by one board position.
     */
    public function applyGravity(): void {
      this.clock ++;
      debug("***********************************apply gravity CLOCK=" + this.clock);

      this.stopApplyingGravity();

      debug("Check for falling blocks");
      if(this.countNumberOfBlocksThatCanFall() != 0) {
        // guarantees clearing only after all blocks fallen
        // this can be changed to clear after some blocks have fallen
        debug("There are still falling blocks.");
        return;
      }

      debug("There are no falling blocks--resolve");
      try {
        var matchedBlocks: Array = matcher.getAllMatchBlocks();
        debug("applyGravity: matcher allMatchBlocks=" + matchedBlocks);
        this.nextPill();
      } catch(ex: Error) {
        debug("Problem matching blocks: " + ex.message);
      }
    }

    private function nextPill(): void {
      this.ticksPerStep = Constants.DEFAULT_TICKSPERSTEP;
      this.insertNextPill();

      this.chainLevel = 1;
    }

    /**
     * Tests whther the game is over.
     */
    public function isGameOver(): Boolean { 
        return this.gameIsOver ;
    }

    /**
     * Tests whether move is valid.
     */

    public function canMove( myPill: Pill, dir: Number ): Boolean {
        var pos1: Point = myPill.block1.position; 
        var pos2: Point = myPill.block2.position;

        var n1: Point = new Point(pos1.x, pos1.y);
        var n2: Point = new Point(pos2.x, pos2.y);

        switch ( dir ) {
            case Constants.DIR_DOWN:
                n1.y ++; n2.y++; break;
            case Constants.DIR_RIGHT:
                n1.x ++; n2.x ++; break;
            case Constants.DIR_UP:
                n1.y--; n2.y--; break;
            case Constants.DIR_LEFT:
                n1.x--; n2.x--; break;
        }

        var b1: Boolean = (this.board[n1.x][n1.y] == Constants.BRD_EMPTY || n1.equals(pos1) || n1.equals(pos2));
        var b2: Boolean = (this.board[n2.x][n2.y] == Constants.BRD_EMPTY || n2.equals(pos1) || n2.equals(pos2));
        var result: Boolean = b1 && b2 ;

        return result;

    }

    public function insertNextPill(pos1: Point = null): void {
        if (this.gameIsOver || this.getBlock (1, 1) || this.getBlock (2, 1) ) {
            this.gameIsOver = true;
            return;
        }

        if ( pos1 == null) {
          pos1 = new Point(1, 1);
        }

        if ( this.pf == null) {
          this.pf = new PillFactory();
        }

        var myPill: Pill = this.pf.getRandomPill(pos1, false);

        this.addPillToBoard(myPill);

        this.addContactBlock ( myPill.block1 );
        this.addContactBlock ( myPill.block2 );
    }

    public function setBoardPos(pos:Point, val:*): void {
        this.board[pos.x][pos.y] = val;
    }

    public function setMcsPos(pos:Point, val:*): void {
        this.mcs[pos.x][ pos.y] = val;
    }

    public function setPill(myPill:Pill): void {
        var p1: Point = myPill.block1.position;
        var p2: Point = myPill.block2.position;
        this.setBoardPos(p1, Constants.BRD_BLOCK);
        this.setBoardPos(p2, Constants.BRD_BLOCK);
        this.setMcsPos(p1, myPill.block1);
        this.setMcsPos(p2, myPill.block2);
    }

    public function setVirus(virus:Block): void {
        var p:Point = virus.position;
        this.setBoardPos(p, Constants.BRD_VIRUS);
        this.setMcsPos(p, virus);
    }

    public function addPillToBoard(myPill:Pill): void {
        this.setPill(myPill);

        this.display.addPillToBoard(myPill);

        this.activePill = myPill;
    }

    public function getBlock( x:Number, y:Number ): Block {
        if ( this.mcs.length <= x || x < 0 || this.mcs[x].length <= y || y < 0 ) return null;
        return this.mcs[x][y];
    }

    public function nextLevel(): void {
        trace("NEXT LEVEL");
        this.viriiFill ( this.density /= 2 );
        this.level ++;
        this.display.setLevel( this.level );
    }

    public function destroyBlock( x:Number, y:Number ): void {
        if ( this.board[x][y] == Constants.BRD_VIRUS ) {
            this.viriiCount --;
            this.display.setViriiCount ( this.viriiCount );

            if ( this.viriiCount <= 0 ) {
                trace("NEXT LEVEL");
                this.viriiFill ( this.density *= 2 );
                this.level ++;
                this.display.setLevel( this.level );
            }
        }
        this.board[x][y] = Constants.BRD_EMPTY;
        var block: Block = this.getBlock(x, y);
        block.breakLinks();
        if ( ! block ) return;
        this.mcs[x][y] = null;

        block.mc.parent.removeChild(block.mc);
    }
  }
}

