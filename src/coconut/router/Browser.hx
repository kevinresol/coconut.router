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
	@:computed var current:T = urlToRoute(Location.href.value);
	
	function render() '
		<div ref=${intercept}>
			${renderScreen(current)}
		</div>
	';
	
	public static function intercept(container:Element) {
		if(container != null)
			container.addEventListener('click', onClick);
	}
	
	static function onClick(e:MouseEvent) {
		switch (cast e.target:Element).closest('a') {
			case null:
			case anchor:
				if(!e.defaultPrevented && e.button == 0 && isTargetingSelf(anchor.getAttribute('target')) && !isModifiedEvent(e)) {
					e.preventDefault();
					navigate(anchor.getAttribute('href'));
				}
		}
	}
	
	// ported from https://github.com/ReactTraining/react-router/blob/be6a22f8c5a0d19011e42ed444ba77e0d4432f87/packages/react-router-dom/modules/Link.js#L35-L53
	// function onclick(e:MouseEvent) {
	// 	try switch onClick {
	// 		case null:
	// 		case cb: cb.invoke(e);
	// 	} catch(ex) {
	// 		e.preventDefault();
	// 		throw ex;
	// 	}
		
	// 	if(!e.defaultPrevented && e.button == 0 && isTargetingSelf(target) && !isModifiedEvent(e)) {
	// 		e.preventDefault();
	// 		navigate();
	// 	}
	// }
	
	static inline function navigate(href:String) {
		switch href {
			case null:
			case url:
				History.INST.push(url);
		}
	}
	
	static function isTargetingSelf(target:String) {
		return target == null || target == 'self';
	}
	
	static inline function isModifiedEvent(event) {
		return event.metaKey || event.altKey || event.ctrlKey || event.shiftKey;
	}
}
