/**
 * Class to build pills.  Should make use of block factory.
 */
function PillFactory() {
    trace("Creating myPill factory");
    this.blockFactory = BF;
    this.getRandomPill = function(pos1, boolUpToDown) {
        if ( boolUpToDown == undefined ) boolUpToDown = true;
        ci1 = Math.floor(Math.random() * SETTINGS.pillColorCount());
        ci2 = Math.floor(Math.random() * SETTINGS.pillColorCount());
        
        pos2 = boolUpToDown ? new Point(pos1.x, pos1.y + 1) :
            new Point(pos1.x + 1, pos1.y);
        
        trace(this + ": getting random myPill with ci1 = " + ci1 + " ci2 = " + ci2 + " pos1 = " + pos1 + " pos2 = " + pos2);
        
        return this.getPill(pos1, ci1, pos2, ci2);
    }
    this.getPill = function(pos1, colorIndex1, pos2, colorIndex2) {
        bf = this.blockFactory;
        
        b1 = bf.getBlock ( pos1, colorIndex1 );
        b2 = bf.getBlock ( pos2, colorIndex2 ); 
        p = new Pill ( b1, b2 );
        trace("PillFactory.getPill: bf = " + bf + " b1=" + b1 + " b2=" + b2 + "?" + p);
        return p;
    }
    this.toString = function() {
        return "<PillFactory>" + this.blockFactory + "</PillFactory>";
    }
}
