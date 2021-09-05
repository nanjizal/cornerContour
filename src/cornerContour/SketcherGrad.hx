package cornerContour;

class SketcherGrad extends Sketcher {
    public var colourFunctionB:      Int->Float->Float->Float->Float->Int;
    public var colourFunctionC:      Int->Float->Float->Float->Float->Int;
    override
    public function createContour(): IContour {
        return new ContourGrad( pen, endLine );
    }
    override
    public inline 
    function lineTo( x_: Float, y_: Float ): Void{
        var repeat = ( x == x_ && y == y_ ); // added for poly2tryhx it does not like repeat points!
        if( !repeat ){ // this does not allow dot's to be created using lineTo can move beyond lineTo if it seems problematic.
            if( widthFunction != null ) width = widthFunction( width, x, y, x_, y_ );
            if( colourFunction != null ) pen.currentColor = colourFunction( pen.currentColor, x, y, x_, y_ );
            if( colourFunctionB != null ) pen.colorB = colourFunctionB( pen.colorB, x, y, x_, y_ );
            if( colourFunctionC != null ) pen.colorC = colourFunctionC( pen.colorC, x, y, x_, y_ );
            line( x_, y_ ); 
            var l = points.length;
            var p = points[ l - 1 ];
            var l2 = p.length;
            p[ l2 ]     = x_;
            p[ l2 + 1 ] = y_;
            updateDim( x_, y_ );
            x = x_;
            y = y_;
        }
    }
}