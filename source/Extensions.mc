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

    function setPropertyAndStorageArr(key as String, value as Array) as Void {
        var app = Application.getApp();
        app.setProperty(key, value);
        Storage.setValue(key, value);
    }

    function getPropertyOrStorageArr(key as String) as Array {
        try {
            var app = Application.getApp();
            var value = app.getProperty(key);
            if(value != null) {
                return value;
            }
            var storageValue = Storage.getValue(key);
            if(storageValue != null) {
                return storageValue;
            }
            return [];
        }
        catch (e) {
            return [];
        }
    }
    function stringToArray(string as String, separator  as String) as Array {
        var maxLen = 300; // Use maximum expected length
        var array = new [maxLen/10];  
        string = string.substring(0, maxLen);
        var index = 0;
        var location;
        do
        {
            location = string.find(separator);
            if (location != null) {
                array[index] = string.substring(0, location);
                string = string.substring(location + 1, string.length());
                index++;
            }
        }
        while (location != null); 
        array[index] = string;
       return array;
    }

    function arrayToString(array as Array, separator as String) as String {
        var string = "";    // array like: [{'08db9ca7-c904-41c0-868a-b8c3645fb65b' : 'Wspornik 40cm'}, ...]
        for (var i = 0; i < array.size(); i++) {
            if (array[i] != null) {
                var value = array[i].values()[0];
                string += value;
                if (i < array.size() - 1) {
                    string += separator;
                }
            }
        }
        return string;
    }
}
