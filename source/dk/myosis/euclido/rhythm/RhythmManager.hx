package dk.myosis.euclido.rhythm;

import haxe.ds.Vector;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.system.FlxSound;
import flixel.util.FlxDestroyUtil;

class RhythmManager extends FlxBasic
{
	/////////////////////
    // Class variables //
    /////////////////////
    var _noteMasks:Vector<Int>;
    var _noteOffsets:Vector<Float>;
    var _sounds:Vector<FlxSound>;    
    var _currentTime:Float;
    var _timePerNote:Float;
    var _timePerBar:Float;
    var _nextNote:Int;
	public var notesPerBeat(default, null):Int;


  	/////////////////
    // Constructor //
    /////////////////

	public function new(soundCount:Int, tempo:Int, notesPerBeat:Int) 
    {
        _nextNote = 0;
        _currentTime = 0.0;
    	this.notesPerBeat = notesPerBeat;
        _noteOffsets = new Vector<Float>(notesPerBeat * 4);
    	_noteMasks = new Vector<Int>(notesPerBeat * 4);
        _sounds = new Vector<FlxSound>(soundCount);
        _timePerNote = 60 / (tempo * notesPerBeat);

        trace("_timePerNote = " + _timePerNote);
        trace("Time per tick = " + (1 / FlxG.updateFramerate));
        FlxG.log.add("Time per tick: " + (1 / FlxG.updateFramerate));

        if (_timePerNote < 1 / FlxG.updateFramerate)
        {
            trace("Framerate too low for tempo");
        }

        _timePerBar = _timePerNote * notesPerBeat * 4;

        for (i in 0..._noteOffsets.length)
        {
            _noteOffsets[i] = i * _timePerNote;
            // trace("_noteOffsets[" + i + "] = " + _noteOffsets[i]);
        }

    	// Create random note masks
    	for (i in 0..._noteMasks.length)
    	{
            _noteMasks[i] = 0;

    		for (j in 0..._sounds.length)
    		{
    			if (Math.random() > 0.5)
    			{
		    		_noteMasks[i] |= (1 << j);    				
    			}
    		}
    	}

        for (i in 0..._sounds.length)
        {
            _sounds[i] = FlxG.sound.load("assets/sounds/sound_" + i + ".wav", 1.0);
        }

        FlxG.sound.volume = 1.0;
    	super();
    }

	//////////////////////
    // Public functions //
    //////////////////////

    override public function update():Void 
	{
        // trace("Current time: " + _currentTime);

        if (_currentTime >= _noteOffsets[_nextNote] - 0.0001 && _currentTime <= _noteOffsets[_nextNote] + 0.0001)
        {
            for (i in 0..._sounds.length)
            {
                if (_noteMasks[i] != 0 && isSoundNoteOn(_nextNote, i))
                {
                    _sounds[i].play(true);
                }
            }

            if (++_nextNote >= _noteMasks.length)
            {
                _nextNote = 0;
            }            
        }

        _currentTime += FlxG.elapsed;

        if (_currentTime >= _timePerBar)
        {
            _currentTime = 0.0;
        }

		super.update();
	}

	override public function destroy():Void 
	{
        _noteOffsets = null;
		_noteMasks = null;

        for (i in 0..._sounds.length)
        {
            FlxDestroyUtil.destroy(_sounds[i]);
        }

        _sounds = null;
		super.destroy();
	}

	public function getSoundCount():Int
	{
		return _sounds.length;
	}

    public function getCurrentCycleRatio():Float
    {
        return _currentTime / _timePerBar;
    }

	public function isSoundNoteOn(note:Int, sound:Int):Bool
	{
		return (_noteMasks[note] & (1 << sound)) > 0;
	}

	///////////////////////
    // Private functions //
    ///////////////////////
}