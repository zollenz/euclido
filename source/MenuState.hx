package;

// Lime imports
import lime.audio.openal.AL;
import lime.audio.openal.ALC;
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
	// Lime audio vars
	var _audioSource:AudioSource;
	var _audioBuffer:AudioBuffer;
	var _sampleRate:Int;
	var _audioData:lime.utils.ByteArray; 
	var _audioData2:openfl.utils.ByteArray;	
	var _buffer:Int;
	var _frequency:Float;
	var _source:Int;
	private var _sound1:FlxSound;
	private var _sound2:FlxSound;
	private var _sound3:FlxSound;
	private var _sound4:FlxSound;	
	private var counter:Int;

	override public function create():Void
	{
		counter = 0;

		// Flixel audio API calls
		_sound1 = FlxG.sound.load("assets/sounds/808_bd.wav", 1.0);
		_sound2 = FlxG.sound.load("assets/sounds/808_sd.wav", 1.0);		
		_sound3 = FlxG.sound.load("assets/sounds/808_cl_hh.wav", 1.0);
		_sound4 = FlxG.sound.load("assets/sounds/808_op_hh.wav", 1.0);		
		add(new FlxText(0, 0, 100, "Hello World!"));

		// Lime audio API calls
		// AudioManager.init();		
		// _audioSource = new AudioSource();
		// var device = ALC.openDevice ();
		// var ctx = ALC.createContext (device);
		// ALC.makeContextCurrent (ctx);
		// ALC.processContext (ctx);

		// _sampleRate = 44100;
		// _frequency = 440;
		// _buffer = AL.genBuffer();
		// _source = AL.genSource();
		// var frames:Int = _sampleRate;
		// _audioData = new lime.utils.ByteArray(frames);
		// _audioData2 = new openfl.utils.ByteArray(frames);

		// for(i in 0...frames) 
		// {
		// 	var value = Math.sin((2 * Math.PI * _frequency) / _sampleRate * i);
		// 	// trace(value);
		// 	var value2 = value * 32767;
		// 	// trace(value2);
		// 	trace(Std.int(value2));
	 //    	_audioData.writeShort(Std.int(32767 * Math.sin((2 * Math.PI * _frequency) / _sampleRate * i)));
	 //    	// _audioData2.writeShort(Std.int(32767 * Math.sin((2 * Math.PI * _frequency) / _sampleRate * i)));
	 //    	trace(_audioData[i]);
	 //    }

  //  		var audioBuffer = new AudioBuffer ();
		// audioBuffer.bitsPerSample = 16;
		// audioBuffer.channels = 1;
		// audioBuffer.data = _audioData;
		// audioBuffer.sampleRate = _sampleRate;
		// _audioSource = new AudioSource(audioBuffer);
		// _audioSource.play();
	    // _audioBuffer = AudioBuffer.fromFile("assets/sounds/Voyager_Ohh1.wav");
		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		_audioSource.play();
		// trace("Delta time: " + FlxG.elapsed);
		// if (counter % 50 == 0 || counter % 45 == 0) {
		// 	_sound1.play(true);	
		// }
		
		// if (counter % 100 == 0) {
		// 	_sound2.play(true);	
		// }

		// if (counter % 43 == 0) {
		// 	_sound3.play(true);	
		// }

		// if (counter % 72 == 0) {
		// 	_sound4.play(true);	
		// }

		// ++counter;
		super.update();
	}

	public function play():Void
	{
		trace("PLAY!");
		// var sound = new FlxSound();
		// sound.loadByteArray(_audioData2);
		// sound.play();
		// AL.bufferData(_buffer, AL.FORMAT_MONO16, _audioData, _audioData.length * 2, _sampleRate);
		// AL.sourcei(_source, AL.BUFFER, _buffer);
		// AL.sourcePlay(_source);
	}	
}