// Copyright 2017 by HarryOnline
// https://creativecommons.org/licenses/by/4.0/
//
// Show loading... screen

using Toybox.WatchUi as Ui;

class LoadingView extends Ui.ProgressBar {

  function initialize() {
    ProgressBar.initialize("Connecting...", null );
  }
}
