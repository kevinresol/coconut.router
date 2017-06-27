package ;

import js.Browser.*;
import vdom.VDom.*;
import coconut.Ui.hxx;
import coconut.router.Router;
import coconut.router.Router.*;

class RunTests {

	static function main() {
		
		var data = new RouteData({
			provider: new MyProvider(),
		});
		
		data.register();
		
		document.body.appendChild(hxx('<Router data=${data}/>').toElement());
	}
}

class MyProvider extends BrowserProvider {
	override function route(url:tink.Url) {
		return switch url.path.toString() {
			case '/':
				hxx('<Home/>');
			case '/next':
				hxx('<div><link>Hello</link> <link href="/other">World</link></div>');
			case v:
				hxx('<Other url=${url.toString()}/>');
		}
	}
}

class Home extends coconut.ui.View<{}> {
	function render() '
		<div>
			This is Home Page. <link href="next?123">Go to next page</link> <link>No href</link>
		</div>
	';
}

class Other extends coconut.ui.View<{url:String}> {
	function render() '
		<a href="//google.com">${url}</a>
	';
}
