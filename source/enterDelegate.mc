using Toybox.WatchUi as Ui;
using Toybox.System;
import Toybox.WatchUi;

class EnterDelegate extends Ui.BehaviorDelegate {
  
  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onSelect() {
    System.println("onSelect behavior triggered");
    var view = Ui.getCurrentView();
    if(view[0] instanceof OtherView) {
        var otherView = view[0] as OtherView;
        otherView.onButtonSelect.invoke();
        return true;
    }

    Ui.pushView( new OtherView(), self, SLIDE_DOWN);
    
    BehaviorDelegate.onSelect();
    return true;
  }

  function onKey(keyEvent) {
    // DOWN = 8, UP = 13
    if(keyEvent.getKey() == 5) {
        Ui.popView(Ui.SLIDE_DOWN);
    }

    if(keyEvent.getKey() == 13) {
        var view = Ui.getCurrentView();
        var otherView = view[0] as OtherView;
        otherView.onButtonUp.invoke();
    }

    if(keyEvent.getKey() == 8) {
        var view = Ui.getCurrentView();
        var otherView = view[0] as OtherView;
        otherView.onButtonDown.invoke();
    }

    BehaviorDelegate.onKey(keyEvent);
    return true;
  }

}