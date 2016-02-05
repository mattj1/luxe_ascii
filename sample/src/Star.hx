import luxe_ascii.*;

import luxe.Color;

class Star {
    public var x:Float;
    public var y:Float;
    public var c:Color;
    public var speed:Float;

    public function new() {
        reset();
    }

    public function reset() {
        x = 80 + Std.random(5);
        y = Std.random(25);

        switch(Std.random(3)) {
            case 0:
                c = ANSIColors.color(15);
                speed = -2;
            case 1:
                c = ANSIColors.color(7);
                speed = -1;
            case 2:
                c = ANSIColors.color(1);
                speed = -.5;
        }
    }
}