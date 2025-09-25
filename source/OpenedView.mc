import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class OpenedView extends WatchUi.View {

    var itemsString as String;
    var choiceText as String;
    var onButtonDown = self.method(:onButtonDownAction);
    var onButtonUp = self.method(:onButtonUpAction);
    var onButtonSelect = self.method(:onButtonSelectAction);
    var itemsArray = [];
    var currentChoicePosition = -1;

    function initialize() {
        View.initialize();
        self.itemsString = "";
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
        if (self.itemsString != null) {
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
            posY = writer.writeLines(dc, self.itemsString, Gfx.FONT_TINY, posY);
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_WHITE);
            dc.drawText(130, 10, Gfx.FONT_TINY , self.choiceText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(130, 216, Gfx.FONT_TINY , "press to del", Graphics.TEXT_JUSTIFY_CENTER);
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
        if(self.currentChoicePosition == -1) {
            return;
        }
        if(self.currentChoicePosition > 0) {
            self.currentChoicePosition--;
        }
        self.choiceText = itemsArray[self.currentChoicePosition].values()[0];
        Ui.requestUpdate();
    }

    function onButtonSelectAction() as Void {
        if (self.currentChoicePosition == -1) {
            return;
        }
        var request = new HttpRequest(self.method(:onDeleteRespReceived));
        var deletedId = self.itemsArray[self.currentChoicePosition].keys()[0];
        request.makeDeleteRequest(deletedId);
        self.onRespReceived();
    }

    function onHide() as Void {
    }

    function onRespReceived() as Void {
        var zakupyArray  = Extensions.getPropertyOrStorageArr("zakupy");
        self.itemsString = Extensions.arrayToString(zakupyArray, ", ");
        itemsArray = zakupyArray;
        Ui.requestUpdate();
    }

    function onDeleteRespReceived(deletedId as String) as Void {
        for (var i = 0; i < self.itemsArray.size(); i++) {
            if (self.itemsArray[i] != null) {
                var key = self.itemsArray[i].keys()[0];
                if (key.equals(deletedId)) {
                    self.itemsArray.remove(self.itemsArray[i]);
                    self.itemsString = Extensions.arrayToString(self.itemsArray, ", ");
                    if(self.currentChoicePosition == self.itemsArray.size()) {
                        self.currentChoicePosition--;
                    }
                    if(self.currentChoicePosition == -1) {
                        self.choiceText = "--empty--";
                        break;
                    }
                    self.choiceText = itemsArray[self.currentChoicePosition].values()[0];
                    break;
                }
            }
        }
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
        var app = Application.getApp();
        var url = app.getProperty("url"); //"https://garmin.y4r3k.duckdns.org/garmininfo";

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

    function makeDeleteRequest(deletedId as String) as Void {
        Ui.pushView( new LoadingView(), null, Ui.SLIDE_DOWN);
        var app = Application.getApp();
        var url = app.getProperty("url"); //"https://garmin.y4r3k.duckdns.org/garmininfo";
        
        var data = {
            "id" => deletedId
        };
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Authorization" => app.getProperty("apikey"),
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        var responseCallback = self.method(:onDeleteReceive);
        Communications.makeWebRequest(url, data, options, responseCallback);
    }

    function onDeleteReceive(responseCode as Number, data as Null or Dictionary or String) as Void {
        if (responseCode == 200) {
            Ui.popView(Ui.SLIDE_DOWN);
            System.println("Deleted" + data["id"]);

            self.onAfterReceive.invoke(data["id"]);
        } else {
            Ui.popView(Ui.SLIDE_DOWN);
            System.println("Response: " + responseCode);
        }        
    }
}

