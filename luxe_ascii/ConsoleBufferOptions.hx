package luxe_ascii;

typedef ConsoleBufferOptions = {

	// Buffer dimensions
	var width: Int;
	var height: Int;

	// Font to use
	var fontFile: String;

	// Dimensions of the characters
	var glyph_width: Int;
	var glyph_height: Int;

	// Arragement of characters in the image file
	var glyph_file_columns: Int; 
}