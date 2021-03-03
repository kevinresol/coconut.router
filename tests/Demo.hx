package ;

import js.Browser.*;

#if react_native
import coconut.router.ReactNavigation;
import react.native.api.*;
import react.native.component.*;
import react.navigation.native.NavigationContainer;
#else
import coconut.router.Browser;
import coconut.react.Renderer;
#end

class Demo {
	static function main() {
		#if react_native
		AppRegistry.registerComponent('App', () -> cast App);
		AppRegistry.runApplication('App', { rootTag: document.getElementById('app') });
		#else
		Renderer.mount(document.getElementById('app'), '<App/>');
		#end
	}
}

enum Route {
	Home;
	Settings(id:String);
}

class RouteTools {
	public static function urlToRoute(url:tink.Url):Route {
		return switch url.path.parts().toStringArray() {
			case ['settings', id]: Settings(id);
			case _: Home;
		}
	}
	
	public static function routeToUrl(route:Route):tink.Url {
		return switch route {
			case Home: '/';
			case Settings(id): '/settings/$id';
		}
	}
}

class App extends coconut.ui.View {
	#if react_native
	function render() '
		<NavigationContainer>
			<Router
				initialRoute=${Home}
				renderScreen=${renderScreen}
				getOptions=${getOptions}
			/>
		</NavigationContainer>
	';
	#else
	function render() '
		<Router
			renderScreen=${renderScreen}
			${...RouteTools}
		/>
	';
	#end
	
	function renderScreen(route:Route) '
		<switch ${route}>
			<case ${Home}>
				<HomeView/>
			<case ${Settings(id)}>
				<SettingsView id=${id}/>
		</switch>
	';
	
	function getOptions(route:Route) {
		return switch route {
			case Home: {headerTitle: 'Home'}
			case Settings(_): {headerTitle: 'Settings'}
		}
	}
}

// typedef RouteHistory = History<Route>;
typedef RouteHistory = History;

class HomeView extends coconut.ui.View {
	// @:implicit var history:RouteHistory;
	
	#if react_native
	function render() '
		<View>
			<Text>Home</Text>
			<Button onPress=${() -> history.push(Settings('foo'))} title="Settings"/>
		</View>
	';
	#else
	function render() '
		<div ref=${Router.intercept}>
			<div>Home</div>
			<a href=${RouteTools.routeToUrl(Settings('foo'))}>Settings</a>
		</div>
	';
	#end
}

class SettingsView extends coconut.ui.View {
	@:implicit var history:RouteHistory;
	@:attr var id:String;
	
	#if react_native
	function render() '
		<Text>Settings: $id</Text>
	';
	#else
	function render() '
		<div>Settings: $id</div>
	';
	#end
}