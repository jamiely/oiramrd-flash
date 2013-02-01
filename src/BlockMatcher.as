function BlockMatcher(game) {
    trace("creating blockmatcher");
    this.game = game;
    this.searchGrid = null;
    this.contactPointHash = {};
    this.contactPoints = new Array();
    this.debug = true;
    
    this.trace = function ( msg ) {
        if ( this.debug ) trace( msg ) ;
        
    }
    
    this.setMatched = function() {
        this.trace ( "BlockMatched.setMatched: Begin" );
        
        var directions = new Array(DIR_UP, DIR_LEFT);
        var cp, d, neighbor, target;
        for ( var i = 0; i < this.contactPoints.length; i ++ ) {
            cp = this.contactPoints [ i ].position;
            this.trace ("\tBlockMatched.setMatched: contactPoint = " + cp ) ;
            
            target = this.searchGrid [ cp.x ] [ cp.y ];
            this.trace ("\tBlockMatched.setMatched: target = " + target );
            
            
            for ( var j = 0; j < directions.length; j ++ ) {
                d = directions[j];
                this.trace ("\BlockMatched.setMatched: Direction = " + d );
                
                matches = new Array();
                
                neighbor = target;
                
                while ( neighbor ) {
                    neighbor = this.getNeighboringBlock ( neighbor, d );
                    
                    
                    // must not be null
                    if ( ! neighbor ) continue;
                    
                    this.trace ("\BlockMatched.setMatched: Neighbor = " + neighbor );
                    
                    // must not have already been searched
                    if ( neighbor.searched [ d ] ) continue;
                    // must be the same color
                    else if ( neighbor.block.colorIndex != target.block.colorIndex ) continue;
                    // must not have been matched.  
                    // theoretically, would never reach here, b/c if matched, then searched.
                    else if ( neighbor.block.matched ) continue;
                    
                    // already searched in this direction
                    neighbor.searched [ d ] = true;
                    matches.push ( neighbor );
                }
                
                
                d = getOppositeDirection( d );
                this.trace ("\BlockMatched.setMatched: Direction = " + d );
                
                
                neighbor = target;
                
                while ( neighbor ) {
                    neighbor = this.getNeighboringBlock ( neighbor, d );
                    
                    
                    // must not be null
                    if ( ! neighbor ) continue;
                    
                    this.trace ("\BlockMatched.setMatched: Neighbor = " + neighbor );
                    
                    // must not have already been searched
                    if ( neighbor.searched [ d ] ) continue;
                    // must be the same color
                    else if ( neighbor.block.colorIndex != target.block.colorIndex ) break;
                    // must not have been matched.  
                    // theoretically, would never reach here, b/c if matched, then searched.
                    else if ( neighbor.block.matched ) continue;
                    
                    // already searched in this direction
                    neighbor.searched [ d ] = true;
                    matches.push ( neighbor );
                }
                
                
                
                
                
                
                
                
                matches.push ( target );
                
                this.trace ("\BlockMatched.setMatched: # matches = " + matches.length );
                
                if ( matches.length >= this.game.minimumBlocksToClear ) {
                    this.trace ("\BlockMatched.setMatched: setting blocks as matched:\n" + matches.join("\n"));
                    for ( var k = 0 ; k < matches.length; k ++ ) {
                        matches[k].matched = true;
                        
                        
                    }
                    trace ( "ATTEMPTING TO ADD TO SCORE ");
                    this.game.addToScore ( matches.length, this.game.chainLevel );
                }
                else {
                    // did not meet minimum, do nothing
                    
                }
                
            }
        }
    }
    
    this.getMatchedPoints = function () {
        this.trace ( "BlockMatcher.getMatchedPoints: Begin" );
        var matched = new Array();
        
        for(var i=0; i < this.game.width; i ++ ) {
            for ( var j=0; j < this.game.height; j++ ) {
                if ( this.searchGrid[i][j].matched ) 
                    matched.push ( this.searchGrid[i][j] );
            }
        }
        
        return matched;
    }
    
    /**
            * Returns a block from searchGrid
            */
    this.getNeighboringBlock = function ( targetBlock, dir ) {
        var pt = targetBlock.block ? targetBlock.block.position : targetBlock.position,
            x = pt.x,
            y = pt.y;
        
        
        switch ( dir ) {
            case DIR_UP:
                y--;
                break;
            case DIR_DOWN:
                y++;
                break;
            case DIR_RIGHT:
                x++;
                break;
            case DIR_LEFT:
                x--;
                break;
            default:
                return null;
        }
        
        // check bounds
        if ( x >= 0 && x < this.game.width && y >= 0 && y < this.game.height )
            return this.searchGrid[x][y];
            
        return null;
    }
    
    this.addContactBlock = function( blk ) { 
        // hash guarantees unqiue points
        
        if ( ! this.contactPointHash [ blk.mc._target ] ) {
            this.contactPoints.push ( blk );
            // need some marker, does not have to be true
            this.contactPointHash [ blk.mc._target ] = true;
        }
    }
    
    this.buildSearchGrid = function() {
        this.searchGrid = new Array(this.game.width);
        for(var i=0; i < this.game.width; i++) {
            this.searchGrid[i] = new Array(this.game.height);
        }
        
        for(var i=0; i < this.game.width; i ++ ) {
            for ( var j=0; j < this.game.height; j++ ) {
                this.searchGrid[i][j] = new SearchedBlock ( this.game.getBlock ( i, j ) );
            }
        }
    }
    
    this.dumpBoard = function(tab) {
        str = ""
        if ( tab == undefined ) tab = ""
        
        for ( var j = 0; j < this.game.height; j++) {
            str = str + tab;
            for ( i=0; i < this.game.width; i++ ) {
                chr = this.searchGrid[i][j].block ? this.searchGrid[i][j].block.colorIndex : ".";
                str = str + chr;
            }
            str = str + "\n";
        }
        
        trace(str);
    }

 
    this.getContactBlocks = function() {    
        return this.contactPoints;
    }
    /**/
    
    this.toString = function () {
        return "block matcher";
    }
}