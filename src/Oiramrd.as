
#include "constants.as"
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


/**
 * This is the main class
 */
function Oiramrd(width, height) {
    trace(this + ": Oiramrd");
    this.board = new Array(width);
    this.mcs = new Array(height);
    this.blockMatcher = undefined;
    this.minimumBlocksToClear = 4;
    this.ticksPerStep = DEFAULT_TICKSPERSTEP ;
    this.viriiCount = 0;
    this.density = 0;
    this.level = 1;
    
    
    
    
    this.width = width;
    this.height = height; 
    
    this.score = 0;
    this.chainLevel = 1; // multiplier for score
    
    for(var i=0; i < width; i++) {
        
        this.board[i] = new Array(height);
        this.mcs[i] = new Array(height);
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
    this.density = density;

    avail = this.width * this.height;
    vCount = Math.floor(avail * density);
    vf = new VirusFactory();
    
    trace(this + " avail = " + avail + " vCount = " + vCount);
    empty = this.getRandomEmptyBoardPositions();
    
    midy = Math.floor(this.height / 4);
    
    this.viriiCount = vCount;
    this.display.setViriiCount ( this.viriiCount );
    
    while(vCount > 0 ) {
        //pos = empty[empty.length -1 ]; 
        pos = empty[empty.length-1];
        
        
        
        if ( pos.y >= midy ) { // fill below midpoint of board
            
            
            ci = Math.floor(Math.random() * SETTINGS.pillColorCount());
            trace ( ci );
            if ( pos == null ) return;
            virus = vf.getVirus(pos, ci);
            
            trace(this + ": New virus " + virus);
            
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
function fisherYates ( myArray ) {
  for ( var i = myArray.length - 1; i >= 0; i-- ) {
     var j = Math.floor( Math.random() * ( i + 1 ) );
     var tempi = myArray[i];
     var tempj = myArray[j];
     myArray[i] = tempj;
     myArray[j] = tempi;
   }
}

Oiramrd.prototype.getRandomEmptyBoardPositions = function() {
    var positions = this.getEmptyBoardPositions();
    fisherYates(positions);
    return positions;
}

Oiramrd.prototype.getEmptyBoardPositions = function() {
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

    //trace( "\tp1=" + p1 + " p2=" + p2);
    slope = p1.slope(p2); 
    //trace ( "\tslope=" + slope );
    if ( slope == undefined ) { // vertical myPill
        //trace ( "\tvertical pill" );
        if ( p1.y > p2.y ) { b1 = myPill.block1; b2 = myPill.block2; } // block 1 is bottom most
        else if ( p2.y > p1.y ) { b2 = myPill.block1; b1 = myPill.block2; } // block 2 is bottomost
        else { trace ("SERIOUS ERROR !!!!"); }
        
        b2.position.y = b1.position.y;
        b1.position.x = clockwise ? b1.position.x + 1 : b1.position.x - 1;
        
        //trace ( "\tb1_new = " + b1 );
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
        
        //trace ( "\tb1_new = " + b1 );
    }
    else { // a somehow disjointed myPill
        trace( "SERIOUS ERROR" );
    }
    
    //trace ( "\tmyPill=" + myPill );
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

Oiramrd.prototype.setScore = function( score ) {
    this.score = score;
    this.display.setScore ( this.score );
}

Oiramrd.prototype.addToScore = function ( blocksCleared, chainLevel ) {
    //trace("ADDING TO SCORE");
    this.setScore ( (this.getScore() + blocksCleared * 10 * chainLevel) * this.level );
}

Oiramrd.prototype.getScore = function( ) {
    return this.score;
}

/**
 * Causes all blocks that can fall due to gravity to fall by one board position.
 */
Oiramrd.prototype.applyGravity = function() {
    //trace("ApplyGravity");
    
    if ( this.blockMatcher == undefined ) {
        this.blockMatcher = new BlockMatcher ( this );
        //trace("block matcher created.");
        //trace("block matcher: " + this.blockMatcher);
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
                //trace("\tBlock at " + x + ", " + y + " trying to fall.");
                if ( this.mcs[x][y] == undefined ) {
                    trace("ERROR!!!!");
                }
                else {
                    blk = this.mcs[x][y];
                    bb = new BlockBullier();
                    if ( ! blk.grav ) {
                        bb.down(this, blk);
                        blk.grav = true;
                        this.display.updateBlock(blk);
                        //trace(this + ": Moving block " + blk);
                        
                        // block has fallen, it becomes a contact point if there are any blocks in the cardinal positions
                        // if ( blk has neighbors and is not falling) 
                        this.blockMatcher.addContactBlock ( blk );
                        
                        numberOfBlocksFallen ++;
                        
                        if ( blk.linkedBlock != undefined and ! blk.linkedBlock.grav) {
                            bb.down(this, blk.linkedBlock);
                            blk.linkedBlock.grav = true;
                            
                            // if ( blk has neighbors and is at rest)
                            this.blockMatcher.addContactBlock ( blk.linkedBlock );
                            this.display.updateBlock(blk.linkedBlock);
                            //trace(this + ": Moving block " + blk.linkedBlock);
                            
                            numberOfBlocksFallen ++;
                        }

                    }                    
                }
            }
        }
    }

    // guarantees clearing only after all blocks fallen
    // this can be changed to clear after some blocks have fallen
    if ( numberOfBlocksFallen == 0 ) {
        //trace("block matcher: " + this.blockMatcher);
        //trace("contact points=" + this.blockMatcher.getContactBlocks().length);
        if ( this.blockMatcher.getContactBlocks().length > 0 ) {
            this.blockMatcher.buildSearchGrid();
            this.blockMatcher.setMatched();
            var matchedPoints = this.blockMatcher.getMatchedPoints();            
            if ( matchedPoints.length > 0 ) {
                // clear matched
                //trace("matched points:");
                for ( var i= 0 ; i < matchedPoints.length; i ++ ) {
                    //trace(matchedPoints[i]);
                    var p = matchedPoints[i].block.position;
                    this.destroyBlock (p.x, p.y);
                }
                this.display.sound.start();
                
                this.chainLevel ++;
                
            } else {
                //trace("no matches");
            }
            
            //trace("Block Matcher Board");
            this.blockMatcher.dumpBoard();
            
            this.blockMatcher = new BlockMatcher ( this ); // reset
            this.ticksPerStep = 1; // increase speed momentarily to clear all chains
        }
        else {
            this.ticksPerStep = DEFAULT_TICKSPERSTEP ;
            this.insertNextPill();
            
            this.chainLevel = 1;
        }
    }
    else {
        //trace("Number of blocks fallen: " + numberOfBlocksFallen );
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
    //trace( "pos1=" + pos1 + " pos2=" + pos2);
    //trace ( " test b1=" + b1 + " b2=" + b2);
    result = b1 and b2 ;
    
    //trace(this + ": canMove myPill=" + myPill + " n1=" + n1 + " n2=" + n2 + "? "+ result);
    
    return result;
        
}

Oiramrd.prototype.insertNextPill = function(pos1) {
    //trace("insertNextPill begin");
    
    if ( pos1 == undefined ) pos1 = new Point(1, 1);
    
    if ( this.pf == undefined ) this.pf = new PillFactory();
    
    //trace(this + ": Pill factory this.pf = " + this.pf);
    
    myPill = this.pf.getRandomPill(pos1, false);
    //trace(this + ": myPill = " + myPill);
    
    this.addPillToBoard(myPill);    
    
    this.blockMatcher.addContactBlock ( myPill.block1 );
    this.blockMatcher.addContactBlock ( myPill.block2 );
}

Oiramrd.prototype.setBoardPos = function(pos, val) {
    this.board[pos.x][pos.y] = val;
    //trace(this + ": setBoardPos pos = " + pos + " val = " + val);
}

Oiramrd.prototype.setMcsPos = function(pos, val) {
    this.mcs[pos.x][ pos.y] = val;
}

Oiramrd.prototype.setPill = function(myPill) {
    var p1 = myPill.block1.position;
    var p2 = myPill.block2.position;
    this.setBoardPos(p1, BRD_BLOCK);
    this.setBoardPos(p2, BRD_BLOCK);
    this.setMcsPos(p1, myPill.block1);
    this.setMcsPos(p2, myPill.block2);
}

Oiramrd.prototype.setVirus = function(virus) {
    var p = virus.position;
    this.setBoardPos(p, BRD_VIRUS);
    this.setMcsPos(p, virus);
}

Oiramrd.prototype.addPillToBoard = function(myPill) {
    //trace(this + ":addPillToBoard myPill= " + myPill);
    
    this.setPill(myPill);
    
    this.display.addPillToBoard(myPill);
    
    this.activePill = myPill;
    
    //trace(this + ": addPillToBoard");
}

Oiramrd.prototype.getBlock = function ( x, y ) {
    if ( this.mcs.length <= x || x < 0 || this.mcs[x].length <= y || y < 0 ) return null;
    return this.mcs[x][y];
}

Oirmard.prototype.nextLevel = function() {
    trace("NEXT LEVEL");
    this.viriiFill ( this.density /= 2 );
    this.level ++;
    this.display.setLevel( this.level );
}


Oiramrd.prototype.destroyBlock = function ( x, y ) {
    if ( this.board[x][y] == BRD_VIRUS ) {
        this.viriiCount --;
        this.display.setViriiCount ( this.viriiCount );
        
        if ( this.viriiCount <= 0 ) {
            //this.nextLevel();
            trace("NEXT LEVEL");
            this.viriiFill ( this.density *= 2 );
            this.level ++;
            this.display.setLevel( this.level );
        }
    }
    this.board[x][y] = BRD_EMPTY;
    var block = this.getBlock(x, y);
    block.breakLinks();
    if ( ! block ) return;
    trace("attempting to destroy block " + block + " with mc " + block.mc);
    this.mcs[x][y] = null;
    block.mc.removeMovieClip();
}



BF = new BlockFactory();