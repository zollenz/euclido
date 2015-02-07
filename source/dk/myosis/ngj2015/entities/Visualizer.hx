package dk.myosis.ngj2015.entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxAngle;
import flixel.FlxObject;

using flixel.util.FlxSpriteUtil;

class Visualizer extends FlxSprite
{
	private var _radius:Float;

    public function new(x:Float = 0, y:Float = 0) 
    {
        super(x, y);
		_radius = 0.25 * FlxG.height;
   		makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		var lineStyle = { color: FlxColor.RED, thickness: 2.0 };
		var fillStyle = { color: FlxColor.BLUE, alpha: 0.5 };
		drawCircle(0.5 * FlxG.width, 0.5 * FlxG.height, _radius, FlxColor.BLACK, lineStyle);
		// var lineStyle = { color: FlxColor.CHARTREUSE, thickness: 2.0 };
		// _canvas.drawLine(0, 0, 200, 200, lineStyle);

    }
 }