using Toybox.WatchUi as Ui;
using Toybox.System;

class EnterDelegate extends Ui.BehaviorDelegate {

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onSelect() {
    System.println("onSelect behavior triggered");
    Ui.pushView( new OtherView(), self, 0);
    return true;
  }

  function onKey(keyEvent) {
    // DOWN = 8, UP = 13
    if(keyEvent.getKey() == 8) {
      return true;
    }

    return true;
  }

}