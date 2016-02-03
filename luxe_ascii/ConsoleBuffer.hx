package luxe_ascii;

import luxe.Color;
import luxe.Rectangle;
import phoenix.Texture;
import phoenix.geometry.QuadGeometry;
import phoenix.geometry.QuadPackGeometry;
import snow.api.buffers.*;
import snow.modules.opengl.GL;

typedef MapTile = {
    quad : Int,
    quad_bg: Int,
    tilex : Int,
    tiley : Int
}

class ConsoleBuffer {

	@:isVar public var buffer_width:Int;
	@:isVar public var buffer_height:Int;
	
	private var bg_tex_width = 128;
    private var bg_tex_height = 128;

    private var tile_texture_w = 8;
    private var tile_texture_h = 14;

    private var geom : QuadPackGeometry;
    private var qg : QuadGeometry;

    private var bg_pixels:Uint8Array;
    private var bg_tex:Texture;

    private var map_tiles : Array< Array<MapTile> >;

	public function new( _options : ConsoleBufferOptions ) {
		this.buffer_width = _options.width;
		this.buffer_height = _options.height;

	    geom = new phoenix.geometry.QuadPackGeometry({
            //texture : Luxe.resources.texture('assets/tileset.png'),
            texture : Luxe.resources.texture(_options.fontFile), //assets/cp437_8x14_terminal.png
            batcher : Luxe.renderer.batcher
        });
        
        geom.texture.filter_min = geom.texture.filter_mag = FilterType.nearest;
        geom.locked = true;
        geom.depth = 1;

        bg_pixels = new Uint8Array(bg_tex_width * bg_tex_height * 3);

        bg_tex = new Texture({id:'bg_tex', width:bg_tex_width, height:bg_tex_height, pixels:bg_pixels, format:GL.RGB});

        qg = new QuadGeometry({
            x:0, y:0, w:buffer_width * 8, h: buffer_height * 14,
            texture: bg_tex,
            batcher : Luxe.renderer.batcher
        });

        qg.uv( new Rectangle(0, 0, buffer_width, buffer_height) );
        qg.texture.filter_min = qg.texture.filter_mag = FilterType.nearest;
        qg.depth = 0;

        generate_tiles();
	}

	function generate_tiles() {
		map_tiles = new Array< Array<MapTile> >();

        var tile_size_w = 8;
        var tile_size_h = 14;

        var tilecx : Int = Math.ceil(Luxe.screen.w / tile_size_w);
        var tilecy : Int = Math.ceil(Luxe.screen.h / tile_size_h);

        var color:Color = new Color(1.0, 0.0, 0.0, 1.0);

        for(_y in 0 ... tilecy) {

            var _row = new Array<MapTile>();
            for(_x in 0 ... tilecx) {
                var _quad = 0;
                var _quad_bg = 0;

                var map_x = _x * tile_size_w;
                var map_y = _y * tile_size_h;

                var _tilex = Std.random(16);
                var _tiley = Std.random(8);


                _quad = geom.quad_add({x:map_x, y:map_y, w:tile_size_w, h:tile_size_h});

                // geom.quad_alpha(_quad, 1.0);

                _row.push( { quad:_quad, quad_bg:_quad_bg, tilex:_tilex, tiley:_tiley } );

            } //_x

            map_tiles.push(_row);

        } //_y

        update_bg();
	}

    public function update_bg() {
        bg_tex.submit(bg_pixels);
    }

    public function blit(t:TextBuffer) {
    	if(t.width > buffer_width || t.height > buffer_height) {
    		trace("Buffer size mismatch");
    		return;
    	}

    	var ch_offs:Int = 0;
    	var char:Int = 0;

    	var bg_offs:Int = 0;

    	var d:CharAttr;

    	for(y in 0 ... t.height) {
    		
    		bg_offs = y * bg_tex_width * 3;

    		for(x in 0 ... t.width) {

    			d = t.data[ch_offs];
    			char = d.char;

    			var tile:MapTile = map_tiles[y][x];

    			tile.tilex = char % 16;
        		tile.tiley = (char - char%16) >> 4;

        		geom.quad_uv(tile.quad, new Rectangle((tile.tilex * tile_texture_w),(tile.tiley * tile_texture_h), tile_texture_w, tile_texture_h) );

        		geom.quad_color(tile.quad, d.fg);

    			bg_pixels[bg_offs ++] = d.bg[0];
    			bg_pixels[bg_offs ++] = d.bg[1];
    			bg_pixels[bg_offs ++] = d.bg[2];


    			ch_offs ++;
    		}
    	}

    	update_bg();
    }
}