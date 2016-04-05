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
    var _origin:Vector;
    var _point_radius:Float;
    var _circle_visuals:Array<Visual>;
    var _grid_visuals:Array<Visual>;    
    var _sweep_line_visual:Visual;
    var _angles:Array<Float>;

    public function new(?options:ComponentOptions) 
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

        _angles = new Array<Float>();
        _circle_visuals = new Array<Visual>();
        _grid_visuals = new Array<Visual>();

        _origin = new Vector(Main.w * 0.5, Main.h * 0.5);

        super(options);
    }

    override function onadded():Void
    {
        init_visuals(16);
    }

    public function init_visuals(intervals:Int):Void
    {
        _debug("---------- EuclidianVisualiser.init_visuals ----------");

        var base_delta_angle = 2 * Math.PI / intervals;
        var base_delta_half_angle = 0.5 * base_delta_angle;

        var total_radius = 5.0 + 10;

        for (i in 0...intervals)
        {
            _angles.push(i * base_delta_angle);

            var grid_line_end_pos:Vector = new Vector();

            grid_line_end_pos.x = _origin.x + total_radius * Math.cos(_angles[i] + base_delta_half_angle);
            grid_line_end_pos.y = _origin.y + total_radius * Math.sin(_angles[i] + base_delta_half_angle);

            var grid_line_geometry = Luxe.draw.line({
                p0 : new Vector(_origin.x, _origin.y),
                p1 : grid_line_end_pos
                });

            _debug("---------- EuclidianVisualiser.init_visuals ----------");   

            var grid_line_visual = new Visual({
                name : entity.name + '.grid_visual_' + i,
                parent : entity,
                geometry : grid_line_geometry,
                color : new Color(1.0, 0.0, 0.0, 0.5),
                // visible : false 
                });

            _grid_visuals.push(grid_line_visual);

            var circle_pos_x = _origin.x + 0.75 * total_radius * Math.cos(_angles[i]);
            var circle_pos_y = _origin.y + 0.75 * total_radius * Math.sin(_angles[i]);

            var circle_geometry = Luxe.draw.circle({
                x : circle_pos_x,
                y : circle_pos_y,
                r : 1.0,
                steps : 10
                });
            
            var circle_visual = new Visual({ 
                name : entity.name + '.circle_visual_' + i,
                parent : entity,                
                geometry : circle_geometry,
                color : new Color(0.0, 1.0, 0.0, 1.0),                
                // visible : false
                });

            _circle_visuals.push(circle_visual);
        }

        var sweep_line_geometry = Luxe.draw.line({
            p0 : new Vector(0, 0, 0),
            p1 : new Vector(0, -1 * total_radius, 0)
            });

        _sweep_line_visual = new Visual({ 
            name : entity.name + '.sweep_line_visual',
            parent : entity,
            geometry : sweep_line_geometry,
            color : new Color(0.0, 1.0, 1.0, 1),
            });

        _sweep_line_visual.pos = _origin;      
    }

    public function set_progress(sound_id:Int, value:Float):Void
    {
        // _debug("---------- EuclidianVisualiser.set_progress ----------" + value);

        var currentAngle = 2 * Math.PI * value;
        var fractionalPart = currentAngle / _angles[1];
        var integerPart = Std.int(fractionalPart);
        fractionalPart -= integerPart;

        var rotation = value * 360;
        _sweep_line_visual.rotation_z = rotation;
    }

    override public function onremoved():Void 
    {
        _debug("---------- EuclidianVisualiser.onremoved ----------");

        // MiosisUtilities.clear(_note_offsets);
        // _note_offsets = null;

    }
}
