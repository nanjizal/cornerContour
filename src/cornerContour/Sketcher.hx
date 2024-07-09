package cornerContour;
import justPath.IPathContext;
import cornerContour.CurveMath;
import cornerContour.Contour;
import cornerContour.IContour;
import cornerContour.IPen;
import cornerContour.color.ColorHelp;

typedef Dim = {
    var minX: Float;
    var maxX: Float;
    var minY: Float;
    var maxY: Float;
}
class Sketcher implements IPathContext {
    // used for dash
    public var pwm1 = 10.;
    public var pwm2 = 5.;
    public var pwm3 = 3.;
    public var shortestSeg = 10.;
    var wasMove = false;

    public var x:                   Float = 0.;
    public var y:                   Float = 0.;
    public var penIsDown =          true;
    public var fill =               false;
    public var width:               Float = 0.01;
    public var widthFunction:       Float->Float->Float->Float->Float->Float;
    public var colourFunction:      Int->Float->Float->Float->Float->Int;
    var tempArr:                    Array<Float>;
    public var contour:             IContour;
    public var pen:                 IPen;
    var endLine:                    StyleEndLine;
    var sketchForm:                 StyleSketch;
    public var points:              Array<Array<Float>>;
    public var pointsClock:         Array<Array<Float>>;
    public var pointsAnti:          Array<Array<Float>>;
    public var dim:                 Array<Dim>;
    inline function tracerLine( x_: Float, y_: Float ){
        trace( 'lineTo( $x, $y, $x_, $y_, width )' );
    }
    inline function fillOnlyLine( x_: Float, y_: Float ){
    }
    function baseLine( x_: Float, y_: Float ) {
        tracerLine( x_, y_ );
        crudeLine( x_, y_ );
    }
    inline function crudeLine( x_: Float, y_: Float ){
        contour.line( x, y, x_, y_, width );
    }
    inline function roundEndLine( x_: Float, y_: Float ){
        contour.line( x, y, x_, y_, width, both );
    }
    inline function mediumLine( x_: Float, y_: Float ){
        contour.triangleJoin( x, y, x_, y_, width, false );
    }
    inline function mediumOverlapLine(x_: Float, y_: Float ){
        contour.triangleJoin( x, y, x_, y_, width, false, true );
    }
    inline function fineLine( x_: Float, y_: Float ){
        contour.triangleJoin( x, y, x_, y_, width, true );
    }
    inline function mitreLine( x_: Float, y_: Float ){
        contour.useMitre = true;
        contour.triangleJoin( x, y, x_, y_, width );
    }
    inline function dash( x_:Float, y_:Float ) {
        contour.triangleJoin(x, y, x_, y_, width, false );
    }
    inline function equidistant( x_: Float, y_: Float ) {
        
    }
    inline function fineOverlapLine( x_: Float, y_: Float ){
        contour.triangleJoin( x, y, x_, y_, width, true, true );
    }
    public var line: ( x: Float, y: Float ) -> Void;
    public
    function new( pen_: IPen,  sketchForm_: StyleSketch, endLine_: StyleEndLine = no ){
        pen        = pen_;
        endLine    = endLine_;
        contour    = createContour();
        sketchForm = sketchForm_;
        switch( sketchForm_ ){
            case Tracer:        line = tracerLine;
            case Base:          line = baseLine;
            case Crude:         line = crudeLine;
            case FillOnly:      line = fillOnlyLine;
            case Fine:          line = fineLine;
            case FineOverlap:   line = fineOverlapLine;
            case Medium:        line = mediumLine;
            case MediumOverlap: line = mediumOverlapLine;
            case RoundEnd:      line = roundEndLine;
            case Dash:          line = dash;
            case Equidistant:   line = equidistant;
            case Mitre:         line = mitreLine;
        }
        points = [];
        pointsClock = [];
        pointsAnti = [];
        points[0] = new Array<Float>();
        dim = new Array<Dim>();
    }
    public function createContour(): IContour {
        return new Contour( pen, endLine );
    }
    public function reset(){
        contour = createContour();
        points = [];
        pointsClock = [];
        pointsAnti = [];
        points[0] = new Array<Float>();
        dim = new Array<Dim>();
    }
    public function pointsNoEndOverlap(): Array<Array<Float>> {
        var p: Array<Float>;
        var l: Int;
        var j = 0;
        var pointsClean = new Array<Array<Float>>();
        for( i in 0...points.length ){
            p = points[ i ];
            if( p.length > 2 ) pointsClean[ j++ ] = p; // remove empty arrays by only storing full ones.
        }
        points = pointsClean;
        for( i in 0...points.length ){
            p = points[ i ];
            l = p.length;
            var repeat = ( p[ 0 ] == p[ l - 2 ] && p[ 1 ] == p[ l - 1 ] );
            if( repeat ){
                points[ i ].pop();
                points[ i ].pop();
                l -= 2;
            }
        }
        return points;
    }
    public function pointsRewound(): Array<Array<Float>> {
        var p: Array<Float>;
        var l: Int;
        var j = 0;
        var pointsClean = new Array<Array<Float>>();
        for( i in 0...points.length ){
            p = points[ i ];
            if( p.length > 2 ) pointsClean[ j++ ] = p; // remove empty arrays by only storing full ones.
        }
        points = pointsClean;
        
        for( i in 0...points.length ){
            p = points[ i ];
            l = p.length;
            
            var repeat = ( p[ 0 ] == p[ l - 2 ] && p[ 1 ] == p[ l - 1 ] );
            if( repeat ){
                points[ i ].pop();
                points[ i ].pop();
                l -= 2;
            }
            
            var cc = 0.;
            var k = 0;
            var x1: Float;
            var y1: Float;
            var x2: Float;
            var y2: Float;
            var last = l-2;
            while( k < l ){
                x1 = p[ k ];
                y1 = p[ k + 1 ];
                if( k == last ){
                    x2 = p[ 0 ];
                    y2 = p[ 1 ];
                } else {
                    x2 = p[ k + 2 ];
                    y2 = p[ k + 3 ];
                }
                cc += ( x2 - x1 ) * ( y2 + y1 );
                k += 2;
            }
            points[ i ] = p;
        }
        return points;
    }
    public var mitreLimit( never, set ): Float;
    inline function set_mitreLimit( v: Float ): Float {
        contour.mitreLimit = v;
        return v;
    }
    inline function initDim(): Dim{
        return { minX: Math.POSITIVE_INFINITY, maxX: Math.NEGATIVE_INFINITY, minY: Math.POSITIVE_INFINITY, maxY: Math.NEGATIVE_INFINITY };
    }
    inline function updateDim( x: Float, y: Float ){
        var d = dim[ dim.length - 1 ];
        if( x < d.minX ) d.minX = x;
        if( x > d.maxX ) d.maxX = x;
        if( y < d.minY ) d.minY = y;
        if( y > d.maxY ) d.maxY = y;
    }
    public inline
    function moveTo( x_: Float, y_: Float ): Void {
        wasMove = true;
        if( endLine.isEndSymetrical ) contour.end( width );
        x = x_;
        y = y_;
        var l = points.length;
        points[ l ] = new Array<Float>();
        points[ l ][0] = x_;
        points[ l ][1] = y_;
        //if( contour.pointsClock.length != 0 ) {
            // contour.endEdges();
            pointsClock[ pointsClock.length ] = contour.pointsClock.copy();
            pointsAnti[ pointsAnti.length ] = contour.pointsAnti.copy();
            //}
        dim[ dim.length ] = initDim();
        updateDim( x_, y_ );
        contour.reset(); // TODO: needs improving
    }
    public inline
    function lastClock(){
        if( contour.pointsClock.length != 0 ) {
            // contour.endEdges();
            pointsClock[ pointsClock.length ] = contour.pointsClock.copy();
            pointsAnti[ pointsAnti.length ] = contour.pointsAnti.copy();
        }
        // contour.reset();?
    }
    // collates edges
    public inline
    function getEdges(): Array<Array<Float>> {
        var edges = new Array<Array<Float>>();// ideally consider sizing this?
        var no    = pointsClock.length;
        if( no > pointsAnti.length ) no = pointsAnti.length;
        var pClock: Array<Float>;
        var pAnti:  Array<Float>;
        var shape:  Array<Float>;
        for( s in 0...no ){
            pClock      = pointsClock[ s ];
            pAnti       = pointsAnti[ s ];
            var lc      = pClock.length;
            var la      = pAnti.length;
            edges[ s ]  = new Array<Float>();// ideally consider sizing this? lc + la
            shape       = edges[ s ];
            for( i in 0...lc ) shape[ i ] = pClock[ i ];
            var j       = shape.length;
            var l5      = Std.int( la/2 );
            for( i in 0...l5 ){ // add in reverse order
                shape[ j + i*2 ]     = pAnti[ la - i*2 - 1 ]; // put x below y
                shape[ j + i*2 + 1 ] = pAnti[ la - i*2 ];
            }
            j = shape.length;
            shape[ j++ ] = pClock[ 0 ];  // join up would be better to put Anti on front?
            shape[ j   ] = pClock[ 1 ];
        }
        return edges;
    }
    inline 
    function argbAlpha( color: Int, alpha: Float = 1. ) {
        if( alpha != 1. ) color = colorAlpha( color, alpha ); 
        pen.currentColor = color;
    }
    public inline
    function lineStyle( thickness: Float, color: Int, alpha: Float = 1. ): Void {
        width = thickness;
        argbAlpha( color, alpha );
    }
    var distTotal = 0.;
    
    function dashCurveTo( x_: Float, y_: Float ){
        var repeat = ( x == x_ && y == y_ ); 
        if( !repeat ){ // this does not allow dot's to be created using lineTo can move beyond lineTo if it seems problematic.
            if( widthFunction != null ) width = widthFunction( width, x, y, x_, y_ );
            if( colourFunction != null ) pen.currentColor = colourFunction( pen.currentColor, x, y, x_, y_ );
        shortLine( x_, y_ );
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
    inline
    function shortLine( x_: Float, y_: Float ){
        var x1 = x_;
        var y1 = y_;
        var xx = x - x_;
        var yy = y - y_;
        var a1 = Math.atan2( yy, xx ) - Math.PI;
        var sin = Math.sin( a1 );
        var cos = Math.cos( a1 );
        var dist = if( sin != 0 ) {
            -( yy )/sin;
        } else {
            if( cos != 0 ){
                -( xx )/cos;
            } else {
                0.;
            }
        }
        distTotal += dist;
        
        switch( toggle3 ){
            case 0:
                if( pwmToggle ){
                    line( x_, y_ );
                    if( distTotal > pwm1 ){
                       toggle3++;
                       pwmToggle = !pwmToggle;
                       distTotal = 0.;
                    }
                } else {
                    line( x_, y_ );
                    if( distTotal > pwm2 ){
                        toggle3++;
                        pwmToggle = !pwmToggle;
                        distTotal = 0.;
                     }
                }
            case 1:
                moveTo( x_, y_ );
                if( distTotal > pwm3 + width/2 ){
                    toggle3++;
                    distTotal = 0.;
                 }
            case _: 
                moveTo( x_, y_ );
                if( distTotal > pwm3 + width/2 ){
                    
                    distTotal = 0.;
                    if( toggle3 == 2 ) toggle3 = 0;
                 }
        }
    }
    var toggle3 = 0;
    var pwmToggle = true;
    var pz = 0.;
    inline
    function dashTo( x_: Float, y_: Float ): Void {
        var x1 = x_;
        var y1 = y_;
        var xx = x - x_;
        var yy = y - y_;
        var a1 = Math.atan2( yy, xx ) - Math.PI;
        var sin = Math.sin( a1 );
        var cos = Math.cos( a1 );
        var dx1 = pwm1*cos;
        var dy1 = pwm1*sin;
        var dx2 = pwm2*cos;
        var dy2 = pwm2*sin;
        var dx3 = pwm3*cos;
        var dy3 = pwm3*sin;
        var dist = if( sin != 0 ) {
            -( yy )/sin;
        } else {
            if( cos != 0 ){
                -( xx )/cos;
            } else {
                0.;
            }
        }
        if( dist < shortestSeg ){
            shortLine( x_, y_ );
        } else {
        distTotal += dist; 
        dist = dist - pwm2;
        var px = x;
        var py = y;
        var pz = 0.;
        px = px + dx2;
        py = py + dy2;
        moveTo( px, py );
        while( pz < dist ){
            if( toggle3 == 0 ) {
                
                if( pwmToggle ){
                    pz += pwm1;
                    px = px + dx1;
                    py = py + dy1;
                    pwmToggle = !pwmToggle;
                    line( px, py );
                    if( ( pz - pwm1 ) > dist ) {
                        distTotal = 0.;
                        break;
                    }
                } else {
                    pz += pwm3;
                    px = px + dx3;
                    py = py + dy3;
                    pwmToggle = !pwmToggle;
                    line( px, py );
                    if( ( pz - pwm3 ) > dist ) {
                        distTotal = 0.;
                        break;
                    }
                }
                
            } else {
                if( toggle3 == 1 ){
                    pz += pwm1;
                    px = px + dx1;
                    py = py + dy1;
                    if( ( pz - pwm1 ) > dist + width/2 ) {
                        distTotal = 0.;
                        break;
                    }
                } else {
                    pz += pwm2;
                    px = px + dx2;
                    py = py + dy2;
                    if( ( pz - pwm2 ) > dist + width/2 ) {
                        distTotal = 0.;
                        break;
                    }
                }
                moveTo( px, py );
            }
            toggle3++;
            if( toggle3 == 2 ) toggle3 = 0;
        }
        moveTo( x_, y_ );
        x = x1;
        y = y1;
        }
    }
    public
    function lineTo( x_: Float, y_: Float ): Void {
        //var repeat = false;//( x == x_ && y == y_ ); // added for poly2tryhx it does not like repeat points!
        var repeat = ( x == x_ && y == y_ ); 
        if( !repeat ){ // this does not allow dot's to be created using lineTo can move beyond lineTo if it seems problematic.
            if( widthFunction != null ) width = widthFunction( width, x, y, x_, y_ );
            if( colourFunction != null ) pen.currentColor = colourFunction( pen.currentColor, x, y, x_, y_ );
            // allows dot dash lines
            if( sketchForm == Dash ){
                dashTo( x_, y_ );
            } else {
                line( x_, y_ );
            }
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
    
    public inline
    function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        tempArr = [];
        quadCurve( tempArr, x, y, x1, y1, x2, y2 );
        if( sketchForm == Dash ){
            var j = 0;
            var l = Std.int( tempArr.length/2 );
            for( i in 1...l ){
                j = i*2;
                dashCurveTo( tempArr[j], tempArr[j+1] );
            } 
        } else {
            plotCoord( tempArr, false );
        }
        x = x2;
        y = y2;
    }
    // x1,y1 is a point on the curve rather than the control point, taken from my divtatic project.
    public inline
    function quadThru( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        var newx = 2*x1 - 0.5*( x + x2 );
        var newy = 2*y1 - 0.5*( y + y2 );
        return quadTo( newx, newy, x2, y2 );
    }
    var counter = 0;
    public inline
    function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        tempArr = [];
        cubicCurve( tempArr, x, y, x1, y1, x2, y2, x3, y3 );
        if( sketchForm == Dash ){
            var j = 0;
            var l = Std.int( tempArr.length/2 );
            for( i in 1...l ){
                j = i*2;
                dashCurveTo( tempArr[j], tempArr[j+1] );
            } 
        } else {
            plotCoord( tempArr, false );
        }
        x = x3;
        y = y3;
    }
    public inline
    function plotCoord( arr: Array<Float>, ?withMove: Bool = true ): Void {
        var l = arr.length;
        var i = 2;
        if( withMove ){ // normally when just plotting points you will do it withMove but from a curve not.
            moveTo( arr[ 0 ], arr[ 1 ] );
        } else {
            lineTo( arr[ 0 ], arr[ 1 ] );
        }
        
        var cx = (arr[0] + arr[l-2])/2;
        var cy = (arr[1] + arr[l-1])/2;
        var ox = x;
        var oy = y;
        while( i < l ){
            if( fill && penIsDown ){
                if( i > 0 && i < l-2 ) pen.triangle2DFill( arr[i-2],arr[i-1], arr[i], arr[i+1],cx, cy );
            }
            lineTo( arr[ i ], arr[ i + 1 ] );
            i += 2;
        }
        
        if( fill && penIsDown ){
            moveTo( ox, oy );
            lineTo( arr[l-2], arr[l-1] );
        }
        
    }
     /**
      * Useful method for calculating angle for pentagrams or other similar stars.
      * works for 7+ sides, perhaps more work required.
      */
     public inline static
     function sidetaGram( sides: Int ){
         return 4.*(90.-360./sides);
     }
}
