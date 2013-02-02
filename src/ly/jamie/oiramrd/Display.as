package ly.jamie.oiramrd {

  import flash.display.MovieClip;
  import flash.media.Sound;
  import flash.text.*;

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
        block.mc = this.copyMCWithColorIndex(this.block, block.colorIndex);
    }

    private function copyMC(mc: MovieClip):MovieClip {
      var newMC:MovieClip = new MovieClip();
      newMC.graphics.copyFrom(mc.graphics);
      this.root.addChild(newMC);
      return newMC;
    }

    private function copyMCWithColorIndex(mc: MovieClip, colorIndex: int):MovieClip {
      var newMC: MovieClip = this.copyMC(mc);

      newMC.opaqueBackground = Settings.Shared.pillColors [ colorIndex ];
      return newMC;
    }

    public function addVirusToBoard(virus: Block): void {
        virus.mc = this.copyMCWithColorIndex(this.virus, virus.colorIndex);
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

    public function initialize(): void {
        this.origin = this.addNewMC();
        this.grid = this.addNewMC();
        this.textfields = this.addNewMC();
        this.boardbg = this.addNewMC();
        this.board = this.addNewMC();
        this.virii = this.addNewMC();
        this.blocks = this.addNewMC();

        this.blockSize = new Point(15, 15);
        this.width = this.game.width * this.blockSize.x /2 ;
        this.height = this.game.height * this.blockSize.y / 2;

        this.initBlock(); 
        this.initVirus();
        this.drawBoard();
        this.drawGrid();

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

    public function initBlock(): void {
        if( this.block == null ) { // must generate the first block
            // DRAW block
            this.block = new MovieClip();
            this.blocks.addChild(this.block);
            this.block.x = 40;
            var w:Number = this.blockSize.x / 2;
            var h:Number = this.blockSize.y / 2;
            with ( this.block.graphics ) {
                lineStyle(1, 0x0000FF, 100);
                beginFill(0xFFFFFF);
                moveTo(-w, -h);
                lineTo(-w, h);
                lineTo(w, h);
                lineTo(w, -h);
                lineTo(-w, -h);
                endFill();
            }
            this.block.visible = false;
        }
    }

    public function initVirus(): void {
        if ( this.virus )  return; 

        this.virus = new MovieClip();
        this.virii.addChild(this.virus);

        this.virus.x = 15;

        var w:Number = this.blockSize.x / 2;
        var h:Number = this.blockSize.y / 2;

        with ( this.virus.graphics ) {
            lineStyle(1, 0xFF0000, 100);
            beginFill(0xFFFFFF);
            moveTo(0, h);
            curveTo(w, h, w, 0);
            curveTo(w, -h, 0, -h);
            curveTo(-w, -h, -w, 0);
            curveTo(-w, h, 0, h);
            endFill();
        }

        this.virus.visible = false;
    }
  }
}

