package coconut.router.ui;

import js.html.*;
import spectatory.Location;

@:access(coconut.router.BrowserRouter)
class BrowserRouter<T:EnumValue> extends coconut.ui.View {
	
	@:attr var router:coconut.router.BrowserRouter<T>;
	@:attr var children:coconut.ui.RenderResult;
	
	function render() return children;
	
	// #if coconut_vdom
	override function afterInit(element:Element) {
		element.addEventListener('click', listener);
	}
	
	override function beforeDestroy(element:Element) {
		element.removeEventListener('click', listener);
	}
	
	function listener(event:Event) {
		switch (cast event.target:Element).closest('a') {
			case null:
			case anchor: 
				switch anchor.getAttribute('href') {
					case null: // do nothing
					case href if(href.indexOf('//') >= 0): // let's assume this is an external link, let browser handle
					case href:
						event.preventDefault();
						// assume the href is a valid route for Router<T> ?
						router.pushUrl(href);
				}
		}
	}
	// #end
}