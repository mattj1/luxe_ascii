import luxe.States;
import luxe_ascii.*;

class Demo extends State {
	var consoleBuffer:ConsoleBuffer;

    var textBuffer:TextBuffer;

    var sprite_logo:TextBuffer;

    var stars:Array<Star>;

    public function new() {
        super({name:'demo'});

        // The ConsoleBuffer manages the geometry that renders the ASCII console
        consoleBuffer = new ConsoleBuffer( { 
        	width: 80, 
        	height: 25, 
        	fontFile:'assets/charmaps/cp437_8x14_terminal.png', 
        	glyph_width: 8, 
        	glyph_height:14, 
        	glyph_file_columns:16
        });      

        // 
        textBuffer = new TextBuffer(80, 25);

        sprite_logo = REXLoader.load('assets/xp/luxe_ascii_logo.xp');

        stars = new Array<Star>();
        for(i in 0 ... 40) {
            var s:Star = new Star();
            s.x = Std.random(80);
            stars.push(s);
        }
    }

    override function update(dt:Float) {

    	// Update the starfield
        for(s in stars) {
            s.x += s.speed;
            if(s.x < 0) s.reset();
        }

        // Clear the buffer
		textBuffer.clear(ANSIColors.color(0));

		// Draw the starfield
		for(s in stars) {
            textBuffer.set_char(Std.int(s.x), Std.int(s.y), 7); 
            textBuffer.set_fg_color(Std.int(s.x), Std.int(s.y), s.c);
        }

        // Draw the title image
    	textBuffer.blit(sprite_logo, Std.int(textBuffer.width / 2 - sprite_logo.width / 2), 5);

    	// Update the displayed geometry
    	consoleBuffer.blit(textBuffer);
    }
}