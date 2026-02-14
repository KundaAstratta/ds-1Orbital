import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class ds_1OrbitalApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new ds_1OrbitalView() ];
    }

}

function getApp() as ds_1OrbitalApp {
    return Application.getApp() as ds_1OrbitalApp;
}