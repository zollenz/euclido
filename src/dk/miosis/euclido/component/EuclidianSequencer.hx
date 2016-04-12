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
    var _note_masks_shift_amounts:Array<Int>;
    var _note_time_offsets:Array<Float>;
    var _sounds:Array<AudioResource>;

    var _current_time:Float;
    var _note_time:Float;
    var _time_per_bar:Float;
    var _next_note:Int;
    var _test_note_mask:Int;
    var _shift:Int;
    
    public var note_count(default, null):Int;

    public function new(sound_count:Int, tempo:Int, note_count:Int, ?_options:ComponentOptions) 
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
        _shift = 0;
        
        _note_time_offsets = new Array<Float>();
        _note_masks = new Array<Int>();
        _note_masks_shift_amounts = new Array<Int>();        

        this.note_count = note_count;

        _note_time = 60 / (tempo * (note_count / 4));

        _time_per_bar = _note_time * note_count;

        log("min_note_time = " + Luxe.core.update_rate);
        log("_note_time = " + _note_time);        

        if (_note_time < Luxe.core.update_rate)
        {
            _debug("Framerate too low for tempo");
        }

        for (i in 0...note_count)
        {
            _note_time_offsets.push(i * _note_time);
        }

        log(_note_time_offsets);

        // Init sounds

        _sounds = new Array<AudioResource>();

        for (i in 0...sound_count)
        {
            // Set default sounds
            var resource = Luxe.resources.audio('assets/audio/sound_' + i + '.wav');
            _sounds.push(resource);

            // Init note data
            _note_masks.push(0);
            _note_masks_shift_amounts.push(0);
        }

        log(_sounds);

        var rhythm_generator = new EuclidianRhythmGenerator();

        rhythm_generator.generate(this.note_count, 4);
        _note_masks[0] = rhythm_generator.get_bitmask();

        rhythm_generator.generate(this.note_count, 2);
        _note_masks[1] = rhythm_generator.get_bitmask();

        rhythm_generator.generate(this.note_count, 8);
        _note_masks[2] = rhythm_generator.get_bitmask();

        rhythm_generator.generate(this.note_count, 3);
        _note_masks[3] = rhythm_generator.get_bitmask();

        shift(1, 2);
        log(_note_masks);

        super(_options);
    }

    override public function update(dt:Float):Void 
    {
        // log("---------- Sequencer.update.dt ---------- : " + dt); 

        var epsilon = 0.01;

        var min:Float;
        var max:Float;
        var tick:Bool;

        max = _note_time_offsets[_next_note] + epsilon;

        if (_next_note == 0)
        {
            min = _time_per_bar - epsilon;
            tick = _current_time >= min || _current_time <= max;
        }
        else
        {
            min = _note_time_offsets[_next_note] - epsilon;
            tick = _current_time >= min && _current_time <= max;            
        }

        if (tick)
        {
            // _debug("---------- Sequencer.update.tick ---------- : " + _next_note); 

            for (i in 0..._sounds.length)
            {
                if (_note_masks[i] != 0 && should_play_note(i, _next_note))
                {
                    // _debug("Playing sound " + i);

                    var handle = Luxe.audio.play(_sounds[i].source);

                    if (i == 3)
                    {
                        Luxe.audio.volume(handle, 0.1);
                    }
                }
            }

            if (++_next_note == note_count)
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
        MiosisUtilities.clear(_note_time_offsets);
        _note_time_offsets = null;
        
        MiosisUtilities.clear(_note_masks);
        _note_masks = null;       

        for (i in 0..._sounds.length)
        {
            // TODO: Clean up sounds
            // _sounds[i];
        }

        MiosisUtilities.clear(_sounds);
        _sounds = null;
    }

    public function shift(sound_id:Int, amount:Int):Void
    {
        _note_masks[sound_id] = MiosisUtilities.bitwise_right_circular_shift(_note_masks[sound_id], amount, note_count);
    }

    public function get_current_cycle_ratio(sound_id):Float
    {
        return _current_time / _time_per_bar;
    }

    public function get_note_mask(index:Int):Int
    {
        return _note_masks[index];
    }

    function should_play_note(soundIndex:Int, note:Int):Bool
    {
        var msb_mask = 1 << note_count - 1;
        return (_note_masks[soundIndex] & (msb_mask >> note)) > 0;
    }
}
