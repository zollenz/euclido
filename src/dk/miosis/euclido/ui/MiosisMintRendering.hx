package dk.miosis.euclido.ui;

import luxe.Log.*;

import luxe.options.RenderProperties;

import mint.Button;
import mint.Control;

import mint.render.luxe.LuxeMintRender;

import dk.miosis.euclido.ui.MiosisSliderControl;
import dk.miosis.euclido.ui.MiosisSliderRender;

class MiosisMintRendering extends LuxeMintRender 
{
    // override function get<T:Control, T1>( _type:Class<T>, _control:T ) : T1 
    // {
    //     return cast switch(_type) 
    //     {
    //         case Button: new MiosisButtonRender(this, cast _control);
    //         case _: null;
    //     }
    // }

    override function get<T:Control, T1>( type:Class<T>, control:T ) : T1 {
        return cast switch(type) {
            case mint.Canvas:       new mint.render.luxe.Canvas(this, cast control);
            case mint.Label:        new mint.render.luxe.Label(this, cast control);
            case mint.Button:       new mint.render.luxe.Button(this, cast control);
            case mint.Image:        new mint.render.luxe.Image(this, cast control);
            case mint.List:         new mint.render.luxe.List(this, cast control);
            case mint.Scroll:       new mint.render.luxe.Scroll(this, cast control);
            case mint.Panel:        new mint.render.luxe.Panel(this, cast control);
            case mint.Checkbox:     new mint.render.luxe.Checkbox(this, cast control);
            case mint.Window:       new mint.render.luxe.Window(this, cast control);
            case mint.TextEdit:     new mint.render.luxe.TextEdit(this, cast control);
            case mint.Dropdown:     new mint.render.luxe.Dropdown(this, cast control);            
            case mint.Slider:       new mint.render.luxe.Slider(this, cast control);
            case mint.Progress:     new mint.render.luxe.Progress(this, cast control);
            // Custom
            case MiosisSliderControl:       new MiosisSliderRender(cast this, cast control);            
            case _:                 null;
        }
    }
}