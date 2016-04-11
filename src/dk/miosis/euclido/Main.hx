package dk.miosis.euclido;

import luxe.Camera;
import luxe.Color;
import luxe.Input;
import luxe.Log.*;
import luxe.Parcel;
import luxe.Scene;
import luxe.Screen.WindowEvent;
import luxe.Sprite;
import luxe.States;
import luxe.Vector;

import luxe.collision.shapes.Polygon;

import phoenix.Batcher;
import phoenix.Texture.FilterType;

import mint.Canvas;
import mint.focus.Focus;
import mint.render.luxe.LuxeMintRender;

import snow.api.Promise;

import dk.miosis.euclido.component.FadeOverlay;
import dk.miosis.euclido.state.BaseState;
import dk.miosis.euclido.state.Load;
import dk.miosis.euclido.state.Play;
import dk.miosis.euclido.state.Splash;
import dk.miosis.euclido.ui.MiosisCanvas;

class Main extends luxe.Game 
{
    public static var mint_renderer:LuxeMintRender;
    public static var canvas:MiosisCanvas;
    public static var focus: Focus;
    public static var background_batcher: phoenix.Batcher;    
    public static var foreground_batcher: phoenix.Batcher;

    public static var w:Int = -1;
    public static var h:Int = -1;

    var load_state:Load;
    var next_state:String;
    var current_parcel:Parcel;
    var states:States;
    var fade_overlay_sprite:Sprite;
    var fade_overlay:FadeOverlay;  

    override function config(config:luxe.AppConfig) 
    {
        w = config.window.width;
        h = config.window.height;

        config.window.width *= Constants.GAME_SCALE;
        config.window.height *= Constants.GAME_SCALE;

        // Just load assets for the splash screen
        config.preload.textures.push({ id : "assets/img/logo/miosis_m.png", filter_min:nearest, filter_mag:nearest });
        config.preload.textures.push({ id : "assets/img/logo/miosis_i.png", filter_min:nearest, filter_mag:nearest });
        config.preload.textures.push({ id : "assets/img/logo/miosis_s.png", filter_min:nearest, filter_mag:nearest });
        config.preload.textures.push({ id : "assets/img/logo/miosis_o.png", filter_min:nearest, filter_mag:nearest });
        config.preload.jsons.push({ id : "assets/json/animation/miosis_anim.json" });

        return config;
    }

    override function ready() 
    {
        _debug("---------- Main.ready ----------");

        // Set background color
        Luxe.renderer.clear_color = new Color().rgb(Constants.COLOR_GB_2_DARK);

        // Luxe.core.update_rate = 1/240;
        // Luxe.core.frame_max_delta = 1/60;

        // Fit camera viewport to window size
        Luxe.camera.size = new Vector(w, h);
        Luxe.camera.size_mode = luxe.Camera.SizeMode.fit;

        log('Screen width: ${Luxe.screen.w}');
        log('Screen height: ${Luxe.screen.h}');

        // Set up rendering
        var background_camera = new Camera({
            name: 'background_camera'
            });
        background_camera.size = new phoenix.Vector(w, h);
        background_camera.size_mode = luxe.Camera.SizeMode.fit;

        var foreground_camera = new Camera({
            name: 'foreground_camera'
            });
        foreground_camera.size = new phoenix.Vector(w, h);
        foreground_camera.size_mode = luxe.Camera.SizeMode.fit;

        background_batcher = Luxe.renderer.create_batcher({
            layer: -1,
            name:'background_batcher',
            camera: background_camera.view
            });

        foreground_batcher = Luxe.renderer.create_batcher({
            layer: 3,
            name:'foreground_batcher',
            camera: foreground_camera.view
            });

        mint_renderer = new LuxeMintRender({ batcher:foreground_batcher });
        
        // Set up Mint canvas
        canvas = new MiosisCanvas({
            name:'canvas',
            rendering: mint_renderer,
            options: { color:new Color(1, 1, 1, 0) },
            x: 0, y:0, w: 100, h: 100
            });
        canvas.auto_listen();

        focus = new Focus(canvas);

        // Set up fade overlay
        fade_overlay_sprite = new Sprite({
            batcher: foreground_batcher,
            parent: Luxe.camera,
            name: 'fade_overlay_sprite',
            size: Luxe.screen.size,
            color: new Color().rgb(Constants.COLOR_GB_2_DARK),
            centered: false,
            depth:990
            });     
        fade_overlay = fade_overlay_sprite.add(new FadeOverlay());
        
        // Subscribe to state change events
        Luxe.events.listen('change_state', on_change_state);

        // Go to first state
        states = new States({ name:'states' });
        load_state = states.add(new Load());
        states.add(new Play());
        states.add(new Splash());
        next_state = "splash";
        states.set(next_state);

        var state:BaseState = cast states.current_state;
        fade_overlay.fade_in(state.fade_in_time, on_fade_in_done);      
    }

    function on_change_state(e)
    {
        _debug("---------- Main.on_change_state, go to state: " + e.state + "----------");

        next_state = e.state;
        
        if (next_state == 'load')
        {
            current_parcel = e.parcel;
        }
        else
        {
            current_parcel = null;
        }

        var state:BaseState = cast states.current_state;

        if (state.fade_out_time > 0)
        {
            fade_overlay.fade_out(state.fade_in_time, on_fade_out_done);    
        }
        else
        {
            on_fade_out_done();
        }
    }

    function on_fade_in_done()
    {
        _debug("---------- Main.on_fade_in_done ----------");

        var state:BaseState = cast states.current_state;
        state.post_fade_in();
    }

    function on_fade_out_done()
    {
        _debug("---------- Main.on_fade_out_done ----------");

        Luxe.scene.empty();

        // Destroy unused resources
        if (next_state == 'load')
        {
            if (current_parcel == null)
            {// Previous state was splash => assets were loaded in config
                Luxe.resources.destroy("assets/img/logo/miosis_m.png");
                Luxe.resources.destroy("assets/img/logo/miosis_i.png");
                Luxe.resources.destroy("assets/img/logo/miosis_s.png");
                Luxe.resources.destroy("assets/img/logo/miosis_o.png");
                Luxe.resources.destroy("assets/json/miosis_anim.json");
            }
            else
            {// Previous state was not splash => assets were loaded from a parcel
                current_parcel.unload();
            }

            // TODO: Set filename according to some config file
            load_state.state_to_load = 'euclido';
        }

        states.set(next_state);

        var state:BaseState = cast states.current_state;
        fade_overlay.fade_in(state.fade_in_time, on_fade_in_done);
    }

    override function onkeyup(e:luxe.Input.KeyEvent) 
    {
        if(e.keycode == Key.escape) 
        {
            Luxe.shutdown();
        }
    }

    override function onwindowsized( e:WindowEvent ) 
    {
        Luxe.camera.viewport = new luxe.Rectangle(0, 0, e.x, e.y);
    }

    // override function onrender()
    // {
    //     log("Render");
    // }

    override function ondestroy() 
    {
        if (states != null)
        {
            states.destroy();
            states = null;            
        }

        if (current_parcel != null)
        {
            current_parcel.unload();
            current_parcel = null; 
        }

        load_state = null;
        next_state = null;
        fade_overlay_sprite = null;
        fade_overlay = null;
    }
}
