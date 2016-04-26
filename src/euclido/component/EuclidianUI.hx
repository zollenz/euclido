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
    @:optional var shift : Int;   
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

        def(_options.shift, 0);

        super(_options);
        make_slider("slider", 20, 20, 20 * Constants.GAME_SCALE, 4 * Constants.GAME_SCALE);
    }

    inline function make_slider(n, x, y, w, h) 
    {
        var margin = 1;
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
            value : 5 
            }, margin / Constants.GAME_SCALE);
        var render:MiosisSliderRender = cast slider.renderer;
        slider.w *= 1 / Constants.GAME_SCALE;
        slider.h *= 1 / Constants.GAME_SCALE;
        slider.refresh();      
    }
}
