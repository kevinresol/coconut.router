package coconut.router;

import coconut.react.*;
import react.navigation.*;
import react.navigation.stack.*;
import react.navigation.native.*;
 
@:default(null) // will rely on Implicit#defaults
class History<T:EnumValue> {
	final navigation:Navigation<T>;
	
	public function new(navigation) {
		this.navigation = navigation;
	}
	
	public inline function push(route:T):Void {
		navigation.push('Wrapper', route);
	}
	
	public inline function pop():Void {
		navigation.pop();
	}
	
	public inline function popToTop():Void {
		navigation.popToTop();
	}
}

class Router<T> extends View {
	final Native = Navigator.create();
	
	@:attr var initialRoute:T;
	@:attr var renderScreen:T->RenderResult;
	@:attr var getOptions:T->ScreenOptions;
	
	
	function render() '
		<Native.Navigator>
			<Native.Screen
				name="Wrapper"
				initialParams=${initialRoute}
				component=${(props:BaseProps<T>) -> props.route.params == null ? null : (<Screen>${renderScreen(props.route.params)}</Screen>)}
				options=${(props:BaseProps<T>) -> props.route.params == null ? null : getOptions(props.route.params)}
			/>
		</Native.Navigator>
	';
}

private class Screen extends View {
	@:keep
	static final contextType = NavigationContext;
	
	@:attr var children:RenderResult;
	
	var context:Dynamic;
	
	function render() '
		<Implicit defaults=${[History => new History(context)]}>
			${children}
		</Implicit>
	';
}
