package luxe_ascii;

import luxe.Color;
import snow.system.assets.Asset;
import snow.api.buffers.*;

import haxe.io.Bytes;

import rexpaint_loader.*;

class REXLoader {
    public static function toTextBuffer(file:REXPaintLoader.REXPaintFile):TextBuffer {
        
        var xp_width = file.width;
        var xp_height = file.height;

        var textBuffer:TextBuffer = new TextBuffer(xp_width, xp_height);

        for(layerNo in 0 ... file.layers.length) {

            var layer:REXPaintLoader.REXPaintLayer = file.layers[layerNo];

            for(y in 0 ... xp_height) {
                for(x in 0 ... xp_width) {
                    var tile:REXPaintLoader.REXPaintTile = layer.tiles[x * xp_height + y];

                    if( tile.bg_r == 255 && tile.bg_g == 0 && tile.bg_b == 255 ) {
                        if(layerNo == 0) {
                            textBuffer.set_transparent(x, y, true);   
                        }
                        continue;
                    }
                        
                    textBuffer.set_char (x, y, tile.ascii_code);
                    textBuffer.set_transparent(x, y, false);
                    textBuffer.set_fg_color(x, y, new Color(tile.fg_r / 255, tile.fg_g / 255, tile.fg_b / 255, 1.0));
                    textBuffer.set_bg_color(x, y, new Color(tile.bg_r / 255, tile.bg_g / 255, tile.bg_b / 255, 1.0));
                }
            }
        }

        return textBuffer;
    }

    

	public static function load(path:String):TextBuffer {
        
        var compressed_bytes:Uint8Array = Luxe.resources.bytes(path).asset.bytes;
        
        var bytes:Bytes = Bytes.alloc(compressed_bytes.length);
        for(i in 0 ... compressed_bytes.length) {
            bytes.set(i, compressed_bytes[i]);
        }

        trace("compressed_bytes: " + compressed_bytes);

        return toTextBuffer(REXPaintLoader.loadXP(bytes));

        // var rexPaintFile:REXPaintFile = {};
        // rexPaintFile.layers = new Array<REXPaintLayer>();

        // var layer:REXPaintLayer;

        // trace("compressed_bytes: " + compressed_bytes);
        // trace("compressed_bytes.bytes: " + compressed_bytes.bytes); // Uint8Array
        // trace(compressed_bytes.bytes.length); // 242
        
	}
}