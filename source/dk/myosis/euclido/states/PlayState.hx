package dk.myosis.euclido.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxGame;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import dk.myosis.euclido.rhythm.RhythmManager;
import dk.myosis.euclido.rhythm.RhythmVisualizer;

class PlayState extends FlxState
{
	/////////////////////
    // Class variables //
    /////////////////////

	private var _visualizer:RhythmVisualizer;
	private var _manager:RhythmManager;

	//////////////////////
    // Public functions //
    //////////////////////

	override public function create():Void
	{
		_manager = new RhythmManager(4, 100, 4);
		_visualizer = new RhythmVisualizer(_manager, 50.0, 8.0);
		add(_manager);
		add(_visualizer);		
        super.create();
    }
	
	override public function destroy():Void
	{
		FlxDestroyUtil.destroy(_manager);
		_manager = null;
		FlxDestroyUtil.destroy(_visualizer);
		_visualizer = null;
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}
}
