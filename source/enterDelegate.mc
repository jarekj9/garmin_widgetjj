using Toybox.WatchUi as Ui;
using Toybox.System;

class EnterDelegate extends Ui.BehaviorDelegate {

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onSelect() {
    System.println("onSelect behavior triggered");
    Ui.pushView( new OtherView(), self, SLIDE_DOWN);

    BehaviorDelegate.onSelect();
    return true;
  }

  function onKey(keyEvent) {
    // DOWN = 8, UP = 13
    if(keyEvent.getKey() == 5) {
        Ui.popView(Ui.SLIDE_DOWN);
    }

    BehaviorDelegate.onKey(keyEvent);
    return true;
  }

}