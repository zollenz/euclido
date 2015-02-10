package dk.myosis.ngj2015.euclidrhythm;

import haxe.ds.Vector;
import openfl.geom.Point;
import openfl.filters.GlowFilter;
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
	private var _origin:Point;
	private var _tempPoint:Point;	
	private var _points:Vector<Point>;
	private var _manager:EuclidRhythmManager;
	private var _sweepLineStyle:LineStyle;
	private var _gridLineStyle:LineStyle;
	private var _baseDeltaAngle:Float;
	private var _palette:Vector<Int>;

  	/////////////////
    // Constructor //
    /////////////////

    public function new(manager:EuclidRhythmManager, layerDistance:Float, pointRadius:Float) 
    {
        super(0, 0);
        _counter = 0.0;
        _manager = manager;
        _layerCount = _manager.getInstrumentCount();
        _baseDeltaAngle = 2 * Math.PI / _manager.notesPerBar;
       	_layerDistance = layerDistance;
        _pointRadius = pointRadius;
		_radiusAngle = 0;        
		_radiusLength = _layerCount * _layerDistance;
        _origin = new Point(0.5 * FlxG.width, 0.5 * FlxG.height);
		_tempPoint = new Point();
   		makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
   		_points = new Vector<Point>(16 * _layerCount);
		_palette = new Vector<Int>(5);
		_palette[0] = 0xff5db89d;
		_palette[1] = 0xff007034;
		_palette[2] = 0xff8c8535;
		_palette[3] = 0xffffca00;
		_palette[4] = 0xfff26547;
		_sweepLineStyle = { color: _palette[4], thickness: 3.0 };
		_gridLineStyle = { color: 0xAA555555, thickness: 1.0 };		
    }

  	//////////////////////
    // Public functions //
    //////////////////////

    override public function update():Void 
	{
		fill(FlxColor.TRANSPARENT);
		// TODO: precompute
		var fractionalPart = _radiusAngle / _baseDeltaAngle;
		var integerPart = Std.int(fractionalPart);
		fractionalPart -= integerPart;
		var radiusHalfAngle = 0.5 * _baseDeltaAngle;

		for (i in 0..._layerCount)
		{
			var distanceFromOrigin:Float = (i + 1) * _layerDistance;

			for (j in 0..._manager.notesPerBar)
			{
				_tempPoint.x = _origin.x + distanceFromOrigin * Math.cos(j * _baseDeltaAngle);
				_tempPoint.y = _origin.y + distanceFromOrigin * Math.sin(j * _baseDeltaAngle);

				if (_manager.getNoteStatus(i,j))
				{
					if (fractionalPart < 0.5 && integerPart == j)
					{
						drawCircle(_tempPoint.x, _tempPoint.y, _pointRadius * 1.5, _palette[i]);
					}
					else
					{
						drawCircle(_tempPoint.x, _tempPoint.y, _pointRadius, _palette[i]);
					}					
				}

				if (i == 0) 
				{
					_tempPoint.x = _origin.x + _radiusLength * Math.cos(j * _baseDeltaAngle + radiusHalfAngle);
					_tempPoint.y = _origin.y + _radiusLength * Math.sin(j * _baseDeltaAngle + radiusHalfAngle);
					drawLine(_origin.x, _origin.y, _tempPoint.x, _tempPoint.y, _gridLineStyle);
				}
			}
		}

		_tempPoint.x = _origin.x + _radiusLength * Math.cos(_radiusAngle);
		_tempPoint.y = _origin.y + _radiusLength * Math.sin(_radiusAngle);
		drawLine(_origin.x, _origin.y, _tempPoint.x, _tempPoint.y, _sweepLineStyle);
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
		_origin = null;
		_tempPoint = null;

		for (i in 0..._points.length)
		{
			_points[i] = null;
		}

		_points = null;
		_sweepLineStyle = null;
		_manager = null;
		super.destroy();
	}

	///////////////////////
    // Private functions //
    ///////////////////////
 }