# cornerContour
................
<img width="312" alt="cornerContourWebGLTest" src="https://user-images.githubusercontent.com/20134338/129176704-f2efc633-e5bb-4c81-b6d3-4169be28bbad.png">

A 2D vector drawing library for **Haxe**, can be used directly from [trilateral3](https://github.com/nanjizal/trilateral3) ( it is the core of trilateral ).
It is perhaps most fun to check out the simple raw WebGL experiments, but probably most useful used as just a tool within a cross target games toolkit.
  
## Using cornerContour
- [How cornerContour works](readMore/workings.md#cornercontour-workings)  
  <img width="50" alt="linesTriangleCorners" src="https://user-images.githubusercontent.com/20134338/129178177-05f65df8-c780-40ab-829d-e92e0221fc7c.png">
- [Using Sketcher to draw with code](readMore/sketcher.md#sketcher---drawing-with-cornercontour)  
  ```( lineTo, quadTo.. and svg paths )```
- [Wiring CornerContour with a toolkit](readMore/withCeramic.md#wiring-up-to-toolkit)  
  ```( eg: Ceramic )```
- [Using ShapeXML for creating simple shapes](readMore/shapeXML.md#using-the-svg-shapexml-in-addition-to-path)  
  ```<line x1="50." y1="70." x2="55." y2="76." stroke="0xffFF7F00" stroke_width="5"/>```
- [Turtle graphics](readMore/turtle.md#using-sketcher-with-turtle-style-graphics)  
  ```s.setPosition( 100, 100 ).penSize( 7 ).forward( 30 ).right( 45 ).forward( 30 ).arc( 50, 120 );```
- [Turtle graphics animation > ](https://nanjizal.github.io/turtleAnimation/index.html)
- **LSystem** ?
- [Toolkit support](readMore/toolkits.md)  
  ```Heaps, Ceramic, Kha, Canvas, WebGL ..```
- [Animation](readMore/animation.md)  
  ```( color blend, scale, movement, rotation )```
- [Gradients, wip](readMore/gradients.md)  // lots of fixes made not yet updated runtime sample.
- **texture** ? works needs more info
- [dot dash] basic implementation
    
## Documentation
[ Dox documentation](https://nanjizal.github.io/cornerContour/pages/)
  
## Dependancies

[ ( justPath, fracs ) > ](readMore/dependancies.md)

## Release
[0.0.1-alpha](https://github.com/nanjizal/cornerContour/releases/tag/0.0.1-alpha) pre-release
