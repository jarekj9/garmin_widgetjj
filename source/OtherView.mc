import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class OtherView extends WatchUi.View {

    var valueText as String;
    var choiceText as String;
    var onButtonDown = self.method(:onButtonDownAction);
    var onButtonUp = self.method(:onButtonUpAction);
    var onButtonSelect = self.method(:onButtonSelectAction);
    var itemsArray = [];
    var currentChoicePosition = 0;

    function initialize() {
        View.initialize();
        self.valueText = "";
        self.choiceText = "--scroll--";
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
        if (self.valueText != null) {
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
            posY = writer.writeLines(dc, self.valueText, Gfx.FONT_TINY, posY);
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_WHITE);
            dc.drawText(130, 10, Gfx.FONT_TINY , self.choiceText, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    function onButtonDownAction() as Void {
        if(self.currentChoicePosition < itemsArray.size() - 1) {
            self.currentChoicePosition++;
        }
        self.choiceText = itemsArray[self.currentChoicePosition].values()[0];
        Ui.requestUpdate();
    }

    function onButtonUpAction() as Void {
        if(self.currentChoicePosition > 0) {
            self.currentChoicePosition--;
        }
        self.choiceText = itemsArray[self.currentChoicePosition].values()[0];
        Ui.requestUpdate();
    }

    function onButtonSelectAction() as Void {
        var request = new HttpRequest(self.method(:onRespReceived));
        request.makeDeleteRequest();
        self.onRespReceived();
    }

    function onHide() as Void {
    }

    function onRespReceived() as Void {
        var zakupyArray  = Extensions.getPropertyOrStorageArr("zakupy");
        self.valueText = Extensions.arrayToString(zakupyArray, ", ");
        itemsArray = zakupyArray;
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
            Extensions.setPropertyAndStorageArr("zakupy", data["zakupy"]);
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

    function makeDeleteRequest() as Void {
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

        var responseCallback = self.method(:onDeleteReceive);
        Communications.makeWebRequest(url, params, options, responseCallback);
    }

    function onDeleteReceive(responseCode as Number, data as Null or Dictionary or String) as Void {
        if (responseCode == 200) {
            Ui.popView(Ui.SLIDE_DOWN);
            System.println("Request Successful");
            Extensions.setPropertyAndStorageArr("zakupy", data["zakupy"]);
            Extensions.setPropertyAndStorage("pm25", data["airlypm25"] + "/" + data["ikeapm25"]);
            self.onAfterReceive.invoke();
        } else {
            Ui.popView(Ui.SLIDE_DOWN);
            System.println("Response: " + responseCode);
            self.onAfterReceive.invoke("Can't connect:" + responseCode + "\n" + Extensions.getPropertyOrStorage("pm25"));
        }        
    }
}

