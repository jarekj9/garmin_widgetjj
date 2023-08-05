import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class OtherView extends WatchUi.View {

    var valueText as String;

    function initialize() {
        View.initialize();
        self.valueText = "";
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        var request = new HttpRequest(self.method(:onRespReceived));
        request.makeRequest();
        self.onRespReceived();
    }

    function onShow() as Void {

    }

    function onUpdate(dc as Dc) as Void {
        // View.onUpdate(dc);
        // var descriptionLabel = self.View.findDrawableById("Description") as Text;
        // descriptionLabel.setText("PM 2.5 out/in:");
        // var textLabel = self.View.findDrawableById("Value") as Text;
        // textLabel.setText(Extensions.getPropertyOrStorage("pm25"));

        View.onUpdate(dc);
        var writer = new WrapText();
        var posY = dc.getHeight() / 6;
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        if (self.valueText != null) {
            posY = writer.writeLines(dc, self.valueText, Gfx.FONT_SMALL, posY);
        }
    }

    function onHide() as Void {
    }

    function onRespReceived() as Void {
        self.valueText = Extensions.getPropertyOrStorage("zakupy");
        Ui.requestUpdate();
    }
}

class HttpRequest {
    protected var onAfterReceive;
    public function initialize(onAfterReceiveArg) {
        onAfterReceive = onAfterReceiveArg;
    }
    
    function onReceive(responseCode as Number, data as Null or Dictionary or String) as Void {
        if (responseCode == 200) {
            Ui.popView(Ui.SLIDE_DOWN);
            System.println("Request Successful");
            Extensions.setPropertyAndStorage("zakupy", data["zakupy"]);
            Extensions.setPropertyAndStorage("pm25", data["airlypm25"] + "/" + data["ikeapm25"]);
            self.onAfterReceive.invoke();
        } else {
            Ui.popView(Ui.SLIDE_DOWN);
            System.println("Response: " + responseCode);
            self.onAfterReceive.invoke("Can't connect:" + responseCode + "\n" + Extensions.getPropertyOrStorage("pm25"));
        }        
    }

    function makeRequest() as Void {
        Ui.pushView( new LoadingView(), null, Ui.SLIDE_DOWN);
        var url = "https://garmin.y4r3k.duckdns.org/garmininfo";
        var app = Application.getApp();
        
        var params = {
            //"definedParams" => "123456789abcdefg"
        };
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Authorization" => app.getProperty("apikey"),
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        var responseCallback = self.method(:onReceive);
        Communications.makeWebRequest(url, params, options, responseCallback);
    }
}

