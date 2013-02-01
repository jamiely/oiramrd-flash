function Display(game, root) {
    this.game = game;
    game.display = this;
    this.root = root; // the root mc of the game
    this.updatePositions = new Array();
    
    this.sound = new Sound(root);
    this.sound.attachSound("sound_beep");
    //this.sound.loadSound("sounds/beep.mp3", false);
    trace( "Display: Root = " + root);
    
    this.toString = function () {
        return "<Display root=\"" + this.root + "\">" + this.game + "</Display>";
    }
}

Display.prototype.updatePill = function(pill) {
    this.updateBlock(pill.block1); this.updateBlock(pill.block2);
    trace(this + ": updatePill pill = " + pill);
}

Display.prototype.updateBlock = function(blk) {
    b = blk.mc;
    o = new Point(b._x, b._y);
    b._x = this.blockSize.x * blk.position.x - this.width;
    b._y = this.blockSize.y * blk.position.y - this.height;
    n = new Point(b._x, b._y);
    trace(this + ": updateBlock blk = " + blk + " original = " + o +  " new = " + n);
}

Display.prototype.addPillToBoard = function(pill) {
    trace(this + ": addPillToBoard")
    this.addBlockToBoard(pill.block1);
    this.addBlockToBoard(pill.block2);
    this.updatePill(pill);
}

Display.prototype.addBlockToBoard = function(block) {
    if ( this.blkdepth == undefined ) this.blkdepth = 100; 
    nm = "block" + this.blkdepth;
    
    trace(this + ": addBlockToBoard\nparentTarget = " + this.block._parent._target + " nm = " + nm);
    this.block.duplicateMovieClip(nm, this.blkdepth);
    blk = this.block._parent[nm];
    block.mc = blk; // link the mc to the block object for easy reference later
    
    
    myColor = new Color( blk );
    myColor.setRGB ( SETTINGS.pillColors [ block.colorIndex ] ); 

    
    this.blkdepth ++; 
    
    trace(this + ": addBlockToBoard\nblk = " + blk);
}   

Display.prototype.addVirusToBoard = function(virus) {
    if ( this.virusdepth == undefined ) this.virusdepth = 100; 
    nm = "virus" + this.virusdepth;
    
    trace(this + ": addVirusToBoard\nparentTarget = " + this.virus._parent._target + " nm = " + nm);
    this.virus.duplicateMovieClip(nm, this.virusdepth);
    blk = this.virus._parent[nm];
    virus.mc = blk; // link the mc to the virus object for easy reference later
    
    myColor = new Color( blk );
    myColor.setRGB ( SETTINGS.pillColors [ virus.colorIndex ] ); 
    
    this.virusdepth ++; 
    
    trace(this + ": addVirusToBoard\nblk = " + blk);
}   

Display.prototype.initialize = function() {
    // 
    
    
    this.root.createEmptyMovieClip("origin", 20);
    this.origin = this.root.origin;
    
    this.root.createEmptyMovieClip("blocks", 100);
    
    this.blocks = this.root.blocks;
    
    this.root.createEmptyMovieClip("virii", 80);
    this.virii = this.root.virii;
    
    this.root.createEmptyMovieClip("grid", 30);
    this.grid = this.root.grid;
    
    
    this.root.createEmptyMovieClip("boardbg", 50); // TODO: parameters
    this.boardbg = this.root.boardbg;
    this.root.createEmptyMovieClip("board", 60); // TODO: parameters
    this.board = this.root.board;
    
    
    
    this.blockSize = new Point(15, 15);
    this.width = this.game.width * this.blockSize.x /2 ;
    this.height = this.game.height * this.blockSize.y / 2;
    
    this.initBlock(); 
    trace ( "Display: Block Initialized" );
    
    this.initVirus();
    trace ( "Display: Virus Initialized" );
    
    this.drawBoard();
    
    trace ( "Display: Board Drawn" );
    
    //this.drawOrigin();
    this.drawGrid();
    
    
    this.root.createEmptyMovieClip("textfields", 10);
    this.textfields = this.root.textfields;
    
    this.left = 70;
    
    this.textfields.createTextField("viriiLeft",1,this.left,-150,50,50);
    //trace(this.textfields.viriiLeft);
    // this.textfields.viriiLeft.multiline = true;
    // this.textfields.viriiLeft.wordWrap = true;
    // this.textfields.viriiLeft.border = true;
    this.textfields.viriiLeft.autoSize = true;
    
    this.myformat = new TextFormat();
    this.myformat.color = 0x000000;
    this.myformat.font = "_sans";
    this.myformat.bold = true;
    this.myformat.size = 20;
    

    this.textfields.viriiLeft.text = "?";
    this.textfields.viriiLeft.setTextFormat(this.myformat);
    
    this.textfields.createTextField("lblViriiLeft",2,this.left,-160,50,50);
    with ( this.textfields.lblViriiLeft ) {
        text = "Virri #"
        setTextFormat( new TextFormat("_sans", 10) );
        
    }    
    
    this.textfields.createTextField("lblScore",3,this.left,-110,50,50);
    with ( this.textfields.lblScore ) {
        text = "Score"
        setTextFormat( new TextFormat("_sans", 10) );
        
    }    
    
    this.setViriiCount ( "?" );
    
    this.textfields.createTextField("score",4,this.left,-100,50,50);
    with ( this.textfields.score ) {
        autoSize = true;
        this.setScore ( "?" );
        setTextFormat(this.myformat);
    }
}

Display.prototype.setScore = function(score) {
    with ( this.textfields.score ) {
        text = score;
        setTextFormat( this.myformat );
    }
}

Display.prototype.setViriiCount = function(count) {
    this.textfields.viriiLeft.text = count;
    this.textfields.viriiLeft.setTextFormat( this.myformat );
}

Display.prototype.drawGrid = function() {
    //w = this.game.width * this.blockSize.x / 2;
    //h = this.game.height * this.blockSize.y / 2;
    w = this.width; h = this.height;
    
    for(i=-w; i<w; i+=this.blockSize.x) {
        with ( this.grid ) {
            lineStyle(1, 0xDDDDDD, 50);
            moveTo(i, -h);
            lineTo(i, h);
        }
    }
    
    for(i=-h; i<h; i+=this.blockSize.y) {
        with ( this.grid ) {
            lineStyle(1, 0xDDDDDD, 50);
            moveTo(-w, i);
            lineTo(w, i);
        }
    }
    
    trace(w)
}

Display.prototype.drawOrigin = function() {
    len = 10;
    o = this.origin;
    o.lineStyle(1, 0xCCCCCC, 100);
    o.moveTo(len, 0);
    o.lineTo(-len, 0);
    o.moveTo(0, len);
    o.lineTo(0, -len);
}

Display.prototype.drawBoard = function() {
    bg = this.boardbg;
    bw = 1; // border width
    bc = 0x333333; // border color
    bg.lineStyle(bw, bc, 80);
    w = this.width ; h = this.height;
    dw = this.blockSize.x/2; dh = this.blockSize.y/2;
    
    bg.moveTo(-w - dw, -h - dh);
    bg.lineTo(-w - dw, h - dh);
    bg.lineTo(w - dw, h - dh);
    bg.lineTo(w - dw, -h - dh);
    bg.lineTo(-w -dw, -h - dh);
    
    trace("Display.drawBoard: game.width = "  + this.game.width + 
        " game.height = " + this.game.height);
    trace("Display.drawBoard: blockSize.x = "  + this.blockSize.x + 
        " blockSize.y = " + this.blockSize.y);
    trace("Display.drawBoard: w = "  + w + " h = " + h);
}



Display.prototype.update = function() {
    for(var i=0; i < this.updatePositions.length; i++) {
        pt = this.updatePositions[i]; // should be a point correspondinng to a board position
        pos = this.game.board[pt.x][pt.y]; // object defining board position
    }
}

Display.prototype.initBlock = function() {
    if( this.block == undefined ) { // must generate the first block
        this.blocks.createEmptyMovieClip("ogblk", 10); // TODO: parameters  
        
        // DRAW block
        this.block = this.blocks.ogblk;
        this.block._x = 40;
        with ( this.block ) {
            lineStyle(1, 0x0000FF, 100);
            beginFill(0xFFFFFF);
            w = this.blockSize.x / 2;
            h = this.blockSize.y / 2;
            moveTo(-w, -h);
            lineTo(-w, h);
            lineTo(w, h);
            lineTo(w, -h);
            lineTo(-w, -h);
            endFill();
        }
        this.block._visible = false;
    }
}

Display.prototype.initVirus = function() {
    if ( this.virus == undefined ) { 
        this.virii.createEmptyMovieClip("ogvir", 20); // TODO: parameters
        this.virus = this.virii.ogvir;
        this.virus._x = 15;
        
        with ( this.virus ) {
            lineStyle(1, 0xFF0000, 100);
            w = this.blockSize.x / 2;
            h = this.blockSize.y / 2;
            
            beginFill(0xFFFFFF);
            moveTo(0, h);
            curveTo(w, h, w, 0);
            curveTo(w, -h, 0, -h);
            curveTo(-w, -h, -w, 0);
            curveTo(-w, h, 0, h);
            endFill();
        }
        
        this.virus._visible = false;
    }
}