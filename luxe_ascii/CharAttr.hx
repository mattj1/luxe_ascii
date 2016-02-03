package luxe_ascii;

import luxe.Color;
import snow.api.buffers.*;

class CharAttr {
	public var char:Int;
	
	public var fg(get, set):Color;
	private var _fg:Color;

	public var bg(get, set):Uint8Array;
	private var _bg:Uint8Array;

	public var attr:Int;

	public function new() {
		char = 0;
		_fg = new Color();
		_bg = new Uint8Array(3);
		attr = 0;
	}

	public inline function get_fg():Color {
		return _fg;
	}

	public inline function set_fg(color:Color):Color {
		_fg.r = color.r;
		_fg.g = color.g;
		_fg.b = color.b;
		return _fg;
	}

	public inline function set_bg_color(color:Color):Uint8Array {
		_bg[0] = Std.int(color.r * 255);
		_bg[1] = Std.int(color.g * 255);
		_bg[2] = Std.int(color.b * 255);
		return _bg;
	}

	public inline function set_bg(color:Uint8Array):Uint8Array {
		_bg[0] = color[0];
		_bg[1] = color[1];
		_bg[2] = color[2];		
		return _bg;
	}

	public inline function get_bg():Uint8Array {
		return _bg;
	}
}