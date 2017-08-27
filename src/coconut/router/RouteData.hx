package coconut.router;


import coconut.data.Model;
import coconut.ui.View;
import coconut.ui.RenderResult;
import tink.state.*;

class RouteData implements Model {
	@:external var path:String;
}

#if (js && !nodejs) 
abstract BrowserPath(Observable<String>) to Observable<String> {
	public function new(noMonkeyPatch = false) {
		if(!noMonkeyPatch) {
			var window = js.Browser.window;
			
			// polyfill Event on IE
			untyped __js__('(function () {

				if ( typeof window.CustomEvent === "function" ) return false;

				function CustomEvent ( event, params ) {
					params = params || { bubbles: false, cancelable: false, detail: undefined };
					var evt = document.createEvent( "CustomEvent" );
					evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
					return evt;
				}

				CustomEvent.prototype = window.Event.prototype;

				window.CustomEvent = CustomEvent;
			})();');
			
			var oldPushState = window.history.pushState;
			untyped window.history.pushState = function(data, title, ?url) {
				oldPushState(data, title, url);
				window.dispatchEvent(new js.html.CustomEvent('popstate'));
			}
			var window = js.Browser.window;
			var oldReplaceState = window.history.replaceState;
			untyped window.history.replaceState = function(data, title, ?url) {
				oldReplaceState(data, title, url);
				window.dispatchEvent(new js.html.CustomEvent('popstate'));
			}
		}
		
		var state = new State(getCurrent());
		js.Browser.window.addEventListener('popstate', function() state.set(getCurrent()));
		this = state.observe();
	}
	
	static function getCurrent() {
		var location = js.Browser.window.location;
		return location.pathname + location.search + location.hash;
	}
}
#end
