#include "../Point.as" 
#include "Interface.as"

#include "Display.as"

#include "PillFactory.as"
#include "VirusFactory.as"
#include "BlockFactory.as"
#include "Block.as"
#include "BlockBullier.as"
#include "PillPusher.as"
#include "Pill.as"
#include "Settings.as"
#include "BlockMatcher.as"
#include "SearchedBlock.as"

BRD_EMPTY = 0;
BRD_VIRUS = 1;
BRD_BLOCK = 2;

/*
 * directional constants
 */
 
DIR_UP = 1;
DIR_RIGHT = 3;
DIR_DOWN = 5;
DIR_LEFT = 7;

/**
 * This is the main class
 */
function Oiramrd(width, height) {
    trace(this + ": Oiramrd");
    this.board = new Array(width);
    this.mcs = new Array(height);
    this.blockMatcher = undefined;
    this.minimumBlocksToClear = 4;
    
    this.width = width;
    this.height = height; 
    for(var i=0; i < width; i++) {
        
        this.board[i] = new Array(height);
        this.mcs[i] = new Array(height);
        
        //for(var j=0; j<height; j++) {
        //    this.board[i].push(EMPTY);
        //}
    }
            
    this.initialize();
}

Oiramrd.prototype.toString = function() {
    return "<Oiramrd width=\""+this.width+"\" height=\"" + this.height+"\">";
}



/**
 * This function initializes an empty board.
 */
Oiramrd.prototype.initialize = function() {
    trace(this + ": Initialize");
    for(var i=0; i < this.width; i++) {
        for(var j=0; j < this.height; j++) {
            this.board[i][j] = BRD_EMPTY;
            if(this.mcs[i][j] != null) {
                this.mcs[i][j].removeMovieClip();
                this.mcs[i][j] = null;
            }
        }
    }
    
    this.factoryPill = new PillFactory();
    
    trace("\tBoard:");
    this.dumpBoard("\t");
}

/**
 * This function is used for debugging purposes, it dumps
 * the contents of the board to stdout
 */
Oiramrd.prototype.dumpBoard = function(tab) {
    str = ""
    if ( tab == undefined ) tab = ""
    //for( var i = this.board.length-1; i >= 0; i --) { 
    // for ( i=0; i < this.board.length; i++ ) {
        // str = str + tab;
        // for ( var j = 0; j < this.board[i].length; j++) {
            // char = this.board[j][i];
            // if ( char == BRD_EMPTY ) char = ".";
            // else if (char == BRD_VIRUS) char = "";
            // else if (char == BRD_BLOCK) char = "#";
            // str = str + char;
        // }
        // str = str + "\n";
    // }
    //for( var i = this.board.length-1; i >= 0; i --) { 
    // for ( i=0; i < this.board.length; i++ ) {
        // str = str + tab;
        // for ( var j = 0; j < this.board[i].length; j++) {
            // str = str + this.board[i][j];
        // }
        // str = str + "\n";
    // }
    for ( var j = 0; j < this.height; j++) {
        str = str + tab;
        for ( i=0; i < this.width; i++ ) {
            char = "?";
            switch ( this.board[i][j] ) {
                case BRD_EMPTY: char = "."; break;
                case BRD_VIRUS: char = "@";  break;
                case BRD_BLOCK: char = "#"; break;
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
Oiramrd.prototype.step = function() {
    // 1 turn
    this.dumpBoard();
    if ( this.isGameOver() ) return;  
    this.applyGravity();
}

Oiramrd.prototype.viriiFill = function(density) {
    avail = this.width * this.height;
    vCount = avail * density;
    vf = new VirusFactory();
    
    trace(this + " avail = " + avail + " vCount = " + vCount);
    empty = this.getRandomEmptyBoardPositions()
    
    midy = Math.floor(this.height / 2);
    
    while(vCount > 0 ) {
        //pos = empty[empty.length -1 ]; 
        pos = empty[Math.floor(Math.random() * empty.length)];
        
        if ( pos.y >= midy ) { // fill below midpoint of board
            
            
            ci = Math.random() * SETTINGS.pillColorCount();
            if ( pos == null ) return;
            virus = vf.getVirus(pos, ci);
            
            trace(this + ": New virus " + virus);
            
            this.setVirus(virus);
            this.display.addVirusToBoard(virus);
            this.display.updateBlock(virus);
            empty.pop();
            vCount --;
        }
    }
    
    this.dumpBoard();
}

Oiramrd.prototype.getRandomEmptyBoardPositions = function() {
    empty = new Array();
    for(i=0; i < this.width; i++) {
        for(j=0; j< this.height; j++ ) {
            if ( this.board[i][j] == BRD_EMPTY ) {
                empty.push( new Point(i, j) );
            }
        }
    }
    
    return empty;
}

Oiramrd.prototype.canRotate = function(myPill, clockwise) {
    if ( clockwise == undefined ) clockwise = true;
    //trace ( this + ":canRotate myPill=" + myPill + " clockwise=" + clockwise );
    
    this.dumpBoard();
    
    cpyPill = myPill.copy();
    this.rotatePill(cpyPill, clockwise);
    
    pos1 = myPill.block1.position;
    pos2 = myPill.block2.position;
    
    n1 = cpyPill.block1.position;
    n2 = cpyPill.block2.position;
    
    b1 = (this.board[n1.x][n1.y] == BRD_EMPTY or n1.equals(pos1) or n1.equals(pos2));
    b2 = (this.board[n2.x][n2.y] == BRD_EMPTY or n2.equals(pos1) or n2.equals(pos2));

    result = b1 and b2 ;
    
    //trace ( "\tb1 = " + b1 + " b2=" + b2 );

    this.dumpBoard();
    
    return result;
}

Oiramrd.prototype.rotatePill = function (myPill, clockwise) {
    trace (this + ":rotatePill myPill=" + myPill + " clockwise=" + clockwise );
    
    p1 = myPill.block1.position;
    p2 = myPill.block2.position;

    trace( "\tp1=" + p1 + " p2=" + p2);
    slope = p1.slope(p2); 
    trace ( "\tslope=" + slope );
    if ( slope == undefined ) { // vertical myPill
        trace ( "\tvertical pill" );
        if ( p1.y > p2.y ) { b1 = myPill.block1; b2 = myPill.block2; } 
        else if ( p2.y > p1.y ) { b2 = myPill.block1; b1 = myPill.block2; }
        else { trace ("SERIOUS ERROR !!!!"); }
        
        trace ( "\tb1=" + b1 + " b2=" + b2);
        
        trace ( "\tb1_orig = " + b1 );
        
        b1.position.y = b2.position.y;
        b1.position.x = clockwise ? b1.position.x + 1 : b1.position.x - 1;
        
        trace ( "\tb1_new = " + b1 );
    }
    else if ( slope == 0 ) { // horizontal myPill   
        trace ( "\thorizontal pill ")
        trace ( "\tp1.x=" + p1.x + " p2.x=" + p2.x );
        
        if ( p1.x > p2.x ) { b1 = myPill.block1; b2 = myPill.block2; } // block1 is rightmost
        else if ( p2.x > p1.x) { b2 = myPill.block1; b1 = myPill.block2; } // block2 is rightmost
        else { trace ("SERIOUS ERROR !!!!"); }
        
        trace ( "\tb1=" + b1 + " b2=" + b2);
        
        trace ( "\tb1_orig = " + b1 );
        
        b1.position.x = b2.position.x;
        b1.position.y = clockwise ? b1.position.y + 1 : b1.position.y - 1;
        
        trace ( "\tb1_new = " + b1 );
    }
    else { // a somehow disjointed myPill
        trace( "SERIOUS ERROR" );
    }
    
    trace ( "\tmyPill=" + myPill );
}


Oiramrd.prototype.getRandomEmptyBoardPos = function() {
    empty = new Array();
    for(i=0; i < this.width; i++) {
        for(j=0; j< this.height; j++ ) {
            if ( this.board[i][j] == BRD_EMPTY ) {
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
Oiramrd.prototype.canFall = function(blk) {
    p = blk.position;
    if ( blk.linkedBlock == null ) {
        return this.board[p.x][p.y + 1] == BRD_EMPTY;
    }
    else { // must check extra things for linked block
        p2 = blk.linkedBlock.position;
        
        lower = p2.y > p.y ? p2 : p; // lower
        higher = lower == p2 ? p: p2;
        
        result = this.board[lower.x][lower.y + 1] == BRD_EMPTY and 
           (this.board[higher.x][higher.y + 1] == BRD_EMPTY or (higher.y + 1 == lower.y));
        
        // trace(higher + " " + lower);
        // trace(higher.y + " " + lower.y);
        // trace(this + ": canFall " + blk + " " + blk.linkedBlock + "? " + result);
        
        
        
        return result;
    }
}

/**
 * Causes all blocks that can fall due to gravity to fall by one board position.
 */
Oiramrd.prototype.applyGravity = function() {
    //trace("ApplyGravity");
    
    if ( this.blockMatcher == undefined ) {
        this.blockMatcher = new BlockMatcher ( this );
        trace("block matcher created.");
        trace("block matcher: " + this.blockMatcher);
    }
    
    
    for(var x=0; x< this.width; x++) { // iterate over columns 
        for(var y=this.height-1; y >=0 ; y--) {
            if (this.mcs[x][y] != undefined) this.mcs[x][y].grav = false;
        }
    }
    
    var numberOfBlocksFallen = 0;
    for(var x=0; x< this.width; x++) { // iterate over columns 
        for(var y=this.height-1; y >=0 ; y--) {
            if( this.board[x][y] == EMPTY or this.board[x][y] == BRD_VIRUS) continue;
            else if ( this.board[x][y] == BRD_BLOCK and this.canFall( this.mcs[x][y] )) { // block and all blocks above must fall
                trace("\tBlock at " + x + ", " + y + " trying to fall.");
                if ( this.mcs[x][y] == undefined ) {
                    trace("ERROR!!!!");
                }
                else {
                    blk = this.mcs[x][y];
                    
                    // if ( blk.linkedBlock == null ) {
                        bb = new BlockBullier();
                        if ( ! blk.grav ) {
                            bb.down(this, blk);
                            blk.grav = true;
                            this.display.updateBlock(blk);
                            trace(this + ": Moving block " + blk);
                            
                            // block has fallen, it becomes a contact point if there are any blocks in the cardinal positions
                            // if ( blk has neighbors and is not falling) 
                            this.blockMatcher.addContactPoint ( blk.position );
                            
                            numberOfBlocksFallen ++;
                            
                            if ( blk.linkedBlock != undefined and ! blk.linkedBlock.grav) {
                                bb.down(this, blk.linkedBlock);
                                blk.linkedBlock.grav = true;
                                
                                // if ( blk has neighbors and is at rest)
                                this.blockMatcher.addContactPoint ( blk.linkedBlock.position );
                                this.display.updateBlock(blk.linkedBlock);
                                trace(this + ": Moving block " + blk.linkedBlock);
                                
                                numberOfBlocksFallen ++;
                            }

                        }
                        
                                                
                        
                        
                    // } 
                    // doesn't work for some reason
                    // else {
                        // pp = new PillPusher();
                        // trace(pp + " " + blk + " " + blk.linkedBlock);
                        // p = new Pill(blk, blk.linkedBlock);
                        // trace("BLAH myPill= " + p);
                        // pp.down(this, p);
                    // }
                    
                    // bugs with this
                    // if ( blk.linkedBlock != null ) { 
                        // bb.down(this, blk.linkedBlock);
                        // display.updateBlock(blk.linkedBlock);
                    // }
                    
                }
            }
        }
    }

    // guarantees clearing only after all blocks fallen
    // this can be changed to clear after some blocks have fallen
    if ( numberOfBlocksFallen == 0 ) {
        trace("block matcher: " + this.blockMatcher);
        trace("contact points=" + this.blockMatcher.getContactPoints().length);
        if ( this.blockMatcher.getContactPoints().length > 0 ) {
            this.blockMatcher.buildSearchGrid();
            this.blockMatcher.setMatched();
            var matchedPoints = this.blockMatcher.getMatchedPoints();            
            if ( matchedPoints.length > 0 ) {
                // clear matched
                trace("matched points:");
                for ( var i= 0 ; i < matchedPoints.length; i ++ ) {
                    trace(matchedPoints[i]);
                    var p = matchedPoints[i].block.position;
                    this.destroyBlock (p.x, p.y);
                }
            } else {
                trace("no matches");
            }
            
            this.blockMatcher = new BlockMatcher ( this ); // reset
        }
    }
    else {
        trace("Number of blocks fallen: " + numberOfBlocksFallen );
    }
    
    
}

/**
 * Tests whther the game is over.
 */
Oiramrd.prototype.isGameOver = function() { 
    return false;
}

/**
 * Tests whether move is valid.
 */
 
Oiramrd.prototype.canMove = function ( myPill, dir ) {
    pos1 = myPill.block1.position; pos2 = myPill.block2.position;
    
    n1 = new Point(pos1.x, pos1.y);
    n2 = new Point(pos2.x, pos2.y);
    
    switch ( dir ) {
        case DIR_DOWN:
            n1.y ++; n2.y++; break;
        case DIR_RIGHT:
            n1.x ++; n2.x ++; break;
        case DIR_UP:
            n1.y--; n2.y--; break;
        case DIR_LEFT:
            n1.x--; n2.x--; break;
    }
    
    
    
    b1 = (this.board[n1.x][n1.y] == BRD_EMPTY or n1.equals(pos1) or n1.equals(pos2));
    b2 = (this.board[n2.x][n2.y] == BRD_EMPTY or n2.equals(pos1) or n2.equals(pos2));
    trace( "pos1=" + pos1 + " pos2=" + pos2);
    trace ( " test b1=" + b1 + " b2=" + b2);
    result = b1 and b2 ;
    
    trace(this + ": canMove myPill=" + myPill + " n1=" + n1 + " n2=" + n2 + "? "+ result);
    
    return result;
        
}

Oiramrd.prototype.insertNextPill = function(pos1) {
    trace("insertNextPill begin");
    
    if ( pos1 == undefined ) pos1 = new Point(1, 1);
    
    if ( this.pf == undefined ) this.pf = new PillFactory();
    
    trace(this + ": Pill factory this.pf = " + this.pf);
    
    myPill = this.pf.getRandomPill(pos1, false);
    trace(this + ": myPill = " + myPill);
    
    this.addPillToBoard(myPill);    
}

Oiramrd.prototype.setBoardPos = function(pos, val) {
    this.board[pos.x][pos.y] = val;
    trace(this + ": setBoardPos pos = " + pos + " val = " + val);
}

Oiramrd.prototype.setMcsPos = function(pos, val) {
    this.mcs[pos.x][ pos.y] = val;
}

Oiramrd.prototype.setPill = function(myPill) {
    p1 = myPill.block1.position;
    p2 = myPill.block2.position;
    this.setBoardPos(p1, BRD_BLOCK);
    this.setBoardPos(p2, BRD_BLOCK);
    this.setMcsPos(p1, myPill.block1);
    this.setMcsPos(p2, myPill.block2);
}

Oiramrd.prototype.setVirus = function(virus) {
    p = virus.position;
    this.setBoardPos(p, BRD_VIRUS);
    this.setMcsPos(p, virus);
}

Oiramrd.prototype.addPillToBoard = function(myPill) {
    trace(this + ":addPillToBoard myPill= " + myPill);
    
    this.setPill(myPill);
    
    this.display.addPillToBoard(myPill);
    
    this.activePill = myPill;
    
    trace(this + ": addPillToBoard");
}

Oiramrd.prototype.getBlock = function ( x, y ) {
    return this.mcs[x][y];
}


Oiramrd.prototype.destroyBlock = function ( x, y ) {
    
    this.board[x][y] = BRD_EMPTY;
    var block = this.getBlock(x, y);
    if ( ! block ) return;
    trace("attempting to destroy block " + block + " with mc " + block.mc);
    this.mcs[x][y] = null;
    block.mc.removeMovieClip();
}

BF = new BlockFactory();