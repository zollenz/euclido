package dk.myosis.euclido.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;
import flixel.system.FlxSound;
import dk.myosis.euclido.rhythm.RhythmManager;
import dk.myosis.euclido.rhythm.RhythmVisualizer;

class PlayState extends FlxState
{
	/////////////////////
    // Class variables //
    /////////////////////

	private var _counter:Int;
	private var _sound1:FlxSound;
	private var _sound2:FlxSound;
	private var _sound3:FlxSound;
	private var _sound4:FlxSound;
	private var _visualizer:RhythmVisualizer;
	private var _noteManager:RhythmManager;

	//////////////////////
    // Public functions //
    //////////////////////

	override public function create():Void
	{
		_counter = 0;
		_sound1 = FlxG.sound.load("assets/sounds/808_bd.wav", 1.0);
		_sound2 = FlxG.sound.load("assets/sounds/808_sd.wav", 1.0);		
		_sound3 = FlxG.sound.load("assets/sounds/808_cl_hh.wav", 1.0);
		_sound4 = FlxG.sound.load("assets/sounds/808_op_hh.wav", 1.0);
		FlxG.sound.volume = 1.0;
		_noteManager = new RhythmManager(4, 16);
		_visualizer = new RhythmVisualizer(_noteManager, 50.0, 8.0);
		add(_visualizer);
		super.create();
	}
	
	override public function destroy():Void
	{
		FlxDestroyUtil.destroy(_sound1);
		FlxDestroyUtil.destroy(_sound2);
		FlxDestroyUtil.destroy(_sound3);		
		FlxDestroyUtil.destroy(_sound4);
		_sound1 = null;
		_sound2 = null;
		_sound3 = null;		
		_sound4 = null;
		FlxDestroyUtil.destroy(_visualizer);
		_visualizer = null;
		super.destroy();
	}

	override public function update():Void
	{
		if (FlxG.keys.justPressed.D)
		{
			FlxG.debugger.visible = true;
		}

		if (_counter % 60 == 0 || _counter % 45 == 0) {
			_sound1.play(true);
			// trace("Play sound 1");
		}
		
		if (_counter % 120 == 0) {
			_sound2.play(true);
			// trace("Play sound 2");			
		}

		if (_counter % 15 == 0) {
			_sound3.play(true);
			// trace("Play sound 3");			
		}

		if (_counter % 120 == 0) {
			_sound4.play(true);
			// trace("Play sound 4");				
		}

		++_counter;
		super.update();
	}
}