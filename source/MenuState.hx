package;

// Lime imports
import lime.audio.openal.AL;
import lime.audio.AudioManager;
import lime.audio.AudioSource;
import lime.audio.AudioBuffer;
// import lime.utils.ByteArray;
// OpenFL imports
// Flixel imports
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.system.FlxSound;

class MenuState extends FlxState
{
	var _sampleRate:Int;
	var _audioData:lime.utils.ByteArray; 
	var _audioData2:openfl.utils.ByteArray;	
	var _buffer:Int;
	var _frequency:Float;
	var _source:Int;
	var _audioSource:AudioSource;
	var _audioBuffer:AudioBuffer;
	private var _kickSound:FlxSound;
	private var _snareSound:FlxSound;	
	private var _hihatSound:FlxSound;	
	private var counter:Int;

	override public function create():Void
	{
		counter = 0;

		// Flixel audio API calls
		_kickSound = FlxG.sound.load("assets/sounds/808_bd.wav", 1.0);
		_snareSound = FlxG.sound.load("assets/sounds/808_sd.wav", 1.0);		
		_hihatSound = FlxG.sound.load("assets/sounds/808_cl_hh.wav", 1.0);		
		add(new FlxText(0, 0, 100, "Hello World!"));

		// Lime audio API calls
		AudioManager.init();		
		_audioSource = new AudioSource();
		_sampleRate = 44100;
		_frequency = 440;
		_buffer = AL.genBuffer();
		_source = AL.genSource();
		var frames:Int = _sampleRate;
		_audioData = new lime.utils.ByteArray(frames);
		// _audioData2 = new openfl.utils.ByteArray(frames);

		for(i in 0...frames) 
		{
	    	_audioData.writeShort(Std.int(32767 * Math.sin((2 * Math.PI * _frequency) / _sampleRate * i)));
	    	// _audioData2.writeShort(Std.int(32767 * Math.sin((2 * Math.PI * _frequency) / _sampleRate * i)));
	    	//trace(_audioData[i]);
	    }

	    // _audioBuffer = AudioBuffer.fromBytes(_audioData);

		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		if (counter % 60 == 0 || counter % 45 == 0) {
			_kickSound.play(true);	
		}
		
		if (counter % 120 == 0) {
			_snareSound.play(true);	
		}

		if (counter % 15 == 0) {
			_hihatSound.play(true);	
		}

		++counter;
		super.update();
	}

	public function play():Void
	{
		trace("PLAY!");
		// var sound = new FlxSound();
		// sound.loadByteArray(_audioData2);
		// sound.play();
		AL.bufferData(_buffer, AL.FORMAT_MONO16, _audioData, _audioData.length * 2, _sampleRate);
		AL.sourcei(_source, AL.BUFFER, _buffer);
		AL.sourcePlay(_source);
	}	
}