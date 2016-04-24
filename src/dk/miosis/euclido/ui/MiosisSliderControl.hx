package dk.miosis.euclido.ui;

import mint.Control;
import mint.Panel;

import mint.types.Types;
import mint.core.Signal;
import mint.types.Types.Helper;
import mint.core.Macros.*;

import mint.Slider;

@:allow(mint.render.Renderer)
class MiosisSliderControl extends mint.Control 
{
    var options: SliderOptions;

    public var min : Float = 0;
    public var max : Float = 1;
    public var value  (default, set): Float = 1;
    public var percent : Float = 1;
    public var step : Null<Float>;
    public var vertical : Bool = false;
    public var invert : Bool = false;

    var bar_x : Float = 2.0;
    var bar_y : Float = 2.0;
    var bar_w : Float = 0.0;
    var bar_h : Float = 0.0;

    public var onchange: Signal<Float->Float->Void>;

    public function new( _options:SliderOptions ) {

        options = _options;

        def(options.name, 'slider');
        def(options.mouse_input, true);

        max = def(options.max, 1);
        min = def(options.min, 0);
        value = def(options.value, max);
        vertical = def(options.vertical, false);
        invert = def(options.invert, false);
        step = options.step;

        super(options);

        onchange = new Signal();

        renderer = rendering.get(MiosisSliderControl, this);

        oncreate.emit();

        update_value(value);

    } //new

    var dragging = false;

    override function mousedown(e:MouseEvent) {

        super.mousedown(e);

        dragging = true;
        focus();
        update_value_from_mouse(e);

    } //mousedown

    inline function get_range() return max-min;
        
    var ignore_set = true;

    inline function update_value(_value:Float) {

        _value = Helper.clamp(_value, min, max);

        if(step != null) {
            _value = Math.round(_value/step) * step;
        }

        if(vertical) {

            bar_w = w - 4;
            bar_h = (h - 4) * (_value - min) / (max - min);
            bar_y = (!invert) ? ((h - ((h - 4) * (_value - min) / (max - min))) - 2) : 2;
            bar_h = Helper.clamp(bar_h, 1, h - 4);

        } else {

            bar_w = (w - 4) * (_value - min) / (max - min);
            bar_w = Helper.clamp(bar_w, 1, w-4);
            bar_h = h - 4;
            bar_x = (!invert) ? 2 : ((w - ((w - 4) * (_value - min) / (max - min))) - 2);

        }

        percent = _value/get_range();

        ignore_set = true;
            value = _value;
        ignore_set = false;

        onchange.emit(value, percent);

    } // update_bar
    
    inline function set_value(_value:Float):Float {

        if(ignore_set) return value = _value;

        update_value(_value);

        return value;

    } // set_value

    inline function update_value_from_mouse(e:MouseEvent) {

        if(!vertical) {

            var _dx = (!invert) ? e.x - x : (w) - (e.x - x);

            if(_dx < 1) _dx = 1;
            if(_dx >= w-4) _dx = w-4;

            var _v:Float = ((_dx - 1) / (w - 5)) * get_range() + min;

            update_value(_v);

        } else {

            var _dy = (!invert) ? (h) - (e.y - y) : e.y - y;

            if(_dy < 1) _dy = 1;
            if(_dy >= h-4) _dy = h-4;

            var _v:Float = ((_dy - 1) / (h - 5)) * get_range() + min;
                
            update_value(_v);

        } //vertical

    } //update_value

    override function mousemove(e:MouseEvent) {

        if(dragging) {

            update_value_from_mouse(e);

        } //dragging

    } //mousemove

    override function mouseup(e:MouseEvent) {

        dragging = false;
        unfocus();

        super.mouseup(e);

    } //mouseup
}
