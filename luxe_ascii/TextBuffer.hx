package luxe_ascii;

import luxe.Color;
import snow.api.buffers.*;

class TextBuffer {
	
	public var width:Int;
	public var height:Int;

	public var data:Array<CharAttr>;

	public function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;

		data = new Array<CharAttr>();

		for(i in 0 ... width * height) {
			data.push(new CharAttr());
		}
	}

	public function set_char(x:Int, y:Int, ch:Int) {
		if(x < 0 || y < 0 || x >= width || y >= height || ch < 0 || ch > 255)
			return;

		data[y * width + x].char = ch;
	}

	public function set_transparent(x:Int, y:Int, isTransparent:Bool) {
		if(x < 0 || y < 0 || x >= width || y >= height)
			return;

		if(isTransparent)
			data[y * width + x].attr |= 0x02;
		else 
			data[y * width + x].attr &= ~0x02;
	}

	public function set_fg_color(x:Int, y:Int, color:Color) {
		if(x < 0 || y < 0 || x >= width || y >= height)
			return;
		
		data[y * width + x].fg = color;
	}

	public function set_bg_color(x:Int, y:Int, color:Color) {
		if(x < 0 || y < 0 || x >= width || y >= height)
			return;
		
		var bg = data[y * width + x].bg;

		bg[0] = Std.int(color.r * 255);
		bg[1] = Std.int(color.g * 255);
		bg[2] = Std.int(color.b * 255);
	}

	// Draw a TextBuffer onto this one at (xPos, yPos), taking into account transparency.
	public function blit(t:TextBuffer, xPos:Int, yPos:Int) {

	 	var dx:Int, dy:Int;
	 	var src_data:CharAttr, dst_data:CharAttr;

		for(y in 0 ... t.height) {
			dy = y + yPos;
			
			if(dy < 0 || dy >= height)
				continue;

			for(x in 0 ... t.width) {
				dx = x + xPos;
				
				if(dx < 0 || dx >= width)
					continue;

				src_data = t.data[y * t.width + x];
				dst_data = data[dy * width + dx];

				if(src_data.attr & 0x02 != 0)
					continue;

				dst_data.fg = src_data.fg;
				dst_data.char = src_data.char;
				dst_data.bg[0] = src_data.bg[0];
				dst_data.bg[1] = src_data.bg[1];
				dst_data.bg[2] = src_data.bg[2];
				dst_data.attr = src_data.attr;
			}
		}
	}
}