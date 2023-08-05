import Toybox.System;
import Toybox.Lang;
using Toybox.Application.Storage;

class Extensions {

    function setPropertyAndStorage(key as String, value as String) as Void {
        var app = Application.getApp();
        app.setProperty(key, value);
        Storage.setValue(key, value);
    }

    function getPropertyOrStorage(key as String) as String {
        var app = Application.getApp();
        var value = app.getProperty(key);
        if(!value.equals("")) {
            return value;
        }
        return Storage.getValue(key);
    }

}
