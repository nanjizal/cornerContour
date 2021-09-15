## Animation with cornerContour.
  
The ```ColorTriangles2D``` Float32Array wrapper provides an easy way to modify colors, and positions.  
When drawing we can record the ```start...end``` of the shape, svg or set of draw commands as an ```IteratorRange```.
Then we can change the position or color of the range in the render loop.
  
For instance we define some iterator ranges relating to drawn shapes.   

```haxe
    var birdRange:     IteratorRange;
    var quadRange:     IteratorRange;
    var cubicRange:    IteratorRange;
    var arcRange:      IteratorRange;
    var arcLastRange:  IteratorRange;
```

an example of one drawing the Kiwi svg and storing it's iteratorRange ( birdRange ).  

``` Haxe
    /**
     * draws Kiwi svg
     */
    public
    function birdSVG(){
        var start = Std.int( pen2D.pos );
        var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.both );
        sketcher.width = 2;
        var scaleTranslateContext = new ScaleTranslateContext( sketcher, 20, 0, 1, 1 );
        var p = new SvgPath( scaleTranslateContext );
        p.parse( bird_d );
        birdRange = start...Std.int( pen2D.pos );
    }
```
  
This is a snipit from the WebGL animation test that shows modifying the colorTriangles2D prior to rendering. 
  
```Haxe
arrData.blendBetweenColorRange( 0xcccccc00, 0xFF00ff00
                                      , birdRange, Math.cos( theta/5 ), true );
arrData.moveRangeXY( birdRange, 0.001 * Math.sin( theta ), 0 );
//arrData.rgbRange( quadRange, Std.random( 0xFFFFFF ) );
arrData.alphaRange( arcRange, 0.5 + 0.3*Math.sin( theta - Math.PI/2 ) );
arrData.blendBetweenColorRange( 0xccFF0000, 0xFF0000ff
                                      , quadRange, Math.cos( theta/5 ), true );
arrData.moveRangeXY( arcLastRange, 0, 0.005 * Math.sin( theta - Math.PI/8 ) );
if( first ) {
  arrData.scaleRangeCentre( cubicRange, 1.5 , 1.5 );
}
arrData.rotateRange( quadRange, gx(280), gy(250), Math.PI/100 );
```
  
Color blends allow last parameter for smoothing. Scaling can be from any corner and the centre, api may change.
  
