package ly.jamie.oiramrd {
  // Matches blocks
  import flash.utils.Dictionary;
  public class Matcher {
    private var matchMin: Number = 4;
    private static var VERTICAL: Number = 99;
    private static var HORIZONTAL: Number = 101;
    private var game: Oiramrd = null;

    public function Matcher(game: Oiramrd) {
      this.game = game;
    }

    // accepts a board state. checks each block for matches
    //
    public function getAllMatchBlocks(): Array {
      var matched: Array = [];
      for each(var block: Block in this.getAllBlocks()) {
        matched = matched.concat(this.getMatchBlocks(block));
      }
      return this.uniqueBlocks(matched);
    }

    public function getAllBlocks(): Array {
      return this.game.allBlocks();
    }

    // Given a block, gets all the other blocks that are part of
    // the match it forms. These blocks should be removed from
    // the board.
    private function getMatchBlocks(block: Block): Array {
      var matchBlocks: Array = [];
      for each(var axis:Number in [VERTICAL, HORIZONTAL]) {
        var axisBlocks: Array = this.getMatchBlocksOnAxis(axis, block);
        if(axisBlocks.length >= matchMin) {
          matchBlocks = matchBlocks.concat(axisBlocks);
        }
      }
      return matchBlocks;
      //return this.uniqueBlocks(matchBlocks);
    }

    private function getMatchBlocksOnAxis(axis: Number, block: Block): Array {
      var rtn: Array = [];
      for each(var step: Number in [1, -1]) {
        rtn = rtn.concat(this.getMatchBlocksOnAxisWithStep(axis, block, step));
      }
      return rtn;
    }

    // @step should be 1 or -1
    private function getMatchBlocksOnAxisWithStep(
      axis:Number, block: Block, step: Number): Array {

      var nextBlock: Block = this.getNextBlock(block, axis, step);
      if(! nextBlock) return []; 

      if(! this.colorsMatch(block, nextBlock)) return [];

      return [nextBlock].concat(this.getMatchBlocksOnAxisWithStep(axis, nextBlock, step));
    }

    private function colorsMatch(a: Block, b: Block): Boolean {
      return a && b && a.colorIndex == b.colorIndex;
    }

    private function getNextBlock(block: Block, axis: Number, step: Number): Block {
      var pt: Point = block.position.copy(); 
      if(axis == VERTICAL) {
        pt.y += step;
      } else {
        pt.x += step;
      }
      return this.blockAt(pt);
    }

    private function blockAt(pt: Point): Block {
      return this.game.blockAt(pt);
    }

    private function uniqueBlocks(blocks: Array): Array {
      var hash: Dictionary = new Dictionary();
      for each(var blk:Block in blocks) {
        hash[blk.position.toString()] = blk;
      }
      var rtn: Array = [];
      for(var k:String in hash) {
        rtn.push(hash[k]);
      }
      return rtn;
    }
  }
}

