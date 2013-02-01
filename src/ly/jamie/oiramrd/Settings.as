package ly.jamie.oiramrd{
  class Settings{
    // global settings object
    public static Shared = new Settings();

    /**
     * Class to contain game settings.
     */
    function Settings() {
        this.pillColors = new Array(
            0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF99);
        this.pillColorCount = function () {
            return this.pillColors.length;
        }
    }
  }
}