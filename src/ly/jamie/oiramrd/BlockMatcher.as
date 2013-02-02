package ly.jamie.oiramrd {
  public class BlockMatcher {

    private var game:Oiramrd;
    private var searchGrid:*;
    private var contactPointHash: Object;
    private var contactPoints:Array;
    private var debug: Boolean;

    function BlockMatcher(game: Oiramrd) {
        trace("creating blockmatcher");
        this.game = game;
        this.searchGrid = null;
        this.contactPointHash = {};
        this.contactPoints = new Array();
        this.debug = true;

    }

    public function trace( msg: String ): void {
        if ( this.debug ) trace( msg ) ;
    }

    public function setMatched(): void {
        this.trace ( "BlockMatched.setMatched: Begin" );

        var directions:Array = new Array(Constants.DIR_UP, Constants.DIR_LEFT);
        var cp:Point, d:Number, neighbor:SearchedBlock, target:SearchedBlock;

        for ( var i:Number = 0; i < this.contactPoints.length; i ++ ) {
            cp = this.contactPoints [ i ].position;
            this.trace ("\tBlockMatched.setMatched: contactPoint = " + cp ) ;

            target = this.searchGrid [ cp.x ] [ cp.y ];
            this.trace ("\tBlockMatched.setMatched: target = " + target );


            for ( var j:Number = 0; j < directions.length; j ++ ) {
                d = directions[j];
                this.trace ("\BlockMatched.setMatched: Direction = " + d );

                var matches: Array = new Array();

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
                    else if ( neighbor.matched ) continue;

                    // already searched in this direction
                    neighbor.searched [ d ] = true;
                    matches.push ( neighbor );
                }


                d = Constants.getOppositeDirection( d );
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
                    else if ( neighbor.matched ) continue;

                    // already searched in this direction
                    neighbor.searched [ d ] = true;
                    matches.push ( neighbor );
                }








                matches.push ( target );

                this.trace ("\BlockMatched.setMatched: # matches = " + matches.length );

                if ( matches.length >= this.game.minimumBlocksToClear ) {
                    this.trace ("\BlockMatched.setMatched: setting blocks as matched:\n" + matches.join("\n"));
                    for ( var k: Number = 0 ; k < matches.length; k ++ ) {
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

    public function getMatchedPoints(): Array {
        this.trace ( "BlockMatcher.getMatchedPoints: Begin" );
        var matched:Array = new Array();

        for(var i:Number=0; i < this.game.width; i ++ ) {
            for ( var j:Number=0; j < this.game.height; j++ ) {
                if ( this.searchGrid[i][j].matched ) 
                    matched.push ( this.searchGrid[i][j] );
            }
        }

        return matched;
    }

    /**
    * Returns a block from searchGrid
    */
    public function getNeighboringBlock( targetBlock: SearchedBlock, dir: Number ): SearchedBlock {
        var pt: Point = targetBlock.block.position,
            x:Number = pt.x,
            y: Number = pt.y;


        switch ( dir ) {
            case Constants.DIR_UP:
                y--;
                break;
            case Constants.DIR_DOWN:
                y++;
                break;
            case Constants.DIR_RIGHT:
                x++;
                break;
            case Constants.DIR_LEFT:
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

    public function addContactBlock( blk: Block ): void { 
        // hash guarantees unqiue points

        if ( ! this.contactPointHash [ blk.mc._target ] ) {
            this.contactPoints.push ( blk );
            // need some marker, does not have to be true
            this.contactPointHash [ blk.mc._target ] = true;
        }
    }

    public function buildSearchGrid(): void {
        this.searchGrid = new Array(this.game.width);
        for(var i:Number=0; i < this.game.width; i++) {
            this.searchGrid[i] = new Array(this.game.height);
        }

        for(i=0; i < this.game.width; i ++ ) {
            for ( var j:Number=0; j < this.game.height; j++ ) {
                this.searchGrid[i][j] = new SearchedBlock ( this.game.getBlock ( i, j ) );
            }
        }
    }

    public function dumpBoard(tab: String = ""): void {
        var str: String = ""

        for ( var j: Number=0; j < this.game.height; j++) {
            str = str + tab;
            for ( var i: Number=0; i < this.game.width; i++ ) {
                var chr: String = this.searchGrid[i][j].block ? 
                  this.searchGrid[i][j].block.colorIndex : ".";
                str = str + chr;
            }
            str = str + "\n";
        }

        trace(str);
    }

 
    public function getContactBlocks(): Array {
        return this.contactPoints;
    }
  }
}
