package ly.jamie.oiramrd{
  public class Settings{
    // global settings object
    public static var Shared:Settings = new Settings();


    public var pillColors: Array;
    /**
     * Class to contain game settings.
     */
    public function Settings() {
        this.pillColors = new Array(
            0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF99);
    }
    public function pillColorCount(): Number {
        return this.pillColors.length;
    }
  }
}
