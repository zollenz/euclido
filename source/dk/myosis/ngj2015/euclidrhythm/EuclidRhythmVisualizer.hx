package dk.myosis.ngj2015.euclidrhythm;

import haxe.ds.Vector;
import openfl.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import dk.myosis.ngj2015.euclidrhythm.EuclidRhythmManager;

using flixel.util.FlxSpriteUtil;

class EuclidRhythmVisualizer extends FlxSprite
{
	/////////////////////
    // Class variables //
    /////////////////////

	private var _counter:Float; 
	private var _layerCount:Int;
	private var _layerDistance:Float;
	private var _radiusAngle:Float;	
	private var _radiusLength:Float;
	private var _pointRadius:Float;
	private var _radiusStartPos:Point;
	private var _radiusEndPos:Point;	
	private var _points:Vector<Point>;
	private var _manager:EuclidRhythmManager;
	private var _radiusLineStyle:LineStyle;

  	/////////////////
    // Constructor //
    /////////////////

    public function new(layerCount:Int, layerDistance:Float, pointRadius:Float) 
    {
        super(0, 0);
        _counter = 0.0;
        _layerCount = layerCount;
       	_layerDistance = layerDistance;
        _pointRadius = pointRadius;
		_radiusAngle = 0;        
		_radiusLength = _layerCount * _layerDistance;
        _radiusStartPos = new Point(0.5 * FlxG.width, 0.5 * FlxG.height);
		_radiusEndPos = new Point();
		_radiusEndPos.x = _radiusStartPos.x + _radiusLength * Math.cos(_radiusAngle);
		_radiusEndPos.y = _radiusStartPos.y + _radiusLength * Math.sin(_radiusAngle);
   		makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
   		_points = new Vector<Point>(16 * _layerCount);
		_radiusLineStyle = { color: FlxColor.RED, thickness: 2.0 };
    }

  	//////////////////////
    // Public functions //
    //////////////////////

    override public function update():Void 
	{
		fill(FlxColor.TRANSPARENT);
		_radiusEndPos.x = _radiusStartPos.x + _radiusLength * Math.cos(_radiusAngle);
		_radiusEndPos.y = _radiusStartPos.y + _radiusLength * Math.sin(_radiusAngle);
		drawCircle(_radiusStartPos.x, _radiusStartPos.y, _radiusLength, FlxColor.BLACK, _radiusLineStyle);		
		drawLine(_radiusStartPos.x, _radiusStartPos.y, _radiusEndPos.x, _radiusEndPos.y, _radiusLineStyle);
		super.update();
		_radiusAngle += FlxG.elapsed;

		if (_radiusAngle >= 2 * Math.PI)
		{
			_radiusAngle = 0;
		}
		// trace(_counter);
	}
	
	override public function destroy():Void 
	{
		_radiusStartPos = null;
		_radiusEndPos = null;

		for (i in 0..._points.length)
		{
			_points[i] = null;
		}

		_points = null;
		_radiusLineStyle = null;
		_manager = null;
		super.destroy();
	}

	public function setManager(manager:EuclidRhythmManager):Void
    {
    	_manager = manager;
    }

	///////////////////////
    // Private functions //
    ///////////////////////
 }