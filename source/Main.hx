package;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;

class Main extends Sprite 
{
	private var _gameWidth:Int = 1024; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	private var _gameHeight:Int = 768; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	private var _initialState:Class<FlxState> = PlayState; // The FlxState the game starts with.
	private var _zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	private var _framerate:Int = 60; // How many frames per second the game should run at.
	private var _skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	private var _startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	
	public static function main():Void
	{	
		Lib.current.addChild(new Main());
	}
	
	public function new() 
	{
		super();
		
		if (stage != null) 
		{
			init();
		}
		else 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	private function init(?E:Event):Void 
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		setupGame();
	}
	
	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (_zoom == -1)
		{
			var ratioX:Float = stageWidth / _gameWidth;
			var ratioY:Float = stageHeight / _gameHeight;
			_zoom = Math.min(ratioX, ratioY);
			_gameWidth = Math.ceil(stageWidth / _zoom);
			_gameHeight = Math.ceil(stageHeight / _zoom);
		}

		addChild(new FlxGame(_gameWidth, _gameHeight, _initialState, _zoom, _framerate, _framerate, _skipSplash, _startFullscreen));
	}
}