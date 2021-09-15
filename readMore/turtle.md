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

Specific turtle related commands provided from Sketcher class.  
  
- penUp()
- penDown()
- toRadians( degrees )
- left( degrees )
- right( degrees )
- forward( distance ) or fd( distance )
- backward( distance ) or bk( distance )
- circle( radius )
- arc( radius, degrees )
- north()
- west()
- east()
- south()
- heading()
- position()
- setPosition( x, y )
- penSize( w )

