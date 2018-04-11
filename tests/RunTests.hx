package ;

import js.Browser.*;
import coconut.Ui.hxx;
import coconut.router.ui.BrowserRouter as Router;

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
		
		document.body.appendChild(hxx('<App router=${router}/>').toElement());
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
		<Router router=${router}>
			<switch ${router.route}>
				<case ${HomePage}><Home/>
				<case ${OtherPage}><Other/>
				<case ${UnknownPage(v)}><Unknown path=${v}/>
			</switch>
		</Router>
	';
}

class NavBar extends coconut.ui.View {
	function render() '
		<div>
			<a href="/">Home</a> | <a href="/other">Other</a> | <a href="/unknown">Unknown</a>
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
