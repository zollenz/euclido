package dk.miosis.euclido.component;

import luxe.Color;
import luxe.Log.*;
import luxe.Vector;
import luxe.options.ComponentOptions;
import luxe.resource.Resource.AudioResource;

import dk.miosis.euclido.Constants;
import dk.miosis.euclido.component.EuclidianVisualiser;
import dk.miosis.euclido.utility.EuclidianRhythmGenerator;
import dk.miosis.euclido.utility.MiosisUtilities;
import dk.miosis.euclido.ui.MiosisSliderControl;
import dk.miosis.euclido.ui.MiosisSliderRender;

typedef EuclidianUIOptions = {
    > ComponentOptions,
    @:optional var shift : String;    
}

class EuclidianUI extends luxe.Component
{
    public function new(?_options:EuclidianUIOptions) 
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

        make_slider("slider", 0, 0, 20, 2);

    }

    inline function make_slider(n, x, y, w, h) 
    {
        var slider = new MiosisSliderControl({
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
            vertical : false, 
            value : 5 
            }, 0);
        // var render:MiosisSliderRender = cast slider.renderer;
        // slider.w *= 0.25;
        // slider.h *= 7.25;
        // slider.refresh();      
        // render.visual.transform.scale = new Vector(0.25, 0.25);
        // render.bar.transform.scale = new Vector(0.25, 0.25);
    }
}

