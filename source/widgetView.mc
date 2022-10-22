import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
using Toybox.WatchUi as Ui;

class widgetView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        var textLabel1 = self.View.findDrawableById("Description") as Text;
        textLabel1.setText("PM 2.5 out/in:");

        var request = new HttpRequest(self.method(:changeText));
        var textLabel2 = self.View.findDrawableById("Value") as Text;
        textLabel2.setText("connecting...");
        request.makeRequest();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout

        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function changeText(text) as Void {
        var textLabel2 = self.View.findDrawableById("Value") as Text;
        textLabel2.setText(text);
        Ui.requestUpdate();
    }

}


class HttpRequest {
    protected var onReceiveExternal;
    public function initialize(onReceiveExternalArg) {
        onReceiveExternal = onReceiveExternalArg;
    }

    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            System.println("Request Successful");

        } else {
            System.println("Response: " + responseCode);
        }
        //self.onReceiveExternal.invoke(data["Name"]);
        self.onReceiveExternal.invoke(data["airlypm25"] + "/" + data["ikeapm25"]);
    }

    function makeRequest() as Void {
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

        var responseCallback = method(:onReceive);
        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }
}
