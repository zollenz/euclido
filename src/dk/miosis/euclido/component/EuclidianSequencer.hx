package dk.miosis.euclido.component;

import luxe.Log.*;
import luxe.options.ComponentOptions;
import luxe.resource.Resource.AudioResource;

import dk.miosis.euclido.component.EuclidianVisualiser;
import dk.miosis.euclido.utility.EuclidianRhythmGenerator;
import dk.miosis.euclido.utility.MiosisUtilities;

class EuclidianSequencer extends luxe.Component
{
    var _note_masks:Array<Int>;
    var _note_offsets:Array<Float>;
    var _sounds:Array<AudioResource>;

    var _current_time:Float;
    var _note_time:Float;
    var _time_per_bar:Float;
    var _next_note:Int;
    
    public var notes_per_beat(default, null):Int;
    public var notes_per_bar(default, null):Int;

    public function new(sound_count:Int, tempo:Int, notes_per_beat:Int, ?_options:ComponentOptions) 
    {
        _debug("---------- Sequencer.new ----------");

        if (_options == null) 
        {
            _options = { name : "euclidian_sequencer_component"};
        } 
        else if (_options.name == null)
        {
            _options.name = "euclidian_sequencer_component";
        }

        _next_note = 0;
        _current_time = 0.0;
        
        this.notes_per_beat = notes_per_beat;
        this.notes_per_bar = notes_per_beat * 4;

        _note_offsets = new Array<Float>();
        _note_masks = new Array<Int>();
        _note_time = 60 / (tempo * notes_per_beat);

        _time_per_bar = _note_time * notes_per_bar;

        var min_note_time = 1 / 60;

        _debug("min_note_time = " + min_note_time);
        _debug("_note_time = " + _note_time);        

        if (_note_time < min_note_time)
        {
            _debug("Framerate too low for tempo");
        }

        for (i in 0..._note_offsets.length)
        {
            _note_offsets.push(i * _note_time);
            // trace("_noteOffsets[" + i + "] = " + _noteOffsets[i]);
        }

        // Init sounds

        _sounds = new Array<AudioResource>();

        for (i in 0...sound_count)
        {
            var resource = Luxe.resources.audio('assets/audio/euclido/sound_' + i);
            _sounds.push(resource);
        }

        var rhythm_generator = new EuclidianRhythmGenerator();

        rhythm_generator.generate(16, 5);
        _note_masks.push(rhythm_generator.get_bitmask());

        rhythm_generator.generate(16, 3);
        _note_masks.push(rhythm_generator.get_bitmask());

        rhythm_generator.generate(16, 2);
        _note_masks.push(rhythm_generator.get_bitmask());

        rhythm_generator.generate(16, 8);
        _note_masks.push(rhythm_generator.get_bitmask());

        _debug(_note_masks);

        super(_options);
    }

    override public function update(dt:Float):Void 
    {
        trace("Current time: " + dt);

        if (_current_time >= _note_offsets[_next_note] - 0.0001 && _current_time <= _note_offsets[_next_note] + 0.0001)
        {
            for (i in 0..._sounds.length)
            {
                _debug(_note_masks[i]);
                if (_note_masks[i] != 0 && is_note_on(i, _next_note))
                {
                    // _sounds[i].play(true);
                    _debug("BOOM");
                }
            }

            if (++_next_note >= _note_masks.length)
            {
                _next_note = 0;
            }            
        }

        _current_time += dt;

        if (_current_time >= _time_per_bar)
        {
            _current_time = 0.0;
        }

        super.update(dt);
    }

    override public function onremoved():Void 
    {
        MiosisUtilities.clear(_note_offsets);
        _note_offsets = null;
        
        MiosisUtilities.clear(_note_masks);
        _note_masks = null;        

        for (i in 0..._sounds.length)
        {
            _sounds[i];
        }

        MiosisUtilities.clear(_sounds);
        _sounds = null;
    }

    public function get_sound_count():Int
    {
        return _sounds.length;
    }

    public function get_current_cycle_ratio(sound_id):Float
    {
        return _current_time / _time_per_bar;
    }

    public function is_note_on(soundIndex:Int, tick:Int):Bool
    {
        return (_note_masks[soundIndex] & (1 << tick)) > 0;
    }
}
