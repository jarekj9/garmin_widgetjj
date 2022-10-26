import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class OtherView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() as Void {

    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        var app = Application.getApp();
        
        var writer = new WrapText();
        var posY = dc.getHeight() / 6;
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        posY = writer.writeLines(dc, app.getProperty("zakupy"), Gfx.FONT_SMALL, posY);
    }

    function onHide() as Void {
    }

}

