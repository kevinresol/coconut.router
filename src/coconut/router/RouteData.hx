package coconut.router;


import coconut.data.Model;
import coconut.ui.View;
import coconut.ui.RenderResult;
import tink.state.*;
import tink.Url;

class RouteData implements Model {
	@:external var url:Url;
	
	#if (js && !nodejs) 
	public static inline function create(noMonkeyPatch = false)
		return new RouteData({url: new BrowserPath(noMonkeyPatch)});
	
	public static function link(attr:vdom.VDom.AnchorAttr, ?children) {
		untyped attr.onclick = onclick;
		return vdom.VDom.a(attr, children);
	}
	
	function onclick(e:js.html.MouseEvent) {
		var elem:js.html.AnchorElement = cast e.currentTarget;
		switch elem.getAttribute('href') {
			case null: // do nothing
			case href if(href.indexOf('//') >= 0): // do nothing, let browser handle
			case href:
				e.preventDefault();
				js.Browser.window.history.pushState(null, null, href);
		}
	};
	#end
}

#if (js && !nodejs) 
abstract BrowserPath(Observable<Url>) to Observable<Url> {
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
	
	static function getCurrent():Url {
		return js.Browser.window.location.href;
	}
}
#end
