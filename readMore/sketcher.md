# Sketcher - drawing with cornerContour

## Setup a pen
```Haxe
pen2D = new Pen2D( 0xFFFF00FF );
```
## Setup sketcher
we can draw say a triangle.
```Haxe
var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.both );
sketcher.width = 2;
```
## Use sketcher to draw an SVG path
```Haxe
var p = new SvgPath( sketcher );
p.parse( "M150 0 L75 200 L225 200 Z" );
```
## Use sketcher to draw a shape
```Haxe
// a
sketcher.moveTo( 148, 72 );
sketcher.quadThru( 157, 67, 166, 64 );
sketcher.quadThru( 173, 67, 181, 72 );
sketcher.lineTo( 181, 103 );
sketcher.quadThru( 183, 107, 186, 103 );
sketcher.moveTo( 181, 80 );
sketcher.quadThru( 173, 82, 166, 85);
sketcher.quadThru( 155, 90, 148, 101 ); 
sketcher.lineTo( 149, 103 );
sketcher.quadThru( 157, 106, 166, 107 );
sketcher.quadThru( 173, 105, 181, 97 );
```
