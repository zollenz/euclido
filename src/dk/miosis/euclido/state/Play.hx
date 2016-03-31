package dk.miosis.euclido.state;

import luxe.Color;
import luxe.Entity;
import luxe.Log.*;
import luxe.Visual;

import dk.miosis.euclido.component.EuclidianSequencer;
import dk.miosis.euclido.component.EuclidianVisualiser;

class Play extends BaseState
{
    var _sequencer:EuclidianSequencer;
    var _pattern_visualisers:Array<EuclidianVisualiser>;

    public function new() 
    {
        _debug("---------- Euclido.new ----------");

        super({ name : 'euclido', fade_in_time : 4.5, fade_out_time : 0.5 });
    }

    override function onenter<T>(_:T) 
    {
        _debug("---------- Euclido.onenter ----------");

        Luxe.renderer.clear_color = new Color().rgb(Constants.COLOR_BLUE);

        var root = new Entity({ name: 'root'});

        var sound_count = 1;

        _sequencer = new EuclidianSequencer(sound_count, 110, 4);
        root.add(_sequencer);

        _pattern_visualisers = new Array<EuclidianVisualiser>();

        for (i in 0...sound_count)
        {
            var pattern_visualiser = new EuclidianVisualiser({
                name : 'euclidian_visualiser_' + i,
                
                });

            _pattern_visualisers.push(root.add(pattern_visualiser));
        }

        super.onenter(_);       
    }

    override function onleave<T>( _data:T ) 
    {
        _debug("---------- Euclido.onleave ----------");
        
        // Clean up

        super.onleave(_data);
    }

    override function update(dt:Float)
    {
        for (i in 0..._pattern_visualisers.length)
        {
            _pattern_visualisers[i].set_progress(0, _sequencer.get_current_cycle_ratio(0));
        }
    }   
}