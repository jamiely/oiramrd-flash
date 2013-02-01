package ly.jamie.oiramrd {
  class Constants {
    /**
     * board constants
     */
    BRD_EMPTY = 0;
    BRD_VIRUS = 1;
    BRD_BLOCK = 2;


    DEFAULT_TICKSPERSTEP = 5;


    /*
     * directional constants
     */
     
    DIR_UP = 1;
    DIR_RIGHT = 3;
    DIR_DOWN = 5;
    DIR_LEFT = 7;

    function getOppositeDirection(dir) {
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
