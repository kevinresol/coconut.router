# Router for Coconut

## Router Model

`coconut.router.BrowserRouter<T>` 

The router model is responsible for observing the browser address bar and
map it into a Route enum defined by user.

Use `back()`, `push(route)` and `replace(route)` to manipulate the browser history.


## Example Usage

```haxe
package ;

import js.Browser.*;
import coconut.Ui.hxx;

class RunTests {

	static function main() {
		var router = new coconut.router.BrowserRouter({
			routeToLocation: function(route) {
				return switch route {
					case HomePage: '/';
					case OtherPage: '/other';
					case UnknownPage(v): v;
				}
			},
			locationToRoute: function(url) {
				return switch url.path.parts().toStringArray() {
					case []: HomePage;
					case ['other']: OtherPage;
					case _: UnknownPage(url.path.toString());
				}
			},
		});
		
		coconut.ui.Renderer.mount(document.body, hxx('<App router=${router}/>'));
	}
}

enum Route {
	HomePage;
	OtherPage;
	UnknownPage(path:String);
}

class App extends coconut.ui.View {
	@:attr var router:coconut.router.BrowserRouter<Route>;
	
	function render() '
		<div ref=${router.intercept}>
			<switch ${router.route}>
				<case ${HomePage}><Home/>
				<case ${OtherPage}><Other/>
				<case ${UnknownPage(v)}><Unknown path=${v}/>
			</switch>
		</div>
	';
}

class NavBar extends coconut.ui.View {
	function render() '
		<div>
			<a href="/">Home</a> | <a href="/other">Other</a> | <a href="/unknown">Unknown</a> | <a href="https://www.example.com">example.com</a>
		</div>
	';
}

class Home extends coconut.ui.View {
	function render() '
		<div>
			<NavBar/>
			This is Home Page.
		</div>
	';
}

class Other extends coconut.ui.View {
	function render() '
		<div>
			<NavBar/>
			This is Other Page.
		</div>
	';
}

class Unknown extends coconut.ui.View {
	@:attr var path:String;
	function render() '
		<div>
			<NavBar/>
			Page not found: ${path}
		</div>
	';
}

```