package coconut.router;


import coconut.data.Model;
import coconut.ui.View;
import coconut.ui.RenderResult;
import tink.Url;

typedef Provider = {
	function route(url:Url):RenderResult;
	function getCurrent():String;
}

class RouteData implements Model {
	@:constant var provider:Provider;
	@:editable var url:String = @byDefault provider.getCurrent();
	@:computed var node:RenderResult = provider.route(url);
	
	public function register(noMonkeyPatch = false) {
		#if (js && !nodejs) 
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
		js.Browser.window.addEventListener('popstate', function() url = js.Browser.window.location.href);
		#end
	}
		
}

typedef Router = 
	#if (js && !nodejs) BrowserRouter
	#end ;

#if (js && !nodejs)
class BrowserProvider {
	public function new() {}
	
	public function getCurrent():String
		return js.Browser.window.location.href;
		
	public function route(url:tink.Url):RenderResult
		throw 'abstract';
}

class BrowserRouter extends View<{data:RouteData}> {
	
	function render() return data.node;
	
	public static function link(attr:vdom.VDom.AnchorAttr, ?children) {
		untyped attr.onclick = onclick;
		return vdom.VDom.a(attr, children);
	}
		
	static function onclick(e:js.html.MouseEvent) {
		var elem:js.html.AnchorElement = cast e.currentTarget;
		switch elem.getAttribute('href') {
			case null: // do nothing
			case href if(href.indexOf('//') >= 0): // do nothing, let browser handle
			case href:
				e.preventDefault();
				js.Browser.window.history.pushState(null, null, href);
		}
	}
}
#end