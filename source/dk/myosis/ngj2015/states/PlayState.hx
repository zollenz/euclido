package dk.myosis.ngj2015.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.system.FlxSound;

import dk.myosis.ngj2015.entities.Visualizer;

class PlayState extends FlxState
{
	// Primitive vars
	private var _counter:Int;

	// Audio objects
	private var _sound1:FlxSound;
	private var _sound2:FlxSound;
	private var _sound3:FlxSound;
	private var _sound4:FlxSound;

	// Graphic objects
	private var _visualizer:Visualizer;

	override public function create():Void
	{
		// Init vars
		_counter = 0;

		// Init sound
		_sound1 = FlxG.sound.load("assets/sounds/808_bd.wav", 1.0);
		_sound2 = FlxG.sound.load("assets/sounds/808_sd.wav", 1.0);		
		_sound3 = FlxG.sound.load("assets/sounds/808_cl_hh.wav", 1.0);
		_sound4 = FlxG.sound.load("assets/sounds/808_op_hh.wav", 1.0);
		// Init grapbics
		_visualizer = new Visualizer();
		add(_visualizer);
		super.create();
	}
	
	override public function destroy():Void
	{
		// Destroy audio objects
		_sound1.destroy();
		_sound2.destroy();
		_sound3.destroy();		
		_sound4.destroy();
		_sound1 = null;
		_sound2 = null;
		_sound3 = null;		
		_sound4 = null;
		// Destroy graphic objects
		_visualizer.destroy();
		_visualizer = null;
		// Destroy me
		super.destroy();
	}

	override public function update():Void
	{
		if (_counter % 60 == 0 || _counter % 45 == 0) {
			_sound1.play(true);	
		}
		
		if (_counter % 120 == 0) {
			_sound2.play(true);	
		}

		if (_counter % 15 == 0) {
			_sound3.play(true);	
		}

		if (_counter % 120 == 0) {
			_sound4.play(true);	
		}

		++_counter;
		super.update();
	}
}