package coconut.router;

import spectatory.Location;
import tink.Url;

class BrowserRouter<T:EnumValue> implements coconut.data.Model {
	@:constant var locationToRoute:Url->T;
	@:constant var routeToLocation:T->Url;
	@:computed var route:T = locationToRoute(Location.href.value);
	
	public function back()
		Location.back();
	
	public function push(route:T)
		Location.push(routeToLocation(route));
	
	public function replace(route:T)
		Location.replace(routeToLocation(route));
	
	function pushUrl(url:String)
		Location.push(url);
}