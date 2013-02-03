package ly.jamie.oiramrd {
  public class BlockMatcher {

    private var game:Oiramrd;
    private var searchGrid:*;
    private var contactPointHash: Object;
    private var contactPoints:Array;
    private var debug: Boolean;
    public var trace: Function = function(msg:String):void{};

    function BlockMatcher(game: Oiramrd) {
        trace("creating blockmatcher");
        this.game = game;
        this.searchGrid = new Array();
        this.searchGrid.push(new Array());
        this.contactPointHash = {};
        this.contactPoints = new Array();
        this.debug = true;
    }

    private function setMatchesAtPoint(cp: Point): void {
      var target: SearchedBlock = this.searchGrid [ cp.x ] [ cp.y ];
      var directions:Array = new Array(Constants.DIR_UP, Constants.DIR_LEFT);

      for ( var j:Number = 0; j < directions.length; j ++ ) {
        var d: Number = directions[j];
        this.setMatchesInDirection(target, d);
      }
    }

    private function setMatchesInDirection(target: SearchedBlock, d: Number): void {
      var matches: Array = new Array();
      matches.concat(this.retrieveMatches(target, d));

      d = Constants.getOppositeDirection( d );
      matches.concat(this.retrieveMatches(target, d));

      matches.push ( target );

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

    private function retrieveMatches(target: SearchedBlock, d:Number): Array {
      var neighbor:SearchedBlock = target;
      var iterations: Number = 0;
      var MAX_ITERATIONS: Number = 30;
      var matches: Array = new Array();
      while ( neighbor ) {
        if(iterations > MAX_ITERATIONS) {
          break;
        }

        neighbor = this.findNeighboringBlock(target, d);
        if(neighbor) {
          matches.push ( neighbor );
        }

        iterations ++;
      }
      return matches;
    }

    private function findNeighboringBlock(target: SearchedBlock, d:Number): SearchedBlock {
      var neighbor: SearchedBlock = this.getNeighboringBlock ( neighbor, d );
      if ( ! neighbor ) return null;

      if ( neighbor.searched [ d ] ) {
        return null; // must not have already been searched
      } else if ( neighbor.block 
               && neighbor.block.colorIndex != target.block.colorIndex ) {
        return null; // must be the same color
      } else if ( neighbor.matched ) {
        // must not have been matched. theoretically, would never reach here, 
        // b/c if matched, then searched.
        return null;
      }

      // already searched in this direction
      neighbor.searched [ d ] = true;

      return neighbor;
    }

    public function setMatched(): void {
      for ( var i:Number = 0; i < this.contactPoints.length; i ++ ) {
        setMatchesAtPoint(this.contactPoints [ i ].position);
      }
    }

    public function getMatchedPoints(): Array {
        this.trace ( "BlockMatcher.getMatchedPoints: Begin" );
        var matched:Array = new Array();

        for(var i:Number=0; i < this.game.width; i ++ ) {
            for ( var j:Number=0; j < this.game.height; j++ ) {
                if ( this.searchGrid[i][j].matched ) {
                    matched.push ( this.searchGrid[i][j] );
                }
            }
        }

        return matched;
    }

    public function pointFromDirection(pt: Point, dir: Number): Point {
      var x:Number = pt.x, y:Number = pt.y;

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

      return new Point(x, y);
    }
    /**
    * Returns a block from searchGrid
    */
    public function getNeighboringBlock( targetBlock: SearchedBlock, 
                                        dir: Number ): SearchedBlock {
      if(!targetBlock) return null;

      var pt: Point = targetBlock.block.position,
          x:Number = 0,
          y: Number = 0;

      if(!pt) return null;

      var newPt: Point = pointFromDirection(pt, dir);
      if(!newPt) return null;

      return this.searchBlockAt(newPt);
    }

    public function searchBlockAt(pt: Point): SearchedBlock {
      var x: Number = pt.x;
      var y: Number = pt.y;

      if ( this.searchGrid 
          && x >= 0 && x < this.searchGrid.length && this.searchGrid.length > 0
          && this.searchGrid[x] && y >= 0 && y < this.searchGrid[x].length && this.searchGrid[x].length > 0 ) {
          var blk:SearchedBlock = this.searchGrid[x][y];
          return blk;
      }
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
