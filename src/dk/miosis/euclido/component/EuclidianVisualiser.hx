package dk.miosis.euclido.component;

import luxe.Color;
import luxe.Component;
import luxe.Log.*;
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

            var current_angle = 2 * Math.PI * 0.75;

            var sweep_line_end_pos = new Vector();

            sweep_line_end_pos.x = _origin.x + total_radius * Math.cos(current_angle);
            sweep_line_end_pos.y = _origin.y + total_radius * Math.sin(current_angle);

            var sweep_line_geometry = Luxe.draw.line({
                p0 : _origin,
                p1 : sweep_line_end_pos
                });

            _sweep_line_visual = new Visual({ 
                name : entity.name + '.sweep_line_visual',
                parent : entity,
                geometry : sweep_line_geometry,
                color : new Color(0.0, 0.0, 1.0, 1),
                // visible : false
                });
        }
    }

    override public function update(dt:Float):Void 
    {
        // // _debug("---------- EuclidianVisualiser.update ----------");

        // if (_sequencer == null)
        // {
        //     super.update(dt);
        //     return;
        // }

        // var currentAngle = 2 * Math.PI * _progress;
        // var fractionalPart = currentAngle / _base_delta_angle;
        // var integerPart = Std.int(fractionalPart);
        // fractionalPart -= integerPart;

        // for (i in 0..._angles.length)
        // {
        //     for (j in 0..._layer_count)
        //     {
        //         var distance_from_origin:Float = (j + 1) * _layer_distance;

        //         _temp_point.x = _origin.x + distance_from_origin * Math.cos(_angles[i]);
        //         _temp_point.y = _origin.y + distance_from_origin * Math.sin(_angles[i]);

        //         if (_sequencer.is_note_on(i, j))
        //         {
        //             if (integerPart == i && fractionalPart < 0.5)
        //             {
        //                 // _pointGeometries[i * _angles.length + j].
        //             }
        //             else
        //             {
        //                 // Luxe.draw.ring({
        //                 //     x : _temp_point.x,
        //                 //     y : _temp_point.y,
        //                 //     r : point_radius * 1.5,
        //                 //     color : new Color().rgb(_palette[j])
        //                 //     });
        //             }                   
        //         }
        //     }
        // }

        super.update(dt);
    }

    public function set_progress(sound_id:Int, value:Float):Void
    {
        _sweep_line_visual.rotation_z = value;
    }

    override public function onremoved():Void 
    {
        _debug("---------- EuclidianVisualiser.onremoved ----------");

        // MiosisUtilities.clear(_note_offsets);
        // _note_offsets = null;

    }
}
