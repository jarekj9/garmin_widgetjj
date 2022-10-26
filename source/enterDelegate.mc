using Toybox.WatchUi as Ui;
using Toybox.System;

class EnterDelegate extends Ui.BehaviorDelegate {

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onSelect() {
    System.println("onSelect behavior triggered");
    Ui.pushView( new OtherView(), null, 0);
    return true;
  }

}