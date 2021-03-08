package coconut.router;

import js.html.*;
import js.Browser.*;
import tink.Anon.merge;
import tink.domspec.ClassName;
import tink.domspec.Style;
import tink.Url;
import spectatory.Location;
import coconut.ui.*;

using tink.CoreApi;

@:default(coconut.router.Browser.History.INST)
class History {
	public static final INST = new History();
	
	function new() {}
	
	public function push(url:Url) {
		Location.push(resolve(url));
		window.scroll({top: 0});
	}
	
	public function replace(url:Url) {
		Location.replace(resolve(url));
		window.scroll({top: 0});
	}
	
	public inline function back() {
		Location.back();
	}
	
	function resolve(url:Url) {
		return (window.location.href:Url).resolve(url);
	}
}

class Router<T:EnumValue> extends View {
	@:attr var renderScreen:T->RenderResult;
	@:attr var urlToRoute:Url->T;
	@:attr function isExternalLink(href:String):Bool return href.indexOf('//') >= 0;
	@:computed var current:T = urlToRoute(Location.href.value);
	
	function render() '
		<div onclick=${onClick}>
			${renderScreen(current)}
		</div>
	';
	
	function onClick(e:MouseEvent) {
		switch (cast e.target:Element).closest('a') {
			case null:
			case anchor:
				if(!e.defaultPrevented && e.button == 0 && isTargetingSelf(anchor.getAttribute('target')) && !isModifiedEvent(e)) {
					e.preventDefault();
					switch anchor.getAttribute('href') {
						case null:
						case href:
							if(!isExternalLink(href)) History.INST.push(href);
					}
				}
		}
	}
	
	static function isTargetingSelf(target:String) {
		return target == null || target == 'self';
	}
	
	static inline function isModifiedEvent(event) {
		return event.metaKey || event.altKey || event.ctrlKey || event.shiftKey;
	}
}
