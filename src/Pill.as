/**
 * Class to contain myPill information,  A myPill consists of two blocks.
 */
function Pill(b1, b2) {
    this.block1 = b1;
    this.block2 = b2;
    this.blocks = new Array(b1, b2);
    
    trace("b1 = " + b1 + " b2 = " + b2);
    
    b1.setLinkedBlock(b2); // blocks are connected
    
    this.toString = function() {
        return "<" + this.block1 + " : " + this.block2 + ">";
    }
    
    this.copy = function () { 
        return new Pill(this.block1.copy(), this.block2.copy());
    }
}

