package coconut.router;


import coconut.data.Model;
import coconut.ui.View;
import coconut.ui.RenderResult;
import tink.Url;

typedef Provider = {
	function route(url:Url):RenderResult;
	function getCurrent():String;
}

class BrowserProvider {
	public function new() {}
	
	public function getCurrent():String
		return js.Browser.window.location.href;
		
	public function route(url:tink.Url):RenderResult
		throw 'abstract';
}

class RouteData implements Model {
	@:constant var provider:Provider;
	@:editable var url:String = @byDefault provider.getCurrent();
	@:computed var node:RenderResult = provider.route(url);
}

class BrowserRouter extends View<{data:RouteData}> {
	
	function render() '
		<div onclick=${onclick.bind(data)}>
			${data.node}
		</div>
	';
	
	function onclick(data:RouteData, e:js.html.MouseEvent) {
		switch (cast e.target).localName {
			case 'a':
				e.preventDefault();
				switch (cast e.target).href {
					case null | '': // do nothing
					case href:
						data.url = href;
						js.Browser.window.history.pushState(null, null, href);
				}
			default: // do nothing
		}
	}
}