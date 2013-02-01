package ly.jamie.oiramrd {
  class Block {
    /**
     * Class to contain block information.
     */
    function Block(position, colorIndex, mc) {
        this.colorIndex = colorIndex;
        this.mc = mc;


        this.position = position;
        this.canFall = true;

        this.linkedBlock = null;
    }

    public function setLinkedBlock (b: Block): void {
        this.linkedBlock = b;
        if( b != null) b.linkedBlock = this;
    }

    public function breakLinks(): void {
        if ( this.linkedBlock ) {
            this.linkedBlock.linkedBlock = null; 
            this.linkedBlock = null;
        }

    }

    public function toString(): void {
        tmp = new Array("Block", this.position, this.mc, this.colorIndex);
        return "<" + tmp.join(" ") + ">";
    }

    public function copy(): void {
        return new Block(this.position.copy(), this.colorIndex, this.mc);
    }
    public function getX(): void {
        return this.position.x;
    }
    public function getY(): void {
        return this.position.y;
    }


  }
}

