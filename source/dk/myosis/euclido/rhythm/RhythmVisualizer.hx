package dk.myosis.euclido.rhythm;

import haxe.ds.Vector;
import openfl.geom.Point;
import openfl.filters.GlowFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import dk.myosis.euclido.rhythm.RhythmManager;

using flixel.util.FlxSpriteUtil;

class RhythmVisualizer extends FlxSprite
{
	/////////////////////
    // Class variables //
    /////////////////////

	var _layerCount:Int;
	var _layerDistance:Float;
	var _radiusLength:Float;
	var _pointRadius:Float;
	var _origin:Point;
	var _tempPoint:Point;	
	var _points:Vector<Point>;
	var _manager:RhythmManager;
	var _sweepLineStyle:LineStyle;
	var _gridLineStyle:LineStyle;
	var _baseDeltaAngle:Float;
	var _baseDeltaHalfAngle:Float;
	var _palette:Vector<Int>;
	var _angles:Vector<Float>;

  	/////////////////
    // Constructor //
    /////////////////

    public function new(manager:RhythmManager, layerDistance:Float, pointRadius:Float) 
    {
        super(0, 0);
        _manager = manager;
        _layerCount = _manager.getSoundCount();
        _baseDeltaAngle = 2 * Math.PI / (_manager.notesPerBeat * 4);
        _baseDeltaHalfAngle = 0.5 * _baseDeltaAngle;
       	_layerDistance = layerDistance;
        _pointRadius = pointRadius;
		_radiusLength = _layerCount * _layerDistance;
		trace("radiuslength: " + _radiusLength);
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

		_angles = new Vector<Float>(_manager.notesPerBeat * 4);

		for (i in 0..._angles.length)
		{
			_angles[i] = i * _baseDeltaAngle;
		}

    }

  	//////////////////////
    // Public functions //
    //////////////////////

    override public function update():Void 
	{
		fill(FlxColor.TRANSPARENT);
		var currentAngle = 2 * Math.PI * _manager.getCurrentCycleRatio();
		var fractionalPart = currentAngle / _baseDeltaAngle;
		var integerPart = Std.int(fractionalPart);
		fractionalPart -= integerPart;

		for (i in 0..._angles.length)
		{
			_tempPoint.x = _origin.x + _radiusLength * Math.cos(_angles[i] + _baseDeltaHalfAngle);
			_tempPoint.y = _origin.y + _radiusLength * Math.sin(_angles[i] + _baseDeltaHalfAngle);
			drawLine(_origin.x, _origin.y, _tempPoint.x, _tempPoint.y, _gridLineStyle);

			for (j in 0..._layerCount)
			{
				var distanceFromOrigin:Float = (j + 1) * _layerDistance;	
				_tempPoint.x = _origin.x + distanceFromOrigin * Math.cos(_angles[i]);
				_tempPoint.y = _origin.y + distanceFromOrigin * Math.sin(_angles[i]);

				if (_manager.isSoundNoteOn(i,j))
				{
					if (integerPart == i && fractionalPart < 0.5)
					{
						drawCircle(_tempPoint.x, _tempPoint.y, _pointRadius * 1.5, _palette[j]);
					}
					else
					{
						drawCircle(_tempPoint.x, _tempPoint.y, _pointRadius, _palette[j]);
					}					
				}
			}
		}

		_tempPoint.x = _origin.x + _radiusLength * Math.cos(currentAngle);
		_tempPoint.y = _origin.y + _radiusLength * Math.sin(currentAngle);
		drawLine(_origin.x, _origin.y, _tempPoint.x, _tempPoint.y, _sweepLineStyle);
		super.update();
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
		_angles = null;
		_sweepLineStyle = null;
		_gridLineStyle = null;
		_manager = null;
		super.destroy();
	}

	///////////////////////
    // Private functions //
    ///////////////////////
 }