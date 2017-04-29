package ;

import js.Browser.*;
import vdom.VDom.*;
import coconut.Ui.hxx;
import coconut.router.Router;

class RunTests {

	static function main() {
		
		var data = new RouteData({
			provider: new MyProvider(),
		});
		
		window.addEventListener('popstate', function() data.url = window.location.href);
		document.body.appendChild(hxx('<Router data=${data}/>').toElement());
	}
}

class MyProvider extends BrowserProvider {
	override function route(url:tink.Url) {
		return switch url.path.toString() {
			case '/':
				hxx('<Home/>');
			case '/next':
				hxx('<div><a>Hello</a> <a href="/other">World</a></div>');
			case v:
				hxx('<Other url=${url.toString()}/>');
		}
	}
}

class Home extends coconut.ui.View<{}> {
	function render() '
		<div>
			This is Home Page. <a href="next?123">Go to next page</a> <a>No href</a>
		</div>
	';
}

class Other extends coconut.ui.View<{url:String}> {
	function render() '
		<a href="//google.com">${url}</a>
	';
}
