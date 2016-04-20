package dk.miosis.euclido.component;

import luxe.Color;
import luxe.Log.*;
import luxe.options.ComponentOptions;
import luxe.resource.Resource.AudioResource;

import dk.miosis.euclido.Constants;
import dk.miosis.euclido.component.EuclidianVisualiser;
import dk.miosis.euclido.utility.EuclidianRhythmGenerator;
import dk.miosis.euclido.utility.MiosisUtilities;

typedef EuclidianUIOptions = {
    > ComponentOptions,
    @:optional var shift : String;    
}

class EuclidianUI extends luxe.Component
{
    public function new(sound_count:Int, tempo:Int, note_count:Int, ?_options:EuclidianUIOptions) 
    {
        _debug("---------- Sequencer.new ----------");

        if (_options == null) 
        {
            _options = { name : "euclidian_sequencer_ui"};
        } 
        else if (_options.name == null)
        {
            _options.name = "euclidian_sequencer_ui";
        }

        super(_options);
    }

    inline function make_slider(n, x, y, w, h) 
    {
        var _s = new mint.Slider({
            parent: Main.canvas, 
            name : n, 
            x : x,
            y : y, 
            w : w, 
            h : h,
            options : { color_bar : new Color().rgb(Constants.COLOR_GB_1_LIGHT) },
            min : 0, 
            max : 10, 
            step : 1, 
            vertical : false, 
            value : 5 
            });
    }
}

