import luxe.Color;
import luxe.Input;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.States;
import snow.types.Types;

class Main extends luxe.Game {

    override function config(config:luxe.AppConfig) {

        return config;

    } //config

    override function ready() {
        var parcel = new Parcel({
            textures : [
                { id : "assets/charmaps/cp437_8x14_terminal.png" }
            ],
            bytes : [
                { id : "assets/xp/luxe_ascii_logo.xp" }
            ]
        });

        new ParcelProgress({
            parcel: parcel,
            background: new Color(0.15, 0.15, 0.15, 1),
            oncomplete: assetsLoaded
        });
    
        parcel.load();

    } //ready

    function assetsLoaded(_) {
        Luxe.update_rate = 1 / 30;

        var state:States;
        state = new States({ name:'machine' });
        state.add( new Demo() );
        state.set('demo');
    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(dt:Float) {

    } //update
} //Main