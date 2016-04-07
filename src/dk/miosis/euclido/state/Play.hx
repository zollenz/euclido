package dk.miosis.euclido.state;

import luxe.Color;
import luxe.Entity;
import luxe.Log.*;
import luxe.Vector;
import luxe.Visual;

import dk.miosis.euclido.component.EuclidianSequencer;
import dk.miosis.euclido.component.EuclidianVisualiser;

class Play extends BaseState
{
    var _sequencer:EuclidianSequencer;
    var _visualisers:Array<EuclidianVisualiser>;

    public function new() 
    {
        _debug("---------- Euclido.new ----------");

        super({ name : 'euclido', fade_in_time : 4.5, fade_out_time : 0.5 });
    }

    override function onenter<T>(_:T) 
    {
        _debug("---------- Euclido.onenter ----------");

        Luxe.renderer.clear_color = new Color().rgb(Constants.COLOR_GB_2_DARK);

        var root = new Entity({ name: 'root'});

        var sound_count = 4;

        _sequencer = new EuclidianSequencer(sound_count, 120, 16);
        root.add(_sequencer);

        _visualisers = new Array<EuclidianVisualiser>();

        for (i in 0...sound_count)
        {
            var pos:Vector = new Vector();

            if (i < 2)
            {
                pos.x = Math.floor((1 / 3) * Main.w * (i + 1));
                pos.y = Math.floor((1 / 3) * Main.h);
            }
            else
            {
                pos.x = Math.floor((1 / 3) * Main.w * (i - 2 + 1));
                pos.y = Math.floor((2 / 3) * Main.h);
            }

            var visualiser_entity = new Entity({ 
                name : 'visualiser_entity_' + i, 
                parent : root, 
                pos : pos
                });
            var visualiser = new EuclidianVisualiser(
                _sequencer.note_count,
                {
                name : 'visualiser_component_' + i
                });
            visualiser.note_mask = _sequencer.get_note_mask(i);
            // visualiser_entity.rotation = new Quaternion.fro
            _visualisers.push(visualiser_entity.add(visualiser));
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
        for (i in 0..._visualisers.length)
        {
            _visualisers[i].set_progress(0, _sequencer.get_current_cycle_ratio(0));
        }
    }   
}