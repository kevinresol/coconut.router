package coconut.router;

class Dom {
	
	#if js_virtual_dom
	public static function link(attr:vdom.VDom.AnchorAttr, ?children) {
		untyped {
			var original = attr.onclick;
			attr.onclick = function(e) {
				onclick(e);
				if(original != null) original(e);
			}
		}
		return vdom.VDom.a(attr, children);
	}
	#end
	
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