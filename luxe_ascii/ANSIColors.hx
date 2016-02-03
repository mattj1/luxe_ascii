package luxe_ascii;

import phoenix.Color;

class ANSIColors {
	private static var colors:Array<Color>;// = new Array<Color>();

	public static function color(c:Int) {
		if(colors == null) {
			colors = new Array<Color>();

	        colors.push(new Color().rgb(0x000000));
	        colors.push(new Color().rgb(0x0000AA));
	        colors.push(new Color().rgb(0x00AA00));
	        colors.push(new Color().rgb(0x00AAAA));

	        colors.push(new Color().rgb(0xAA0000));
	        colors.push(new Color().rgb(0xAA00AA));
	        colors.push(new Color().rgb(0xAA5500));
	        colors.push(new Color().rgb(0xAAAAAA));

	        colors.push(new Color().rgb(0x555555));
	        colors.push(new Color().rgb(0x5555FF));
	        colors.push(new Color().rgb(0x55FF55));
	        colors.push(new Color().rgb(0x55FFFF));

	        colors.push(new Color().rgb(0xFF5555));
	        colors.push(new Color().rgb(0xFF55FF));
	        colors.push(new Color().rgb(0xFFFF55));
	        colors.push(new Color().rgb(0xFFFFFF));
		}
		
		return colors[c];
	}
}