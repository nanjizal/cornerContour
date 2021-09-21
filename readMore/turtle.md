## Using Sketcher with turtle style graphics.
  
Sometimes it can be easier to draw using simple turtle graphics. 
Turtle style graphics allows you to define drawing as if your controlling a turtle, with rotation and movement commands,
these commands can be chained together as a sequence:


```Haxe
public function turtleTest(){
       var s = new Sketcher( pen2D, Fine, both );
        s.setPosition( 100, 100 )
            .penSize( 7 )
            .forward( 30 )
            .right( 45 )
            .forward( 30 )
            .arc( 50, 120 );
 }
 ```

Specific turtle related commands provided from Sketcher class, these are designed to be easily chained.
There is a simple repeat that allows non nested multiple repeat of commands.

### Turtle allow draw and move commands.  
- penUp() or penup() or up()
- penDown() or pendown() or down()
- movePen( x, y );

### Change angle of pen, internally it works in radians for commands degrees are used for simplicity
- left( degrees ) or lt( degrees )
- right( degrees ) or turn( degrees ) or rt( degrees )
- north()
- south()
- east()
- west()
- setAngle( degrees )

### Distance movement
- forward( distance ) or fd( distance )
- backward( distance ) or bk( distance )
- setPosition( x, y ) or goto( x, y ) or setposition( x, y ) does not draw.

### Basic shapes
- circle( radius ) normally draws 24 sides, but you can specify different number in second argument 
- arc( radius, degrees ) normally draws 24 sides, but you can specify different number in second argument

### Basic repeat
- repeatBegin( repeatCount ) or loop( repeatCount ) or repeat( repeatCount )
- endRepeat() or loopEnd() or repeatEnd() 

### Forward additions for use in loops
- forwardChange( deltaDistance ) ie +=
- forwardFactor( factor )        ie *=

### Curved Distance, similar to forward, but uses 'distance2' and 'radius' to define a third point relative to the current vector.
- forwardQuadCurve( distance, distance2, radius ) ends up same place as forward but bows using quad bezier
( can also use forwardCurveRight/forwardCurveLeft )
- forwardTriangle( distance, distance2, radius ) ends up same place as forward but triangles from the line
( can also use forwardTriangleRight/forwardTriangleLeft )

### Pen thickness and color
- penSize( width ) or pensize( width )
- penColor( r, g, b ) or pencolor( r, g, b )
- penColorChange( r, g, b )

### Default colors are defined similar to other turtle implementations
- black()
- blue()
- green()
- cyan()
- red()
- magenta()
- yellow()
- white()
- brown()
- lightBrown()
- darkGreen()
- darkishBlue()
- tan()
- plum()
- grey()

### For thickness gradients when using SketcherGrad, untested, second color defaults to 'colorB'
- penColorB( r, g, b )
- penColorC( r, g, b )
- penColorChangeB( r, g, b )
- penColorChangeC( r, g, b )

### Limited support for fill, mostly useful for filling circle, but limited use with curve / triangle related commands
- fillOn() or fillon()
- fillOff() or filloff()

## Non chainable commands just for information
- toRadians( degrees ) converts degrees to radians
- position() provides current position
- heading() provides current angle

