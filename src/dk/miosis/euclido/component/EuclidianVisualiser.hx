package dk.miosis.euclido.component;

import luxe.Color;
import luxe.Component;
import luxe.Log.*;
import luxe.Quaternion;
import luxe.Vector;
import luxe.Visual;

import luxe.options.ComponentOptions;
import luxe.utils.Maths;

import phoenix.geometry.CircleGeometry;

import dk.miosis.euclido.component.EuclidianSequencer;
import dk.miosis.euclido.utility.MiosisUtilities;

class EuclidianVisualiser extends Component
{
    var _note_count:Int;
    var _origin:Vector;
    var _point_radius:Float;
    var _circles:Array<Visual>;
    var _grid:Array<Visual>;    
    var _sweep_line:Visual;
    var _angles:Array<Float>;

    var _circles_expanded:Int; // bitmask

    public var note_mask(default, default):Int; // bitmask

    public function new(note_count:Int, ?options:ComponentOptions) 
    {
        _debug("---------- EuclidianVisualiser.new ----------");

        // Set component options

        if (options == null) 
        {
            options = { name : "euclidian_visualiser"};
        } 
        else if (options.name == null)
        {
            options.name = "euclidian_visualiser";
        }

        // Init view variables and data structures

        note_mask = 0;
        _circles_expanded = 0;
        _note_count = note_count;
        _angles = new Array<Float>();
        _circles = new Array<Visual>();
        _grid = new Array<Visual>();

        // _origin = new Vector(Main.w * 0.5, Main.h * 0.5);
        _origin = new Vector(0, 0, 0);

        super(options);
    }

    override function onadded():Void
    {
        // _debug("---------- EuclidianVisualiser.onadded ----------");

        var base_delta_angle = 2 * Math.PI / _note_count;
        var base_delta_half_angle = 0.5 * base_delta_angle;
        var total_radius = 5.0 + 10;

        for (i in 0..._note_count)
        {
            _angles.push(i * base_delta_angle);

            // Init grid
            var grid_line_end_pos:Vector = new Vector();

            grid_line_end_pos.x = _origin.x + total_radius * Math.cos(_angles[i] + base_delta_half_angle);
            grid_line_end_pos.y = _origin.y + total_radius * Math.sin(_angles[i] + base_delta_half_angle);

            var grid_line_geometry = Luxe.draw.line({
                p0 : new Vector(_origin.x, _origin.y),
                p1 : grid_line_end_pos
                });
            // grid_line_geometry.color.a = 0.0;

            var grid_line_visual = new Visual({
                name : entity.name + '.grid_visual_' + i,
                parent : entity,
                geometry : grid_line_geometry,
                color : new Color().rgb(Constants.COLOR_GB_2_MEDIUM),
                });
            grid_line_visual.color.a = 0.05;

            _grid.push(grid_line_visual);

            // Init circles
            var circle_pos_x = _origin.x + 0.75 * total_radius * Math.cos(_angles[i]);
            var circle_pos_y = _origin.y + 0.75 * total_radius * Math.sin(_angles[i]);

            var circle_geometry = Luxe.draw.circle({
                x : circle_pos_x,
                y : circle_pos_y,
                r : 1.0,
                steps : 10
                });

            var circle_color = (note_mask & (1 << i)) == 0 ? 
                                new Color().rgb(Constants.COLOR_GB_2_MEDIUM) : 
                                new Color().rgb(Constants.COLOR_GB_2_OFF);
            
            var circle_visual = new Visual({ 
                name : entity.name + '.circle_visual_' + i,
                parent : entity,                
                geometry : circle_geometry,
                color : circle_color                
                });

            _circles.push(circle_visual);
        }

        // Init sweep line
        var sweep_line_geometry = Luxe.draw.line({
            p0 : new Vector(0, 0, 0),
            p1 : new Vector(total_radius, 0, 0)
            });

        _sweep_line = new Visual({ 
            name : entity.name + '.sweep_line_visual',
            parent : entity,
            geometry : sweep_line_geometry,
            color : new Color().rgb(Constants.COLOR_GB_2_LIGHT),
            });

        _sweep_line.pos = _origin;
    }

    public function set_progress(sound_id:Int, value:Float):Void
    {
        // _debug("---------- EuclidianVisualiser.set_progress ----------" + value);

        var rotation = value * 360;
        _sweep_line.rotation_z = rotation;

        var _current_angle = 2 * Math.PI * value;

        var epsilon = 0.1 * (2 * Math.PI / _note_count);

        var test_mask:Int = 0;
        var min:Float = 0.0;
        var max:Float = 0.0;
        var expand:Bool = false;
        var circleIsHighlighted:Bool = false;
        var circleIsExpanded:Bool = false;        
        var sweepLineIsWithinDelta:Bool = false;

        for (i in 0..._note_count)
        {
            test_mask = (1 <<  i);

            circleIsHighlighted = (note_mask & test_mask) > 0;          

            if (!circleIsHighlighted)
            {
                continue;
            }

            max = _angles[i] + epsilon;

            if (i == 0)
            {
                min = 2 * Math.PI - epsilon;
                sweepLineIsWithinDelta = _current_angle >= min || _current_angle <= max;                
            }
            else
            {
                min = _angles[i] - epsilon;
                sweepLineIsWithinDelta = _current_angle >= min && _current_angle <= max;
            }

            circleIsExpanded = (_circles_expanded & test_mask) > 0;

            if (sweepLineIsWithinDelta)
            {
                // if (!circleIsExpanded)
                // {
                    _circles[i].geometry.transform.scale.x = 1.5;
                    _circles[i].geometry.transform.scale.y = 1.5;
                    _circles_expanded |= test_mask;                                  
                // }
            }
            else
            {
                // if (circleIsExpanded)
                // {
                    _circles[i].geometry.transform.scale.x = 1.0;
                    _circles[i].geometry.transform.scale.y = 1.0;
                    _circles_expanded &= ~test_mask;                                  
                // }
            }
        }
    }

    override public function onremoved():Void 
    {
        _debug("---------- EuclidianVisualiser.onremoved ----------");

        // MiosisUtilities.clear(_note_offsets);
        // _note_offsets = null;

    }
}
