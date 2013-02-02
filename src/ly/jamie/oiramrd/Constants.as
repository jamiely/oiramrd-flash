package ly.jamie.oiramrd {
  public class Constants {
    /**
     * board constants
     */
    public static var BRD_EMPTY:Number = 0;
    public static var BRD_VIRUS:Number = 1;
    public static var BRD_BLOCK:Number = 2;


    public static var DEFAULT_TICKSPERSTEP:Number = 5;


    /*
     * directional constants
     */
     
    public static var DIR_UP:Number = 1;
    public static var DIR_RIGHT:Number = 3;
    public static var DIR_DOWN:Number = 5;
    public static var DIR_LEFT:Number = 7;

    public static function getOppositeDirection(dir:Number):Number {
        switch ( dir ) {
            case DIR_UP: return DIR_DOWN;
            case DIR_DOWN: return DIR_UP;
            case DIR_LEFT: return DIR_RIGHT;
            case DIR_RIGHT: return DIR_LEFT;
        }
        return -1;
    }
  }
}
