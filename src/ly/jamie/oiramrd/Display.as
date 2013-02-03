package ly.jamie.oiramrd {

  import flash.display.MovieClip;
  import flash.media.Sound;
  import flash.text.*;
  import flash.geom.ColorTransform;

  public class Display {
    private var blockSize: Point;
    private var game:Oiramrd;
    private var root:MovieClip;
    private var updatePositions: Array;
    public var sound: Sound;
    public var width: Number;
    public var height: Number;
    public var blkdepth: Number;
    public var block: MovieClip;
    public var virus: MovieClip;
    public var origin: *;
    public var blocks: MovieClip;
    public var virii: MovieClip;
    public var grid: MovieClip;
    public var boardbg: MovieClip;
    public var board: MovieClip;
    public var cellNumbering: MovieClip;
    public var textfields: MovieClip;
    public var left: Number;
    public var myformat: TextFormat;

    function Display(game:Oiramrd, root:MovieClip) {
        this.game = game;
        game.display = this;
        this.root = root; // the root mc of the game
        this.updatePositions = new Array();

        this.sound = new Sound();
        //this.sound.attachSound("sound_beep");
    }
    public function toString(): String {
        return "<Display root=\"" + this.root + "\">" + this.game + "</Display>";
    }

    public function updatePill(pill: Pill): void {
        this.updateBlock(pill.block1); this.updateBlock(pill.block2);
    }

    public function updateBlock(blk: Block): void {
        var b:MovieClip = blk.mc;
        var o:Point = new Point(b.x, b.y);
        b.x = this.blockSize.x * blk.position.x - this.width;
        b.y = this.blockSize.y * blk.position.y - this.height;
    }

    public function addPillToBoard(pill: Pill): void {
        this.addBlockToBoard(pill.block1);
        this.addBlockToBoard(pill.block2);
        this.updatePill(pill);
    }

    public function addBlockToBoard(block: Block): void {
      block.mc = this.createBlockWithColor(this.blockColor(block));
    }

    private function blockColor(block: Block): uint {
      return this.colorAt(block.colorIndex);
    }

    private function colorAt(index: int): uint {
      return Settings.Shared.pillColors[index];
    }

    public function addVirusToBoard(virus: Block): void {
        virus.mc = this.createVirusWithColor(this.blockColor(virus));
    }

    private function addNewMC(): MovieClip {
      var mc: MovieClip = new MovieClip();
      this.root.addChild(mc);
      return mc;
    }

    private function newTextField(x: Number, y:Number, width: Number, height: Number): TextField {
      var txt: TextField = new TextField();
      this.textfields.addChild(txt);
      txt.x = x;
      txt.y = y;
      txt.width = width;
      txt.height = height;
      return txt;
    }


    private function createCellNumbering(): void {
        var w: Number = this.width; 
        var h: Number = this.height;

        var tf: TextFormat = new TextFormat("_sans", 6);
        var r:Number = 0, c:Number = 0;
        for(var i:Number=-w; i<w; i+=this.blockSize.x) {
          c = 0;
          for(var j:Number=-h; j<h; j+=this.blockSize.y) {
            var txt: TextField = new TextField();
            txt.defaultTextFormat = tf;
            txt.text = r + "," + c;
            txt.x = i;
            txt.y = j;
            txt.textColor = 0xcccccc;
            txt.width = this.blockSize.x;
            txt.height = this.blockSize.y;
            this.cellNumbering.addChild(txt);
            c++;
          }
          r++;
        }

        r = 0;
        for(i = -w; i<w; i+= this.blockSize.x) {
            txt = new TextField();
            txt.defaultTextFormat = tf;
            txt.text = r + "";
            txt.x = i;
            txt.y = this.height;
            txt.width = this.blockSize.x;
            txt.height = this.blockSize.y;
            this.cellNumbering.addChild(txt);

            txt = new TextField();
            txt.defaultTextFormat = tf;
            txt.text = r + "";
            txt.x = i;
            txt.y = -this.height - this.blockSize.y;
            txt.width = this.blockSize.x;
            txt.height = this.blockSize.y;
            this.cellNumbering.addChild(txt);
            r++;
        }

        r = 0;
        for(i = -h; i<h; i+= this.blockSize.y) {
            txt = new TextField();
            txt.defaultTextFormat = tf;
            txt.text = r + "";
            txt.x = - this.width - this.blockSize.x;
            txt.y = i;
            txt.width = this.blockSize.x;
            txt.height = this.blockSize.y;
            this.cellNumbering.addChild(txt);

            txt = new TextField();
            txt.defaultTextFormat = tf;
            txt.text = r + "";
            txt.x = this.width;
            txt.y = i;
            txt.width = this.blockSize.x;
            txt.height = this.blockSize.y;
            this.cellNumbering.addChild(txt);

            r++;
        }
        this.cellNumbering.x = -this.blockSize.x/2.0;
        this.cellNumbering.y = -this.blockSize.y/2.0;
    }

    public function initialize(): void {
        this.origin = this.addNewMC();
        this.grid = this.addNewMC();
        this.textfields = this.addNewMC();
        this.boardbg = this.addNewMC();
        this.board = this.addNewMC();
        this.cellNumbering = this.addNewMC();

        this.virii = this.addNewMC();
        this.blocks = this.addNewMC();

        this.blockSize = new Point(15, 15);
        this.width = this.game.width * this.blockSize.x /2 ;
        this.height = this.game.height * this.blockSize.y / 2;

        this.initBlock(); 
        this.initVirus();
        this.drawBoard();
        this.drawGrid();
        this.createCellNumbering();

        this.left = 70;

        this.textfields.viriiLeft = this.newTextField(this.left, -150, 50, 50);

        this.myformat = new TextFormat();
        this.myformat.color = 0x000000;
        this.myformat.font = "_sans";
        this.myformat.bold = true;
        this.myformat.size = 20;

        this.textfields.viriiLeft.setTextFormat(this.myformat);
        this.textfields.viriiLeft.text = "?";

        this.textfields.lblViriiLeft = this.newTextField(this.left, -160, 50, 50);
        with ( this.textfields.lblViriiLeft ) {
            text = "Bugs #"
            setTextFormat( new TextFormat("_sans", 10) );
        }

        this.textfields.lblScore = this.newTextField(this.left, -110, 50, 50);
        with ( this.textfields.lblScore ) {
            text = "Score"
            setTextFormat( new TextFormat("_sans", 10) );
        }

        this.setViriiCount ( "?" );

        this.textfields.score = this.newTextField(this.left, -100, 50, 50);
        this.setScore ( "?" );
        with ( this.textfields.score ) {
            setTextFormat(this.myformat);
        }

        this.textfields.lblLevel = this.newTextField(this.left, -70, 50, 50);
        with ( this.textfields.lblLevel ) {
            text = "level"
            setTextFormat( new TextFormat("_sans", 10) );
        }

        this.textfields.level = this.newTextField(this.left, -60, 50, 50);
        with ( this.textfields.level ) {
            setTextFormat(this.myformat);
        }
    }

    public function setLevel(level: *): void {
        with ( this.textfields.level ) {
            text = level;
            setTextFormat( this.myformat );
        }
    }


    public function setScore(score: *): void {
        with ( this.textfields.score ) {
            text = score;
            setTextFormat( this.myformat );
        }
    }

    public function setViriiCount(count: *): void {
        this.textfields.viriiLeft.text = count;
        this.textfields.viriiLeft.setTextFormat( this.myformat );
    }

    public function drawGrid(): void {
        var w: Number = this.width; 
        var h: Number = this.height;

        for(var i:Number=-w; i<w; i+=this.blockSize.x) {
            with ( this.grid.graphics ) {
                lineStyle(1, 0xDDDDDD, 50);
                moveTo(i, -h);
                lineTo(i, h);
            }
        }

        for(i=-h; i<h; i+=this.blockSize.y) {
            with ( this.grid.graphics ) {
                lineStyle(1, 0xDDDDDD, 50);
                moveTo(-w, i);
                lineTo(w, i);
            }
        }

        this.grid.x = -this.blockSize.x/2.0;
        this.grid.y = -this.blockSize.y/2.0;

        trace(w)
    }

    public function drawOrigin(): void {
        var len:Number = 10;
        var o:MovieClip = this.origin;
        o.graphics.lineStyle(1, 0xCCCCCC, 100);
        o.graphics.moveTo(len, 0);
        o.graphics.lineTo(-len, 0);
        o.graphics.moveTo(0, len);
        o.graphics.lineTo(0, -len);
    }

    public function drawBoard(): void {
        var bg:MovieClip = this.boardbg;
        var bw:Number = 1; // border width
        var bc:uint = 0x333333; // border color
        bg.graphics.lineStyle(bw, bc, 80);
        var w:Number = this.width ; 
        var h:Number = this.height;
        var dw: Number = this.blockSize.x/2; 
        var dh: Number = this.blockSize.y/2;

        bg.graphics.moveTo(-w - dw, -h - dh);
        bg.graphics.lineTo(-w - dw, h - dh);
        bg.graphics.lineTo(w - dw, h - dh);
        bg.graphics.lineTo(w - dw, -h - dh);
        bg.graphics.lineTo(-w -dw, -h - dh);

        trace("Display.drawBoard: game.width = "  + this.game.width + 
            " game.height = " + this.game.height);
        trace("Display.drawBoard: blockSize.x = "  + this.blockSize.x + 
            " blockSize.y = " + this.blockSize.y);
        trace("Display.drawBoard: w = "  + w + " h = " + h);
    }



    public function update(): void {
        for(var i:Number=0; i < this.updatePositions.length; i++) {
            var pt: Point = this.updatePositions[i]; // should be a point correspondinng to a board position
            var pos: Point = this.game.board[pt.x][pt.y]; // object defining board position
        }
    }

    public function createBlockWithColor(color: uint): MovieClip {
      var block: MovieClip = new MovieClip();
      var w:Number = blockSize.x / 2;
      var h:Number = blockSize.y / 2;
      with ( block.graphics ) {
          lineStyle(0, color, 100);
          beginFill(color);
          moveTo(-w, -h);
          lineTo(-w, h);
          lineTo(w, h);
          lineTo(w, -h);
          lineTo(-w, -h);
          endFill();
      }
      this.blocks.addChild(block);
      return block;
    }
    public function initBlock(): void {
        if( this.block == null ) { // must generate the first block
            // DRAW block
            this.block = this.createBlockWithColor(0x0000ff);
            this.block.x = 40;
            this.block.visible = false;
        }
    }

    public function createVirusWithColor(color: uint): MovieClip {
        var virus: MovieClip = new MovieClip();
        this.virii.addChild(virus);

        var w:Number = this.blockSize.x / 2;
        var h:Number = this.blockSize.y / 2;

        with ( virus.graphics ) {
            lineStyle(0, color, 100);
            beginFill(color);
            moveTo(0, h);
            curveTo(w, h, w, 0);
            curveTo(w, -h, 0, -h);
            curveTo(-w, -h, -w, 0);
            curveTo(-w, h, 0, h);
            endFill();
        }

        return virus;
    }

    public function initVirus(): void {
        if ( this.virus )  return; 

        this.virus = this.createVirusWithColor(0xff0000);
        this.virus.x = 15;
        this.virus.visible = false;
    }
  }
}

