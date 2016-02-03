package luxe_ascii;

import luxe.Color;
import snow.api.buffers.*;

class CharAttr {
	public var char:Int;
	public var fg:Color;
	public var bg:Uint8Array;
	public var attr:Int;

	public function new() {
		char = 0;
		fg = new Color();
		bg = new Uint8Array(3);
		attr = 0;
	}
}