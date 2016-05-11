package euclido.component;

import luxe.Color;
import luxe.Log.*;
import luxe.Vector;
import luxe.options.ComponentOptions;
import luxe.resource.Resource.AudioResource;

import miosis.ui.MiosisSliderControl;
import miosis.ui.MiosisSliderRender;
import miosis.utility.MiosisUtilities;

import euclido.Constants;
import euclido.component.EuclidianVisualiser;
import euclido.utility.EuclidianRhythmGenerator;

typedef EuclidianUIOptions = {
    > ComponentOptions,
    @:optional var id:Int;
    @:optional var pulses : Int;
    @:optional var shift : Int;    
}

class EuclidianUI extends luxe.Component
{
    var _id:Int;

    public function new(?_options:EuclidianUIOptions) 
    {
        _debug("---------- Sequencer.new ----------");

        if (_options == null) 
        {
            _options = { name : "euclidian_sequencer_ui" };
        } 
        else if (_options.name == null)
        {
            _options.name = "euclidian_sequencer_ui";
        }

        def(_options.pulses, 1);
        def(_options.shift, 0);

        super(_options);

        var slider_w = 20 * Main.game_scale;
        var slider_h = 4 * Main.game_scale;
        var scale = 1 / Main.game_scale;       

        // Init pulses slider
        var pulses_slider = make_slider("pulses_slider", 10, 10, slider_w, slider_h);

        pulses_slider.w *= scale;
        pulses_slider.h *= scale;
        pulses_slider.refresh();
        pulses_slider.onchange.listen(on_pulses_slider_changed);        
                
        // Init shift slider
        var shift_slider = make_slider("shift_slider", 10, 30, slider_w, slider_h);

        shift_slider.w *= scale;
        shift_slider.h *= scale;
        shift_slider.refresh();        
        shift_slider.onchange.listen(on_shift_slider_changed);
    }

    private function on_pulses_slider_changed(value:Float, prev_value:Float):Void
    {
        var args = {
            id : _id,
            value : value
        };

        Luxe.events.fire('pulses_changed', args);
        // log("Slider value : " + value);
    }

    private function on_shift_slider_changed(value:Float, prev_value:Float):Void
    {
        var args = {
            id : _id,
            value : value
        };

        Luxe.events.fire('shift_changed', args);
    }

    inline function make_slider(n, x, y, w, h):MiosisSliderControl
    {
        var margin = 1;
        return new MiosisSliderControl({
            parent: Main.canvas, 
            name : n, 
            x : x,
            y : y, 
            w : w, 
            h : h,
            options : { 
                color : new Color().rgb(Constants.COLOR_GB_2_LIGHT), 
                color_bar : new Color().rgb(Constants.COLOR_GB_2_OFF) 
                },
            min : 0, 
            max : 10, 
            step : 1, 
            value : 5 
            }, margin / Main.game_scale);
    }
}
