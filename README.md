# cornerContour
<img width="312" alt="cornerContourWebGLTest" src="https://user-images.githubusercontent.com/20134338/129176704-f2efc633-e5bb-4c81-b6d3-4169be28bbad.png">

A 2D vector drawing library for **Haxe**, can be used directly from [trilateral3](https://github.com/nanjizal/trilateral3) ( it is the core of trilateral ).
  
It breaks down lines and curves into triangles for use with your prefered toolkit.

<img width="312" alt="linesTriangleCorners" src="https://user-images.githubusercontent.com/20134338/129178177-05f65df8-c780-40ab-829d-e92e0221fc7c.png">

CornerContour does not provide texture, fills or gradient and focuses on contours. For additional features look at trilateral3 for implemention ideas.
  
( Still considering if shapes like rounded corners should be moved over from trilateral. )
  
## Dependancies
[ justPath ](https://github.com/nanjizal/justPath)
  
```haxelib git justPath https://github.com/nanjizal/justPath.git```
  
[ fracs ](https://github.com/nanjizal/fracs)

```haxelib git justPath https://github.com/nanjizal/fracs.git```

## Usage

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
## Wiring up to toolkit.
So for instance we could wire it up to [Ceramic](https://jeremyfa.com/what-is-ceramic-engine/) toolkit.
```Haxe
    override function create() {
        mesh = new Mesh();
        rearrageDrawData();
        mesh.anchor(0, 0);
        mesh.pos(0, 0);
        mesh.scale( 1 );
        mesh.alpha = 1;
        mesh.colorMapping = VERTICES;
        add(mesh);
    }
    public
    function rearrageDrawData(){
        var pen = pen2D;
        var data = pen.arr;
        var totalTriangles = Std.int( data.size/7 );
        var count = 0;
        for( i in 0...totalTriangles ){
            pen.pos = i;
            var l = mesh.vertices.length;
            mesh.vertices[ l ]     = data.ax;
            mesh.vertices[ l + 1 ] = data.ay;
            mesh.vertices[ l + 2 ] = data.bx;
            mesh.vertices[ l + 3 ] = data.by;
            mesh.vertices[ l + 4 ] = data.cx;
            mesh.vertices[ l + 5 ] = data.cy;
            l = mesh.colors.length;
            mesh.colors[ l ]     = data.color;
            mesh.colors[ l + 1 ] = data.color;
            mesh.colors[ l + 2 ] = data.color;
            l = mesh.indices.length;
            mesh.indices[ l ] = count;
            count++;
            mesh.indices[ l + 1 ] = count;
            count++;
            mesh.indices[ l + 2 ] = count;
            count++;
        }
    }
```
## Using with other graphics toolkits.

- [ drawing with Heaps ](https://github.com/nanjizal/cornerContourHeapsTest)
- [ drawing with Lime ](https://github.com/nanjizal/cornerContourLimeTest)
- [ drawing with Kha ](https://github.com/nanjizal/cornerContourKhaGraphics4Test)
- [ drawing with Ceramic ](https://github.com/nanjizal/cornerContourCeramicTest)
- drawing with OpenFL - still to explore technical details.

## With WebGL, Gluon or Canvas
- [ drawing with WebGL ](https://github.com/nanjizal/cornerContourWebGLTest)
- [ drawing with Canvas ](https://github.com/nanjizal/cornerContourCanvasTest)
- [ drawing with OpenGL ](https://github.com/nanjizal/cornerContourGluonTest)

## Documentation
[ Dox documentation](https://nanjizal.github.io/cornerContour/pages/) needs minor update.


 
