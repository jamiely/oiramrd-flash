/**
 * Class to contain block information.  
 */
function Block(position, colorIndex, mc) {
    this.colorIndex = colorIndex;
    this.mc = mc;
    
    
    this.position = position;
    this.canFall = true;
    
    this.linkedBlock = null;
    this.setLinkedBlock = function (b) {
        this.linkedBlock = b;
        if( b != null) b.linkedBlock = this;
    }
    
    this.breakLinks = function() {
        if ( this.linkedBlock ) {
            this.linkedBlock.linkedBlock = null; 
            this.linkedBlock = null;
        }
        
    }
    
    this.toString = function() {
        tmp = new Array("Block", this.position, this.mc, this.colorIndex);
        return "<" + tmp.join(" ") + ">";
    }
    
    this.copy = function() {
        return new Block(this.position.copy(), this.colorIndex, this.mc);
    }
    this.getX = function() {
        return this.position.x;
    }
    this.getY = function() {
        return this.position.y;
    }
}
