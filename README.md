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

## Using cornerContour
- [Using Sketcher to draw with code](readMore/sketcher.md#sketcher---drawing-with-cornercontour)
- [Wiring CornerContour with a toolkit ( eg: Ceramic )](readMore/withCeramic.md#wiring-up-to-toolkit)

## Documentation
[ Dox documentation](https://nanjizal.github.io/cornerContour/pages/)
  
  
  
## Using the svg ShapeXML in addition to Path.
  
  
<img width="250" alt="ceramicWithSVGShapes" src="https://user-images.githubusercontent.com/20134338/130990212-afcf00cc-a2b6-4dd8-a879-e62f2d0496bf.png">
  
  
### With ShapeXML you can define shapes as XML.
```Haxe
    var rect1: ShapeXML = '<rect x="10" y="10" width="30" height="30" fill="0xffFF0000"/>';
    var rect3: ShapeXML = '<rect x="100" y="10" width="30" height="30" stroke="0xffffc000" stroke_width="5"/>';
    var rect2: ShapeXML = '<rect x="60" y="10" rx="10" ry="10" width="50" height="30" stroke="0xff000000" fill="0xffff0000" stroke_width="5"/>';
    var circle1: ShapeXML = '<circle cx="25" cy="75" r="20" stroke="0xffFF0000" fill="0xff00ff00" stroke_width="5"/>';
    var ellipse1: ShapeXML = '<ellipse cx="75" cy="75" rx="20" ry="5" stroke="0xffFF0000" fill="0xff0000ff" stroke_width="5"/>';
    var line1: ShapeXML = '<line x1="50." y1="70." x2="55." y2="76." stroke="0xffFF7F00" stroke_width="5"/>';
    var polyline1: ShapeXML = '<polyline points="60,110 65,120 70,115 75,130 80,125 85,140 90,135 95,150 100,145" stroke="0xffFF7F00" stroke_width="3"/>';
    var polygon1: ShapeXML = '<polygon points="50,160 55,180 70,180 60,190 65,205 50,195 35,205 40,190 30,180 45,180" stroke="0xffFF0f0f" fill="0xff00ff00" stroke_width="1"/>';
```

### Then you can use them fairly simply by just **draw( pen )** with them.
``` Haxe
        pen2D = new Pen2D( 0xFF0000FF );
        rect1.draw( pen2D );
        rect3.draw( pen2D );
        // offset x, offset y, scale x, scale y, scale thickness
        rect2.draw( pen2D, 50., 0., 5., 5. );
        circle1.draw( pen2D, 20., 50., 2., 2. );
        ellipse1.draw( pen2D,0,0,3,3 );
        line1.draw( pen2D, 0.,0.,10.,30. );
        line1.draw( pen2D, 0.,0.,20.,10. );
        polyline1.draw( pen2D, 0.,0.,3.,3. );
        polygon1.draw( pen2D, 0., 0., 2, 2 );
 ```
 
