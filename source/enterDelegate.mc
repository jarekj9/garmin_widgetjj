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
    if(view[0] instanceof OpenedView) {
        var openedView = view[0] as OpenedView;
        openedView.onButtonSelect.invoke();
        return true;
    }

    Ui.pushView( new OpenedView(), self, SLIDE_DOWN);
    
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
        var openedView = view[0] as OpenedView;
        openedView.onButtonUp.invoke();
    }

    if(keyEvent.getKey() == 8) {
        var view = Ui.getCurrentView();
        var openedView = view[0] as OpenedView;
        openedView.onButtonDown.invoke();
    }

    BehaviorDelegate.onKey(keyEvent);
    return true;
  }

}