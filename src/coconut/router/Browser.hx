package coconut.router;

import js.Browser.*;
import tink.Url;
import spectatory.Location;
import coconut.ui.*;

@:default(null) // will rely on Implicit#defaults
class History<T:EnumValue> {
	final locationToRoute:Url->T;
	final routeToLocation:T->Url;
	
	public function new(l2r, r2l) {
		locationToRoute = l2r;
		routeToLocation = r2l;
	}
	
	public function push(route:T) {
		Location.push(routeToLocation(route));
		window.scroll({top: 0});
	}
	
	public function replace(route:T) {
		Location.replace(routeToLocation(route));
		window.scroll({top: 0});
	}
	
	public inline function back() {
		Location.back();
	}
}

class Router<T:EnumValue> extends coconut.ui.View {
	@:attr var renderScreen:T->RenderResult;
	@:attr var locationToRoute:Url->T;
	@:attr var routeToLocation:T->Url;
	@:computed var current:T = locationToRoute(Location.href.value);
	
	function render() '
		<Implicit defaults=${[History => new History(locationToRoute, routeToLocation)]}>
			${renderScreen(current)}
		</Implicit>
	';
}