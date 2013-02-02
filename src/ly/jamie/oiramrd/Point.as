package ly.jamie.oiramrd {
  public class Point {
    public var x:Number;
    public var y:Number;

    function Point(x:Number, y:Number) {
      this.x = x;
      this.y = y;
    }
    public function toString(): String {
      return "(" + this.x + ", " + this.y + ")";
    }
    public function copy(): Point {
      return new Point(this.x, this.y);
    }
    public function equals(p: Point): Boolean {
      return this.x == p.x && this.y == p.y;
    }
    public function slope(p: Point): * {
      var dx: Number = this.x - p.x;
      return dx == 0 ? undefined : (this.y - p.y)/dx;
    }
  }
}


