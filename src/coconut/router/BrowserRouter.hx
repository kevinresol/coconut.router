package coconut.router;

import js.html.*;
import spectatory.Location;
import tink.Url;

class BrowserRouter<T:EnumValue> implements coconut.data.Model {
	@:constant var locationToRoute:Url->T;
	@:constant var routeToLocation:T->Url;
	@:computed var route:T = locationToRoute(Location.href.value);
	@:constant var isExternalLink:String->Bool = @byDefault function(href:String) return href.indexOf('//') >= 0;
	
	public function back()
		Location.back();
	
	public function push(route:T)
		Location.push(routeToLocation(route));
	
	public function replace(route:T)
		Location.replace(routeToLocation(route));
		
	public function intercept(element:Element) {
		element.addEventListener('click', listener);
	}
	
	function pushUrl(url:String)
		Location.push(url);
		
	function listener(event:Event) {
		switch (cast event.target:Element).closest('a') {
			case null:
			case anchor: 
				switch anchor.getAttribute('href') {
					case null: // do nothing
					case href if(isExternalLink(href)): // let browser handle
					case href:
						event.preventDefault();
						// assume the href is a valid route for Router<T> ?
						pushUrl(href);
				}
		}
	}
}