package dk.myosis.ngj2015.euclidrhythm;

import haxe.ds.Vector;
import flixel.FlxBasic;

class EuclidRhythmManager extends FlxBasic
{
	/////////////////////
    // Class variables //
    /////////////////////

	public var notesPerBar(default, null):Int;
	public var parametersChanged(default, null):Bool;
	private var _noteMask:Vector<Int>;

  	/////////////////
    // Constructor //
    /////////////////

	public function new(instrumentCount:Int, notesPerBar:Int) 
    {
    	parametersChanged = false;
    	this.notesPerBar = notesPerBar;
    	_noteMask = new Vector<Int>(instrumentCount);

    	for (i in 0..._noteMask.length)
    	{
	    	_noteMask[i] = 0;
    	}

    	// Create random note masks
    	for (i in 0..._noteMask.length)
    	{
    		for (j in 0...16)
    		{
    			if (Math.random() > 0.5)
    			{
		    		_noteMask[i] |= (1 << j);    				
    			}
    		}
    	}

    	super();
    }

	//////////////////////
    // Public functions //
    //////////////////////

    override public function update():Void 
	{
		for (i in 0..._noteMask.length)
    	{
    		// Do stuff with the bitmask
	    	// _noteMask[i] = 0;
    	}

		super.update();
	}

	override public function destroy():Void 
	{
		_noteMask = null;
		super.destroy();
	}

	public function getInstrumentCount():Int
	{
		return _noteMask.length;
	}

	public function getNoteStatus(instrument:Int, note:Int):Bool
	{
		return (_noteMask[instrument] & (1 << note)) > 0;
	}

	///////////////////////
    // Private functions //
    ///////////////////////
}