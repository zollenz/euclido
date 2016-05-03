package euclido.component;

import luxe.Log.*;
import luxe.Sprite;

import luxe.options.ComponentOptions;

class FadeOverlay extends luxe.Component 
{
    var sprite:Sprite;

    public function new(?_options:ComponentOptions) 
    {
        _debug("---------- FadeOverlay.new ----------");        

        if (_options == null) 
        {
            _options = { name : "fade"};
        } 
        else if (_options.name == null)
        {
            _options.name = "fade";
        }

        super(_options);
    }

    override function onadded() 
    {
        _debug("---------- FadeOverlay.init ----------");

        sprite = cast entity;
        sprite.events.fire('fade_overlay_ready');        
    }

    public function fade_in(?t = 0.15, ?fn:Void->Void) 
    {
        _debug("---------- FadeOverlay.fade_in ----------");

        sprite.color.tween(t, {a:0}).onComplete(fn);
    }

    public function fade_out(?t = 0.15, ?fn:Void->Void) 
    {
        _debug("---------- FadeOverlay.fade_out ----------");
                
        sprite.color.tween(t, {a:1}).onComplete(fn);
    }

    override function onremoved()
    {
        _debug("---------- FadeOverlay.onremoved ----------");
        _debug(entity);
    }

    override function ondestroy() 
    {
        _debug("---------- FadeOverlay.ondestroy ----------");
        _debug(entity);        
    }
}
