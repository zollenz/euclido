package miosis.ui;

import mint.render.luxe.Convert;

class MiosisCanvas extends mint.Canvas 
{
    public function auto_listen() 
    {
        Luxe.on(luxe.Ev.render,     conv_render);
        Luxe.on(luxe.Ev.update,     conv_update);
        Luxe.on(luxe.Ev.mousewheel, conv_mousewheel);
        Luxe.on(luxe.Ev.mousedown,  conv_mousedown);
        Luxe.on(luxe.Ev.mouseup,    conv_mouseup);
        Luxe.on(luxe.Ev.mousemove,  conv_mousemove);
        Luxe.on(luxe.Ev.keyup,      conv_keyup);
        Luxe.on(luxe.Ev.keydown,    conv_keydown);
        Luxe.on(luxe.Ev.textinput,  conv_textinput);

        ondestroy.listen(auto_unlisten);
    }

    public function auto_unlisten() 
    {
        Luxe.off(luxe.Ev.render,     conv_render);
        Luxe.off(luxe.Ev.update,     conv_update);
        Luxe.off(luxe.Ev.mousewheel, conv_mousewheel);
        Luxe.off(luxe.Ev.mousedown,  conv_mousedown);
        Luxe.off(luxe.Ev.mouseup,    conv_mouseup);
        Luxe.off(luxe.Ev.mousemove,  conv_mousemove);
        Luxe.off(luxe.Ev.keyup,      conv_keyup);
        Luxe.off(luxe.Ev.keydown,    conv_keydown);
        Luxe.off(luxe.Ev.textinput,  conv_textinput);

        ondestroy.remove(auto_unlisten);
    }

    function conv_update(dt:Float)  update(dt);
    function conv_render(_)         render();
    function conv_mousewheel(e)     mousewheel(Convert.mouse_event(e));
    function conv_keyup(e)          keyup(Convert.key_event(e));
    function conv_keydown(e)        keydown(Convert.key_event(e));
    function conv_textinput(e)      textinput(Convert.text_event(e));

    function conv_mouseup(e:luxe.Input.MouseEvent) 
    {
        mouseEventToWorld(e);
        mouseup(Convert.mouse_event(e));  
    }    

    function conv_mousedown(e:luxe.Input.MouseEvent) 
    {
        mouseEventToWorld(e);
        mousedown(Convert.mouse_event(e));  
    }    

    function conv_mousemove(e:luxe.Input.MouseEvent) 
    {
        mouseEventToWorld(e);
        mousemove(Convert.mouse_event(e));  
    }

    function mouseEventToWorld(e:luxe.Input.MouseEvent) 
    {
        e.pos = Luxe.camera.screen_point_to_world(e.pos);
        e.x = Std.int(e.pos.x);
        e.y = Std.int(e.pos.y);
    }
}