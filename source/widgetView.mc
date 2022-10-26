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

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        var textLabel1 = self.View.findDrawableById("Description") as Text;
        textLabel1.setText("PM 2.5 out/in:");

        var request = new HttpRequest(self.method(:changeText));
        var textLabel2 = self.View.findDrawableById("Value") as Text;
        textLabel2.setText("connecting...");
        request.makeRequest();
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
    }

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
            Ui.popView(0);
            System.println("Request Successful");
            Application.getApp().setProperty("zakupy", data["zakupy"]);
            self.onReceiveExternal.invoke(data["airlypm25"] + "/" + data["ikeapm25"]);
        } else {
            Ui.popView(0);
            System.println("Response: " + responseCode);
            self.onReceiveExternal.invoke("Can't connect:" + responseCode);
        }        
    }

    function makeRequest() as Void {
        Ui.pushView( new LoadingView(), null, 0);
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
