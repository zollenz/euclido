package dk.myosis.ngj2015.euclidrhythm;

import haxe.ds.Vector;
import flixel.FlxBasic;

class EuclidRhythmManager extends FlxBasic
{
	/////////////////////
    // Class variables //
    /////////////////////

	private var _parametersChanged:Bool;
	private var _noteMask:Vector<Int>;

  	/////////////////
    // Constructor //
    /////////////////

	public function new(instrumentCount:Int) 
    {
    	_noteMask = new Vector<Int>(instrumentCount);

    	for (i in 0..._noteMask.length)
    	{
	    	_noteMask[i] = 0;
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

	///////////////////////
    // Private functions //
    ///////////////////////
}