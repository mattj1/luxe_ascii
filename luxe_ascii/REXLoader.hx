package luxe_ascii;

import luxe.Color;
import snow.system.assets.Asset;

class REXLoader {
	public static function load(path:String):TextBuffer {
        
        var compressed_bytes = Luxe.resources.bytes(path).asset;

        trace("compressed_bytes: " + compressed_bytes);
        trace("compressed_bytes.bytes: " + compressed_bytes.bytes); // Uint8Array
        trace(compressed_bytes.bytes.length); // 242
        
        var b2 = haxe.io.Bytes.alloc(Std.int(compressed_bytes.bytes.length));
        for(i in 0 ... compressed_bytes.bytes.length) {
            b2.set(i, compressed_bytes.bytes[i]);
        }

        var tmp = new haxe.io.BytesOutput();
        var gz = new format.gz.Reader(new haxe.io.BytesInput(b2));
        gz.readHeader();
        gz.readData(tmp);

        var b:haxe.io.Bytes = tmp.getBytes();

        var p:Int = 0;
        var xp_version = b.getInt32(p); p += 4;
        var xp_layers = b.getInt32(p); p += 4;

        trace("Version: " + xp_version);
        trace("Number of layers: " + xp_layers);

        var textBuffer:TextBuffer = null;

        for(layerNo in 0 ... xp_layers) {
            var xp_width = b.getInt32(p); p += 4;
            var xp_height = b.getInt32(p); p += 4;
            
            if(textBuffer == null) {
            	textBuffer = new TextBuffer(xp_width, xp_height);
            }

            trace("Width: " + xp_width);
            trace("Height: " + xp_height);
        
            for(x in 0 ... xp_width) {
                for(y in 0 ... xp_height) {
                    var ascii_code = b.getInt32(p); p += 4;
                    var fg_r = b.get(p); p += 1;
                    var fg_g = b.get(p); p += 1;
                    var fg_b = b.get(p); p += 1;
                    var bg_r = b.get(p); p += 1;
                    var bg_g = b.get(p); p += 1;
                    var bg_b = b.get(p); p += 1;

                    if( bg_r == 255 && bg_g == 0 && bg_b == 255 ) {
                        if(layerNo == 0) {
                            textBuffer.set_transparent(x, y, true);   
                        }
                        continue;
                    }
                        
                    textBuffer.set_char (x, y, ascii_code);
                    textBuffer.set_transparent(x, y, false);
                    textBuffer.set_fg_color(x, y, new Color(fg_r / 255, fg_g / 255, fg_b / 255, 1.0));
                    textBuffer.set_bg_color(x, y, new Color(bg_r / 255, bg_g / 255, bg_b / 255, 1.0));
                }
            }
        }

        return textBuffer;
	}
}