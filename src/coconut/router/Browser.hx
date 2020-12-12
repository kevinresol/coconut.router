package coconut.router;

import js.Browser.*;
import tink.Url;
import spectatory.Location;
import coconut.ui.*;

@:default(null) // will rely on Implicit#defaults
class History<T:EnumValue> {
	final urlToRoute:Url->T;
	final routeToUrl:T->Url;
	
	public function new(l2r, r2l) {
		urlToRoute = l2r;
		routeToUrl = r2l;
	}
	
	public function push(route:T) {
		Location.push(routeToUrl(route));
		window.scroll({top: 0});
	}
	
	public function replace(route:T) {
		Location.replace(routeToUrl(route));
		window.scroll({top: 0});
	}
	
	public inline function back() {
		Location.back();
	}
}

class Router<T:EnumValue> extends View {
	@:attr var renderScreen:T->RenderResult;
	@:attr var urlToRoute:Url->T;
	@:attr var routeToUrl:T->Url;
	@:computed var current:T = urlToRoute(Location.href.value);
	
	function render() '
		<Implicit defaults=${[History => new History(urlToRoute, routeToUrl)]}>
			${renderScreen(current)}
		</Implicit>
	';
}