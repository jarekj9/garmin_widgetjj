using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

(:glance)
class WidgetGlanceView extends Ui.GlanceView {
	
    var glanceTitle="ListJJ";
    var glanceText="Text text text";

    function initialize() {
        GlanceView.initialize();
    }
    
    function onUpdate(dc) as Void {
        if (glanceText != null) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.drawText(0, 0, Graphics.FONT_XTINY, glanceTitle,Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(0, 20, Graphics.FONT_SMALL, glanceText,Graphics.TEXT_JUSTIFY_LEFT);
        }
  }
}
