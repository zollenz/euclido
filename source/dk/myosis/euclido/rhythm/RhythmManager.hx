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
    public var notesPerBar(default, null):Int;

    public var SUBMASK(default, never):Array<Int> = 
        [ 
            0x1, 
            0x3, 
            0x7, 
            0xf, 
            0x1f, 
            0x3f, 
            0x7f, 
            0xff, 
            0x1ff,
            0x3ff,
            0x7ff,
            0xfff,
            0x1fff,
            0x3fff,
            0x7fff,
            0xffff
        ];


  	/////////////////
    // Constructor //
    /////////////////

	public function new(soundCount:Int, tempo:Int, notesPerBeat:Int) 
    {
     //    _nextNote = 0;
     //    _currentTime = 0.0;
    	// this.notesPerBeat = notesPerBeat;
     //    this.notesPerBar = notesPerBeat * 4;
     //    _noteOffsets = new Vector<Float>(notesPerBar);
    	// _noteMasks = new Vector<Int>(notesPerBar);
     //    _sounds = new Vector<FlxSound>(soundCount);
     //    _timePerNote = 60 / (tempo * notesPerBeat);

     //    trace("_timePerNote = " + _timePerNote);
     //    trace("Time per tick = " + (1 / FlxG.updateFramerate));
     //    FlxG.log.add("Time per tick: " + (1 / FlxG.updateFramerate));

     //    if (_timePerNote < 1 / FlxG.updateFramerate)
     //    {
     //        trace("Framerate too low for tempo");
     //    }

     //    _timePerBar = _timePerNote * notesPerBar;

     //    for (i in 0..._noteOffsets.length)
     //    {
     //        _noteOffsets[i] = i * _timePerNote;
     //        // trace("_noteOffsets[" + i + "] = " + _noteOffsets[i]);
     //    }

    	// // Create random note masks
    	// for (i in 0..._noteMasks.length)
    	// {
     //        _noteMasks[i] = 0;

    	// 	for (j in 0..._sounds.length)
    	// 	{
    	// 		if (Math.random() > 0.5)
    	// 		{
		   //  		_noteMasks[i] |= (1 << j);    				
    	// 		}
    	// 	}
    	// }

     //    for (i in 0..._sounds.length)
     //    {
     //        _sounds[i] = FlxG.sound.load("assets/sounds/sound_" + i + ".wav", 1.0);
     //    }


     //    FlxG.sound.volume = 1.0;
        computeEuclidianSequence(4, 10);

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

    function intToBinaryString(value:Int, size:Int = 32, spaced:Bool = false):String
    {
        var str = "";
        var i = size;

        while (i-- > 0)
        {
            if (spaced && i < size - 1 && (i + 1) % 4 == 0) 
            {
                str += " ";
            }

            if ((value & (1 << i)) > 0)
            {
                str += "1";
            }
            else
            {
                str += "0";
            }
        }

        return str;
    }

    function binaryStringToInt(str:String, size:Int = 32):Int
    {
        var value = 0;
        var i = size;

        while (--i > -1)
        {
            if (str.charAt(i) == "1")
            {
                value & (1 << i);
            }
        }

        return value;
    }

    function recursiveGCD(totalBitsLength:Int, k:Int, n:Int, quotientBits:Int, quotientLength:Int, remainderBits:Int, remainderLength:Int):Int
    {
        trace ("[GCD] k = " + k + ", n = " + n);
        var mod = n % k;

        trace ("[GCD] mod = " + mod);        
        var div = Std.int(n / k);
        trace ("GCD, div: " + div + ", mod : " + mod);
      
        var oldQuotientBits = quotientBits; 
        quotientBits = quotientBits << remainderLength;
        quotientBits |= remainderBits;
        quotientLength += remainderLength;

        if (mod == 0) {
            remainderLength = 0;
            remainderBits = 0;
        } else {
            remainderLength = Std.int((totalBitsLength - k * quotientLength) / mod);
            
            if (k + n < totalBitsLength) {
                remainderBits = oldQuotientBits;
            }
        }


        var value = 0;
        var i = 0;

        while (i++ < k)
        {
            value |= quotientBits << totalBitsLength - i * quotientLength;
            trace("quotient: " + i);
            trace("Quotient bits string: " + intToBinaryString(quotientBits, totalBitsLength, true)); 
            trace("Result bits string: " + intToBinaryString(value, totalBitsLength, true)); 

        }

        i = 0;

        while (i++ < mod)
        {
            trace("remainder: " + i);
            value |= remainderBits << (totalBitsLength - k * quotientLength - i * remainderLength);
            trace("Result bits string: " + intToBinaryString(value, totalBitsLength, true)); 
        }

        // trace("Result bits value: " + value);
        trace ("Quotient length : " + quotientLength);
        trace ("Remainder length : " + remainderLength);
        trace("Quotient bits: " + intToBinaryString(quotientBits, totalBitsLength, true));
        trace("Remainder bits: " + intToBinaryString(remainderBits, totalBitsLength, true));             
        trace("Result bits: " + intToBinaryString(value, totalBitsLength, true));

        if (k <= 1) {
            trace ("DONE!");
            return value;
        } else {
            return recursiveGCD(totalBitsLength, mod, k, quotientBits, quotientLength, remainderBits, remainderLength);
        }
    }

    function getValue(totalBitsLength:Int, quotientBits:Int, quotientLength:Int, remainderBits:Int, remainderLength:Int):Int
    {

    }

    function computeEuclidianSequence(bitsToSet:Int, totalBitCount:Int):Int
    {
        var resultBits = 0;
        var offset = 0;

        offset = totalBitCount - bitsToSet;
        var i = totalBitCount;

        while (i-- > offset)
        {
            resultBits |= (1 << i);
        }

        // trace("Result bits value: " + resultBits);
        trace("Result bits string: " + intToBinaryString(resultBits, totalBitCount, true));        

        return recursiveGCD(totalBitCount, bitsToSet, totalBitCount, 1, 1, 0, 1);
    }
}