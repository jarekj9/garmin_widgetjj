import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
using Toybox.WatchUi as Ui;
using Toybox.Application.Storage;
using Toybox.Graphics as Gfx;

class widgetView extends WatchUi.View {

    var valueText as String = "";

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() as Void {
        self.valueText = Extensions.getPropertyOrStorage("zakupy");
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        var writer = new WrapText();
        var posY = dc.getHeight() / 6;
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        if(self.valueText != null) {
            posY = writer.writeLines(dc, self.valueText, Gfx.FONT_SMALL, posY);
        }
    }

    function onHide() as Void {
    }
}
