# Router for Coconut

## Router Model

`coconut.router.BrowserRouter<T>` 

The router model is responsible for observing the browser address bar and
map it into a Route enum defined by user.

Use `back()`, `push(route)` and `replace(route)` to manipulate the browser history.


## Example Usage

Add `ref={router.intercept}` to the very root element in your render tree.  
This will intercept all clicks on `<a>` elements and update the model accordingly.

```haxe
import js.Browser.*;
import coconut.Ui.hxx;

class RunTests {

	static function main() {
		var router = new coconut.router.BrowserRouter({
			routeToUrl: function(route) {
				return switch route {
					case HomePage: '/';
					case OtherPage: '/other';
					case UnknownPage(v): v;
				}
			},
			urlToRoute: function(url) {
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
			<NavBar/>
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
			This is Home Page.
		</div>
	';
}

class Other extends coconut.ui.View {
	function render() '
		<div>
			This is Other Page.
		</div>
	';
}

class Unknown extends coconut.ui.View {
	@:attr var path:String;
	function render() '
		<div>
			Page not found: ${path}
		</div>
	';
}
```