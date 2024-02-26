import Toybox.System;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Lang;

(:glance)
class WidgetGlanceView extends Ui.GlanceView {
	
    var glanceTitle="ListJJ";
    var valueTextline1 as String = "";
    var valueTextline2 as String = "";
    var valueTextline3 as String = "";


    function initialize() {
        GlanceView.initialize();
        var zakupyArray = Extensions.getPropertyOrStorageArr("zakupy");
        var valueText = Extensions.arrayToString(zakupyArray, ", ");

        var maxLineChars = 25;
        var lastCharPos = valueText.length() < maxLineChars ? valueText.length() : maxLineChars;
        self.valueTextline1 = valueText.substring(0, lastCharPos);
        if(lastCharPos < valueText.length())
        {
            lastCharPos = valueText.length() < 2*maxLineChars ? valueText.length() : 2*maxLineChars;
            self.valueTextline2 = valueText.substring(maxLineChars, lastCharPos);
        }
        if(lastCharPos < valueText.length())
        {
            lastCharPos = valueText.length() < 3*maxLineChars ? valueText.length() : 3*maxLineChars;
            self.valueTextline3 = valueText.substring(maxLineChars*2, valueText.length());
        }
    }
    
    function onUpdate(dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(0, 0, Graphics.FONT_XTINY, self.glanceTitle,Graphics.TEXT_JUSTIFY_LEFT);
        if (self.valueTextline1 != null) {
            dc.drawText(0, 20, Graphics.FONT_XTINY, self.valueTextline1, Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(0, 40, Graphics.FONT_XTINY, self.valueTextline2, Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(0, 60, Graphics.FONT_XTINY, self.valueTextline3, Graphics.TEXT_JUSTIFY_LEFT);

        }
  }
}
