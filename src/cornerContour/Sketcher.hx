package cornerContour;
import justPath.IPathContext;
import cornerContour.CurveMath;
import cornerContour.Contour;
import cornerContour.IContour;
import cornerContour.IPen;

typedef Dim = {
    var minX: Float;
    var maxX: Float;
    var minY: Float;
    var maxY: Float;
}
class Sketcher implements IPathContext {
    var x:                          Float = 0.;
    var y:                          Float = 0.;
    public var width:               Float = 0.01;
    public var widthFunction:       Float->Float->Float->Float->Float->Float;
    public var colourFunction:      Int->Float->Float->Float->Float->Int;
    var tempArr:                    Array<Float>;
    public var contour:             IContour;
    public var pen:                        IPen;
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
    inline function fineOverlapLine( x_: Float, y_: Float ){
        contour.triangleJoin( x, y, x_, y_, width, true, true );
    }
    public var line: ( x: Float, y: Float ) -> Void;
    public
    function new( pen_: IPen,  sketchForm_: StyleSketch, endLine_: StyleEndLine = no ){
        rotation = -Math.PI/2; // North
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
        if( endLine == end || endLine == both ) contour.end( width );
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
    public
    function lineTo( x_: Float, y_: Float ): Void{
        var repeat = ( x == x_ && y == y_ ); // added for poly2tryhx it does not like repeat points!
        if( !repeat ){ // this does not allow dot's to be created using lineTo can move beyond lineTo if it seems problematic.
            if( widthFunction != null ) width = widthFunction( width, x, y, x_, y_ );
            if( colourFunction != null ) pen.currentColor = colourFunction( pen.currentColor, x, y, x_, y_ );
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
    public inline
    function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        tempArr = [];
        quadCurve( tempArr, x, y, x1, y1, x2, y2 );
        plotCoord( tempArr, false );
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
        plotCoord( tempArr, false );
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
    ////////////////////////////////////
    /// Some turtle command helpers. ///
    ////////////////////////////////////
    
    // Turtle code for repeating, currently not supporting nesting, but maybe nice in future.
    // nested would likley need more complex Array structures.
    var penIsDown =                 true;
    var rotation:                   Float = 0.;
    var lastDistance = 0.;
    var fill = false;
    var repeatCount      = 0;
    var repeatCommands   = false;
    var turtleCommands   = new Array<TurtleCommand>();
    var turtleParameters = new Array<Float>();
    public var turtleHistoryOn: Bool;
    var historyCommands  = new Array<TurtleCommand>();
    var historyParameters = new Array<Float>();
    /**
     * currently very limited,
     * only used for circle, arc sort of and forwardTriangle/forwardCurve
     */
    public function traceHistory(){
        trace( historyCommands );
        trace( historyParameters );
    }
    public
    function playHistory( start = 0, end = - 1 ){
        playCommands( historyCommands, historyParameters, start, end );
    }
    public
    function playCommands( commands: Array<TurtleCommand>, parameters: Array<Float>, start = 0, end = -1 ){
        if( end == -1 ) end = commands.length;
        var v = parameters;
        var j: Int = 0;
        turtleHistoryOn = false;
        for( i in start...end ){
            var command: TurtleCommand = commands[ i ];
            trace( command );
            trace( v[ j ] );
            switch ( command ){
                case FORWARD:
                    forward( v[ j ] );
                    j++;
                case FORWARD_CHANGE:
                    forwardChange( v[ j ] );
                    j++;
                case FORWARD_FACTOR:
                    forwardFactor( v[ j ] );
                    j++;
                case BACKWARD:
                    backward( v[ j ] );
                    j++;
               case PEN_UP:
                   penUp();
               case PEN_DOWN:
                   penDown();
               case LEFT:
                   left( v[ j ] );
                   j++;
               case RIGHT:
                   right( v[ j ] );
                   j++;
               case SET_ANGLE:
                   setAngle( v[ j ] );
                   j++;
               case NORTH:
                   north();
               case SOUTH:
                   south();
               case WEST:
                   west();
               case EAST:
                   east();
               case SET_POSITION:
                   setPosition( v[ j ], v[ j + 1 ] );
                   j += 2;
               case PEN_SIZE:
                   penSize( v[ j ] );
                   j++;
               case PEN_SIZE_CHANGE:
                   penSizeChange( v[ j ] );
                   j++;
               case PEN_SIZE_FACTOR:
                   penSizeFactor( v[ j ] );
                   j++;
               case CIRCLE:
                   circle( v[ j ] );
                   j++;
               case CIRCLE_SIDES:
                   circle( v[ j ], v[ j + 1 ] );
                   j += 2;
               case ARC:
                   arc( v[ j ], v[ j + 1 ] );
                   j += 2;
               case ARC_SIDES:
                   arc( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case MOVE_PEN:
                   movePen( v[ j ] );
                   j++;
               case FORWARD_TRIANGLE_RIGHT:
                   forwardTriangleRight( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case FORWARD_TRIANGLE_LEFT:
                   forwardTriangleLeft( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case FORWARD_CURVE_RIGHT:
                   forwardCurveRight( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case FORWARD_CURVE_LEFT:
                   forwardCurveLeft( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case FILL_ON:
                   fillOn();
               case FILL_OFF:
                   fillOff();
               case BLACK:
                   black();
               case BLUE:
                   blue();
               case GREEN:
                   green();
               case CYAN:
                   cyan();
               case RED:
                   red();
               case MAGENTA:
                   magenta();
               case YELLOW:
                   yellow();
               case WHITE:
                   white();
               case BROWN:
                   brown();
               case LIGHT_BROWN:
                   lightBrown();
               case DARK_GREEN:
                   darkGreen();
               case DARKISH_BLUE:
                   darkishBlue();
               case TAN:
                   tan();
               case PLUM:
                   plum();
               case ORANGE:
                   orange();
               case GREY:
                   grey();
               case PEN_COLOR:
                   penColor( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case PEN_COLOR_CHANGE:
                   penColorChange( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case PEN_COLOR_B: // used for gradient ( default second color )
                   penColorB( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case PEN_COLOR_CHANGE_B:
                   penColorChangeB( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;   
               case PEN_COLOR_C: // used for gradient not mostly used, even then.
                   penColorC( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case PEN_COLOR_CHANGE_C:
                   penColorChangeC( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case BEGIN_REPEAT:
                   beginRepeat( v[ j ] );
                   j++;
               case END_REPEAT:
                   repeatEnd();
            }
        }
    }
    public inline
    function fillOn(): Sketcher {
        if( turtleHistoryOn ) historyCommands.push( FILL_ON );
        if( repeatCommands ){
            turtleCommands.push( FILL_ON );
        } else {
            
            fill = true;
        }
        return this;
    }
    public inline
    function fillon(): Sketcher {
        return fillOn();
    }
    public inline
    function fillOff(): Sketcher {
        if( turtleHistoryOn ) historyCommands.push( FILL_OFF );
        if( repeatCommands ){
            turtleCommands.push( FILL_OFF );
        } else {
            
            fill = false;
        }
        return this;
    }
    public inline
    function filloff(): Sketcher {
        return fillOff();
    }
    public inline
    function penUp(): Sketcher {
        if( turtleHistoryOn ) historyCommands.push( PEN_UP );
        if( repeatCommands ){
            turtleCommands.push( PEN_UP );
        } else {
            
            penIsDown = false;
        }
        return this;
    }
    public inline
    function penup(): Sketcher {
        return penUp();
    }
    public inline
    function up(): Sketcher {
        return penUp();
    }
    public inline
    function penDown(): Sketcher {
        if( turtleHistoryOn ) historyCommands.push( PEN_DOWN );
        if( repeatCommands ){
            turtleCommands.push( PEN_DOWN );
        } else {
            
            penIsDown = true;
        }
        return this;
    }
    public inline
    function pendown(): Sketcher {
        return penDown();
    }
    public inline
    function down(): Sketcher {
        return penDown();
    }
    public inline
    function toRadians( degrees: Float ): Float {
        return degrees*Math.PI/180;
    }
    public inline
    function left( degrees: Float ): Sketcher {
        if( turtleHistoryOn ) {
                historyCommands.push( LEFT );
                historyParameters.push( degrees );
            }
        if( repeatCommands ){
            turtleCommands.push( LEFT );
            turtleParameters.push( degrees );
        } else {
            
            rotation -= toRadians( degrees );
        }
        return this;
    }
    public inline
    function lt( degrees: Float ): Sketcher {
        return left( degrees );
    }
    public inline
    function right( degrees: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( RIGHT );
                historyParameters.push( degrees );
            }
        if( repeatCommands ){
            turtleCommands.push( RIGHT );
            turtleParameters.push( degrees );
        } else {
            
            rotation += toRadians( degrees );
        }
        return this;
    }
    public inline
    function turn( degrees: Float ): Sketcher {
        return right( degrees );
    }
    public inline
    function rt( degrees: Float ): Sketcher {
        return right( degrees );
    }
    public inline
    function setAngle( degrees: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( SET_ANGLE );
                historyParameters.push( degrees );
            }
        
        if( repeatCommands ){
            turtleCommands.push( SET_ANGLE );
            turtleParameters.push( degrees );
        } else {
            
            rotation = -Math.PI/2;
            rotation += toRadians( degrees );
        }
        return this;
    }
    public inline
    function forward( distance: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( FORWARD );
                historyParameters.push( distance );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD );
            turtleParameters.push( distance );
        } else {
            
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                lastDistance = distance;
                lineTo( nx, ny );
            } else {
                moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function forwardChange( deltaDistance: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( FORWARD_CHANGE );
                historyParameters.push( deltaDistance );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD_CHANGE );
            turtleParameters.push( deltaDistance );
        } else {
            
            var distance = lastDistance + deltaDistance;
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                lastDistance = distance + deltaDistance;
                lineTo( nx, ny );
            } else {
                moveTo( nx, ny );
            }
        }
        return this;
    }
    /**
     * allow you to use a factor ( times ) of last forward amount
     * beware forwards is called by other functions,
     * so may get last forward updated when not expected.
     */
    public inline
    function forwardFactor( factor: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( FORWARD_FACTOR );
                historyParameters.push( factor );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD_FACTOR );
            turtleParameters.push( factor );
        } else {
            
            var distance = lastDistance * factor;
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                lastDistance = distance;
                lineTo( nx, ny );
            } else {
                moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function forwardTriangle(  distance: Float, distance2: Float, radius: Float ): Sketcher {
        return if( radius > 0 ){
            forwardTriangleRight( distance, distance2, radius );
        } else {
            forwardTriangleLeft( distance, distance2, radius );
        }
    }
    public inline
    function forwardTriangleRight( distance: Float, distance2: Float, radius: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( FORWARD_TRIANGLE_RIGHT );
                historyParameters.push( distance );
                historyParameters.push( distance2 );
                historyParameters.push( radius );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD_TRIANGLE_RIGHT );
            turtleParameters.push( distance );
            turtleParameters.push( distance2 );
            turtleParameters.push( radius );
        } else {
            
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                var thruX = x + distance2*Math.cos( rotation ) - radius*Math.cos( rotation + Math.PI/2 );
                var thruY = y + distance2*Math.sin( rotation ) - radius*Math.sin( rotation + Math.PI/2 );
                if( fill ){
                    pen.triangle2DFill( x, y, thruX, thruY, nx, ny );
                }
                lineTo( thruX, thruY );
                lineTo( nx, ny );
                if( fill ){
                    lineTo( x, y );
                }
                moveTo( nx, ny );
            } else {
                moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function forwardTriangleLeft( distance: Float, distance2: Float, radius: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( FORWARD_TRIANGLE_LEFT );
                historyParameters.push( distance );
                historyParameters.push( distance2 );
                historyParameters.push( radius );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD_TRIANGLE_LEFT );
            turtleParameters.push( distance );
            turtleParameters.push( distance2 );
            turtleParameters.push( radius );
        } else {
            
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                var thruX = x + distance2*Math.cos( rotation ) + radius*Math.cos( rotation + Math.PI/2 );
                var thruY = y + distance2*Math.sin( rotation ) + radius*Math.sin( rotation + Math.PI/2 );
                if( fill ){
                    pen.triangle2DFill( x, y, thruX, thruY, nx, ny );
                }
                lineTo( thruX, thruY );
                lineTo( nx, ny );
                if( fill ){
                    lineTo( x, y );
                }
                moveTo( nx, ny );
            } else {
                moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function forwardCurveRight( distance: Float, distance2: Float, radius: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( FORWARD_CURVE_RIGHT );
                historyParameters.push( distance );
                historyParameters.push( distance2 );
                historyParameters.push( radius );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD_CURVE_RIGHT );
            turtleParameters.push( distance );
            turtleParameters.push( distance2 );
            turtleParameters.push( radius );
        } else {
            
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                var thruX = x + distance2*Math.cos( rotation ) - radius*Math.cos( rotation + Math.PI/2 );
                var thruY = y + distance2*Math.sin( rotation ) - radius*Math.sin( rotation + Math.PI/2 );
                quadThru( thruX, thruY, nx, ny );
            } else {
                moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function forwardCurveLeft( distance: Float, distance2: Float, radius: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( FORWARD_CURVE_LEFT );
                historyParameters.push( distance );
                historyParameters.push( distance2 );
                historyParameters.push( radius );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD_CURVE_LEFT );
            turtleParameters.push( distance );
            turtleParameters.push( distance2 );
            turtleParameters.push( radius );
        } else {
            
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                var thruX = x + distance2*Math.cos( rotation ) + radius*Math.cos( rotation + Math.PI/2 );
                var thruY = y + distance2*Math.sin( rotation ) + radius*Math.sin( rotation + Math.PI/2 );
                quadThru( thruX, thruY, nx, ny );
            } else {
                moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline 
    function forwardQuadCurve( distance: Float, distance2: Float, radius: Float ): Sketcher {
        return if( radius > 0 ){
            forwardCurveRight( distance, distance2, radius );
        } else {
            forwardCurveLeft( distance, distance2, -radius );
        }
    }
    public inline
    function fd( distance: Float ): Sketcher {
        return forward( distance );
    }
    public inline
    function backward( distance: Float ): Sketcher {
        if( turtleHistoryOn ){
                historyCommands.push( BACKWARD );
                historyParameters.push( distance );
            }
        if( repeatCommands ){
            turtleCommands.push( BACKWARD );
            turtleParameters.push( distance );
        } else {
            
            var nx = x + distance*Math.cos( rotation + Math.PI );
            var ny = y + distance*Math.sin( rotation + Math.PI );
            if( penIsDown ){
                lineTo( nx, ny );
            } else {
                moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function bk( distance: Float ): Sketcher {
        return backward( distance );
    }
    public inline
    function movePen( distance: Float ): Sketcher {
        // TODO: implement history
        if( repeatCommands ){
            turtleCommands.push( MOVE_PEN );
            turtleParameters.push( distance );
        } else {
            if( penIsDown ) {
                penUp();
                forward( distance );
                penDown();
            } else {
                forward( distance );
            }
        }
        return this;
    }
    /**
     * circle
     *
     * Draw a circle with a given radius. The center is radius units left of the turtle if positive.
     * Otherwise radius units right of the turtle if negative.
     * The circle is drawn in an anticlockwise direction if the radius is positive, otherwise, it is drawn in a clockwise direction.
     **/
     public inline
     function circle( radius: Float, sides: Float = 24 ): Sketcher {
         if( turtleHistoryOn ){
                 if( sides == 24 ){
                     historyCommands.push( CIRCLE );
                     historyParameters.push( radius );
                 } else {
                     historyCommands.push( CIRCLE_SIDES );
                     historyParameters.push( radius );
                     historyParameters.push( sides );
                 }
                 }
         return if( radius == 0 ) {
             this;
         } else {
             if( repeatCommands ){
                 if( sides == 24 ){
                     turtleCommands.push( CIRCLE );
                     turtleParameters.push( radius );
                 } else {
                     turtleCommands.push( CIRCLE_SIDES );
                     turtleParameters.push( radius );
                     turtleParameters.push( sides );
                 }
             } else {
                 
                 //Isosceles 
                 var beta       = (2*Math.PI)/sides;
                 var alpha      = ( Math.PI - beta )/2;
                 var rotate     = -( Math.PI/2 - alpha );
                 var baseLength = 0.5*radius*Math.sin( beta/2 );
                 var ox = x;
                 var oy = y;
                 var arr = [];
                 for( i in 0...48 ){
                     rotation += rotate;
                     var wasHistoryOn = turtleHistoryOn;
                     turtleHistoryOn = false;
                     forward( baseLength );
                     turtleHistoryOn = wasHistoryOn;
                     if( fill ){
                         arr.push(x);
                         arr.push(y);
                     }
                 }
                 if( fill ){
                     var cx = (ox + arr[arr.length-2])/2;
                     var cy = (oy + arr[arr.length-1])/2;
                     var l = arr.length;
                     var i = 2;
                     var lx = 0.;
                     var ly = 0.;
                     while( i < l ){
                         if( i > 2 ) {
                             pen.triangle2DFill( lx, ly, arr[i], arr[i+1], cx, cy );
                         }
                         lx = arr[i];
                         ly = arr[i+1];
                         i+=2;
                     }
                 }
                 arr.resize( 0 );
              }
              this;
         }
     }
     public inline
     function arc( radius: Float, degrees: Float, sides: Float = 24 ): Sketcher {
         if( turtleHistoryOn ){
                 if( sides == 24 ){
                     historyCommands.push( ARC );
                     historyParameters.push( radius );
                     historyParameters.push( degrees );
                 } else {
                     historyCommands.push( ARC_SIDES );
                     historyParameters.push( radius );
                     historyParameters.push( degrees );
                     historyParameters.push( sides );
                 }
                 }
         return if( radius == 0 ) {
             this;
         } else {
             if( repeatCommands ){
                 if( sides == 24 ){
                     turtleCommands.push( ARC );
                     turtleParameters.push( radius );
                     turtleParameters.push( degrees );
                 } else {
                     turtleCommands.push( ARC_SIDES );
                     turtleParameters.push( radius );
                     turtleParameters.push( degrees );
                     turtleParameters.push( sides );
                 }
             } else {
                 
                 //Isosceles 
                 var beta       = toRadians( degrees )/sides;
                 var alpha      = ( Math.PI - beta )/2;
                 var rotate     = -( Math.PI/2 - alpha );
                 var baseLength = 0.5*radius*Math.sin( beta/2 );
                 var ox = x;
                 var oy = y;
                 var arr = [];
                 arr.push(x);
                 arr.push(y);
                 for( i in 0...48 ){
                    rotation += rotate;
                    var wasHistoryOn = turtleHistoryOn;
                    turtleHistoryOn = false;
                    forward( baseLength );
                    turtleHistoryOn = wasHistoryOn;
                    if( fill ){
                        arr.push(x);
                        arr.push(y);
                    }
                 }
                 if( fill ){
                     var cx = (ox + arr[arr.length-2])/2;
                     var cy = (oy + arr[arr.length-1])/2;
                     var l = arr.length;
                     var i = 2;
                     var lx = 0.;
                     var ly = 0.;
                     pen.triangle2DFill( ox, oy, arr[0], arr[1], cx, cy );
                     while( i < l ){
                         if( i > 2 ) {
                             pen.triangle2DFill( lx, ly, arr[i], arr[i+1], cx, cy );
                         }
                         lx = arr[i];
                         ly = arr[i+1];
                         i+=2;
                     }
                     
                 }
                 arr.resize( 0 );
              }
              this;
         }
     }
     public inline
     function north(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( NORTH );
             }
         if( repeatCommands ){
             turtleCommands.push( NORTH );
         } else {
             
             rotation = -Math.PI/2;
         }
         return this;
     }
     public inline
     function rotationReset(){
         return north();
     }
     public inline
     function west(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( WEST );
             }
         if( repeatCommands ){
             turtleCommands.push( WEST );
         } else {
             
             rotation = 0;
         }
         return this;
     }
     public inline
     function east(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( WEST );
             }
         if( repeatCommands ){
             turtleCommands.push( EAST );
         } else {
             
             rotation = Math.PI;
         }
         return this;
     }
     public inline
     function south(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( SOUTH );
             }
         if( repeatCommands ){
             turtleCommands.push( SOUTH );
         } else {
             
             rotation = Math.PI/2;
         }
         return this;
     }
     public inline
     function heading(): Float {
         var deg = 180*rotation/Math.PI;
         // TODO: rationalize..
         return deg;
     }
     public inline
     function position():{ x: Float, y: Float }{
         return { x: x, y: y };
     }
     public inline
     function goto( x: Float, y: Float ): Sketcher {
         return setPosition( x, y );
     }
     public inline
     function setPosition( x: Float, y: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( SET_POSITION );
                 historyParameters.push( x );
                 historyParameters.push( y );
             }
         if( repeatCommands ){
             turtleCommands.push( SET_POSITION );
             turtleParameters.push( x );
             turtleParameters.push( y );
         } else {
             
             moveTo( x, y );
         }
         return this;
     }
     public inline
     function setposition( x: Float, y: Float ): Sketcher {
         return setPosition( x, y );
     }
     public inline
     function penSize( w: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PEN_SIZE );
                 historyParameters.push( w );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_SIZE );
             turtleParameters.push( w );
         } else {
             
             width = w;
         }
         return this;
     }
     public inline
     function pensize( w: Float ): Sketcher {
         return penSize( w );
     }
     public inline
     function penSizeChange( dw: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PEN_SIZE_CHANGE );
                 historyParameters.push( dw );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_SIZE_CHANGE );
             turtleParameters.push( dw );
         } else {
             
             width = width + dw;
         }
         return this;
     }
     public inline
     function penSizeFactor( factor: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PEN_SIZE_FACTOR );
                 historyParameters.push( factor );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_SIZE_FACTOR );
             turtleParameters.push( factor );
         } else {
             
             width = width * factor;
         }
         return this;
     }
     public inline
     function repeat( repeatCount_: Float ): Sketcher {
         return beginRepeat( repeatCount_ );
     }
     public inline
     function loop( repeatCount_: Float ): Sketcher {
         return beginRepeat( repeatCount_ );
     }
     public inline
     function beginRepeat( repeatCount_: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( BEGIN_REPEAT );
                 historyParameters.push( Math.round( repeatCount_ ) );
             }
         if( repeatCommands == true ){
             // if currently already in repeat then end repeat and restart.
             endRepeat();
         }
         if( repeatCount_ > 0 ) {
             
             repeatCount = Math.round( repeatCount_ );
             repeatCommands = true;
             turtleCommands.resize( 0 );// = new Array<TurtleCommand>;
             turtleParameters.resize( 0 ); //= new Array<Float>;
         }
         return this;
     }
     public inline
     function loopEnd(): Sketcher {
         return endRepeat();
     }
     public inline
     function repeatEnd(): Sketcher{
         return endRepeat();
     }
     public inline
     function endRepeat(): Sketcher {
         repeatCommands = false;
         if( turtleHistoryOn ){
             historyCommands.push( END_REPEAT );
         }
         var wasHistoryOn = turtleHistoryOn;
         turtleHistoryOn = false;
         var v = turtleParameters;
         var j: Int = 0;
         for( k in 0...repeatCount ){
             for( i in 0...turtleCommands.length ){
                 var command: TurtleCommand = turtleCommands[ i ];
                 switch ( command ){
                     case FORWARD:
                         forward( v[ j ] );
                         j++;
                     case FORWARD_CHANGE:
                         forwardChange( v[ j ] );
                         j++;
                     case FORWARD_FACTOR:
                         forwardFactor( v[ j ] );
                         j++;
                     case BACKWARD:
                         backward( v[ j ] );
                         j++;
                    case PEN_UP:
                        penUp();
                    case PEN_DOWN:
                        penDown();
                    case LEFT:
                        left( v[ j ] );
                        j++;
                    case RIGHT:
                        right( v[ j ] );
                        j++;
                    case SET_ANGLE:
                        setAngle( v[ j ] );
                        j++;
                    case NORTH:
                        north();
                    case SOUTH:
                        south();
                    case WEST:
                        west();
                    case EAST:
                        east();
                    case SET_POSITION:
                        setPosition( v[ j ], v[ j + 1 ] );
                        j += 2;
                    case PEN_SIZE:
                        penSize( v[ j ] );
                        j++;
                    case PEN_SIZE_CHANGE:
                        penSizeChange( v[ j ] );
                        j++;
                    case PEN_SIZE_FACTOR:
                        penSizeFactor( v[ j ] );
                        j++;
                    case CIRCLE:
                        circle( v[ j ] );
                        j++;
                    case CIRCLE_SIDES:
                        circle( v[ j ], v[ j + 1 ] );
                        j += 2;
                    case ARC:
                        arc( v[ j ], v[ j + 1 ] );
                        j += 2;
                    case ARC_SIDES:
                        arc( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case MOVE_PEN:
                        movePen( v[ j ] );
                        j++;
                    case FORWARD_TRIANGLE_RIGHT:
                        forwardTriangleRight( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case FORWARD_TRIANGLE_LEFT:
                        forwardTriangleLeft( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case FORWARD_CURVE_RIGHT:
                        forwardCurveRight( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case FORWARD_CURVE_LEFT:
                        forwardCurveLeft( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case FILL_ON:
                        fillOn();
                    case FILL_OFF:
                        fillOff();
                    case BLACK:
                        black();
                    case BLUE:
                        blue();
                    case GREEN:
                        green();
                    case CYAN:
                        cyan();
                    case RED:
                        red();
                    case MAGENTA:
                        magenta();
                    case YELLOW:
                        yellow();
                    case WHITE:
                        white();
                    case BROWN:
                        brown();
                    case LIGHT_BROWN:
                        lightBrown();
                    case DARK_GREEN:
                        darkGreen();
                    case DARKISH_BLUE:
                        darkishBlue();
                    case TAN:
                        tan();
                    case PLUM:
                        plum();
                    case ORANGE:
                        orange();
                    case GREY:
                        grey();
                    case PEN_COLOR:
                        penColor( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case PEN_COLOR_CHANGE:
                        penColorChange( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case PEN_COLOR_B: // used for gradient ( default second color )
                        penColorB( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case PEN_COLOR_CHANGE_B:
                        penColorChangeB( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;   
                    case PEN_COLOR_C: // used for gradient not mostly used, even then.
                        penColorC( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case PEN_COLOR_CHANGE_C:
                        penColorChangeC( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case BEGIN_REPEAT:
                    case END_REPEAT:
                 }
             }
             j = 0;
         }
         turtleHistoryOn = wasHistoryOn;
         turtleCommands.resize( 0 );
         turtleParameters.resize( 0 );
         return this;
     }
     public inline
     function penColor( r: Float, g: Float, b: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PEN_COLOR );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             #if NO_ALPHA
             pen.currentColor =    ( Math.round( r   * 255 ) << 16) 
                                 | ( Math.round( g * 255 ) << 8) 
                                 |   Math.round( b  * 255 );
             #else
             pen.currentColor = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( r   * 255 ) << 16) 
                                 | ( Math.round( g * 255 ) << 8) 
                                 |   Math.round( b  * 255 );
            #end
         }
         return this;
     }
     public inline
     function pencolor( r: Float, g: Float, b: Float ): Sketcher {
         return penColor( r, g, b );
     }
     public inline
     function penColorChange( r: Float, g: Float, b: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PEN_COLOR_CHANGE );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_CHANGE );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             var c = pen.currentColor;
             var r0 = (( c >> 16) & 255) / 255;
             var g0 = (( c >> 8) & 255) / 255;
             var b0 = (c & 255) / 255;
             pen.currentColor = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( ( r0 + r ) * 255 ) << 16) 
                                 | ( Math.round( ( g0 + g ) * 255 ) << 8) 
                                 |   Math.round( ( b0 + b ) * 255 );
         }
         return this;
     }
     public inline
     function penColorB( r: Float, g: Float, b: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PEN_COLOR_B );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_B );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             pen.colorB = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( r   * 255 ) << 16) 
                                 | ( Math.round( g * 255 ) << 8) 
                                 |   Math.round( b  * 255 );
         }
         return this;
     }
     public inline
     function penColorChangeB( r: Float, g: Float, b: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PEN_COLOR_CHANGE_B );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_CHANGE_B );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             var c = pen.colorB;
             var r0 = (( c >> 16) & 255) / 255;
             var g0 = (( c >> 8) & 255) / 255;
             var b0 = (c & 255) / 255;
             pen.colorB = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( ( r0 + r ) * 255 ) << 16) 
                                 | ( Math.round( ( g0 + g ) * 255 ) << 8) 
                                 |   Math.round( ( b0 + b ) * 255 );
         }
         return this;
     }
     public inline
     function penColorC( r: Float, g: Float, b: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PEN_COLOR_C );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_C );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             pen.colorC = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( r   * 255 ) << 16) 
                                 | ( Math.round( g * 255 ) << 8) 
                                 |   Math.round( b  * 255 );
         }
         return this;
     }
     public inline
     function penColorChangeC( r: Float, g: Float, b: Float ): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PEN_COLOR_CHANGE_C );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_CHANGE_C );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             var c = pen.colorC;
             var r0 = (( c >> 16) & 255) / 255;
             var g0 = (( c >> 8) & 255) / 255;
             var b0 = (c & 255) / 255;
             pen.colorC = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( ( r0 + r ) * 255 ) << 16) 
                                 | ( Math.round( ( g0 + g ) * 255 ) << 8) 
                                 |   Math.round( ( b0 + b ) * 255 );
         }
         return this;
     }
     // Default colours may need rethink.
     public inline
     function black(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( BLACK );
             }
         if( repeatCommands ){
             turtleCommands.push( BLACK );
         } else {
             
             pen.currentColor = TurtleBlack;
         }
         return this;
     }
     public inline
     function blue(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( BLUE );
             }
         if( repeatCommands ){
             turtleCommands.push( BLUE );
         } else {
             
             pen.currentColor = TurtleBlue;
         }
         return this;
     }
     public inline
     function green(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( GREEN );
             }
         if( repeatCommands ){
             turtleCommands.push( GREEN );
         } else {
             
             pen.currentColor = TurtleGreen;
         }
         return this;
     }
     public inline
     function cyan(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( CYAN );
             }
         if( repeatCommands ){
             turtleCommands.push( CYAN );
         } else {
             
             pen.currentColor = TurtleCyan;
         }
         return this;
     }
     public inline
     function red(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( RED );
             }
         if( repeatCommands ){
             turtleCommands.push( RED );
         } else {
             
             pen.currentColor = TurtleRed;
         }
         return this;
     }
     public inline
     function magenta(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( MAGENTA );
             }
         if( repeatCommands ){
             turtleCommands.push( MAGENTA );
         } else {
             
             pen.currentColor = TurtleMagenta;
         }
         return this;
     }
     public inline
     function yellow(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( YELLOW );
             }
         if( repeatCommands ){
             turtleCommands.push( YELLOW );
         } else {
             
             pen.currentColor = TurtleYellow;
         }
         return this;
     }
     public inline
     function white(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( WHITE );
             }
         if( repeatCommands ){
             turtleCommands.push( WHITE );
         } else {
             
             pen.currentColor = TurtleWhite;
         }
         return this;
     }
     public inline
     function brown(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( BROWN );
             }
         if( repeatCommands ){
             turtleCommands.push( BROWN );
         } else {
             
             pen.currentColor = TurtleBrown;
         }
         return this;
     }
     public inline
     function lightBrown(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( LIGHT_BROWN );
             }
         if( repeatCommands ){
             turtleCommands.push( LIGHT_BROWN );
         } else {
             
             pen.currentColor = TurtleLightBrown;
         }
         return this;
     }
     public inline
     function darkGreen(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( DARK_GREEN );
             }
         if( repeatCommands ){
             turtleCommands.push( DARK_GREEN );
         } else {
             
             pen.currentColor = TurtleDarkGreen;
         }
         return this;
     }
     public inline
     function darkishBlue(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( DARKISH_BLUE );
             }
         if( repeatCommands ){
             turtleCommands.push( DARKISH_BLUE );
         } else {
             
             pen.currentColor = TurtleDarkishBlue;
         }
         return this;
     }
     public inline
     function tan(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( TAN );
             }
         if( repeatCommands ){
             turtleCommands.push( TAN );
         } else {
             
             pen.currentColor = TurtleTan;
         }
         return this;
     }
     public inline
     function plum(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( PLUM );
             }
         if( repeatCommands ){
             turtleCommands.push( PLUM );
         } else {
             
             pen.currentColor = TurtlePlum;
         }
         return this;
     }
     public inline
     function orange(): Sketcher {
         trace('ORANGE>>>>>>> ');
             if( turtleHistoryOn ){
                 historyCommands.push( ORANGE );
             }
         if( repeatCommands ){
             turtleCommands.push( ORANGE );
         } else {
             
             pen.currentColor = TurtleOrange;
         }
         return this;
     }
     public inline
     function grey(): Sketcher {
         if( turtleHistoryOn ){
                 historyCommands.push( GREY );
             }
         if( repeatCommands ){
             turtleCommands.push( GREY );
         } else {
             
             pen.currentColor = TurtleGrey;
         }
         return this;
     }
}
@:forward
enum abstract TurtleCommand( String ) to String from String {
    var BEGIN_REPEAT = 'BEGIN_REPEAT';
    var END_REPEAT = 'END_REPEAT';
    // note don't need the actual string as compiler an infer ... but leave for now.
    var FORWARD = 'FORWARD';
    var FORWARD_CHANGE = 'FORWARD_CHANGE';
    var FORWARD_FACTOR = 'FORWARD_FACTOR';
    var BACKWARD = 'BACKWARD';
    var PEN_UP = 'PEN_UP';
    var PEN_DOWN = 'PEN_DOWN';
    var LEFT = 'LEFT';
    var RIGHT = 'RIGHT';
    var SET_ANGLE = 'SET_ANGLE';
    var NORTH = 'NORTH';
    var SOUTH = 'SOUTH';
    var WEST = 'WEST';
    var EAST = 'EAST';
    var SET_POSITION = 'SET_POSITION';
    var PEN_SIZE = 'PEN_SIZE';
    var PEN_SIZE_CHANGE = 'PEN_SIZE_CHANGE';
    var PEN_SIZE_FACTOR = 'PEN_SIZE_FACTOR';
    var CIRCLE = 'CIRCLE'; // CONSIDER DOT FOR FILLED ONE!
    var CIRCLE_SIDES = 'CIRCLE_SIDES';
    var ARC = 'ARC';
    var ARC_SIDES = 'ARC_SIDES';
    var MOVE_PEN = 'MOVE_PEN';
    var FORWARD_TRIANGLE_RIGHT = 'FORWARD_TRIANGLE_RIGHT';
    var FORWARD_TRIANGLE_LEFT = 'FORWARD_TRIANGLE_LEFT';
    var FORWARD_CURVE_RIGHT = 'FORWARD_CURVE_RIGHT';
    var FORWARD_CURVE_LEFT = 'FORWARD_CURVE_LEFT';
    var FILL_ON = 'FILL_ON';
    var FILL_OFF = 'FILL_OFF';
    // Colors as per... https://fmslogo.sourceforge.io/workshop/
    // reconsider names!
    var PEN_COLOR   = 'PEN_COLOR';
    var PEN_COLOR_CHANGE = 'PEN_COLOR_CHANGE';
    var PEN_COLOR_CHANGE_B = 'PEN_COLOR_CHANGE_B';
    var PEN_COLOR_CHANGE_C = 'PEN_COLOR_CHANGE_C';
    var PEN_COLOR_B = 'PEN_COLOR_B'; // used for gradients
    var PEN_COLOR_C = 'PEN_COLOR_C';
    var BLACK       = 'BLACK'; // 	[0 0 0] 	 
    var BLUE        = 'BLUE'; //1 	blue 	[0 0 255] 	 
    var GREEN       = 'GREEN';// 2 	green 	[0 255 0] 	 
    var CYAN        = 'CYAN';//3 	cyan (light blue) 	[0 255 255] 	 
    var RED         = 'RED';//4 	red 	[255 0 0] 	 
    var MAGENTA     = 'MAGENTA';//5 	magenta (reddish purple) 	[255 0 255] 	 
    var YELLOW      = 'YELLOW';//6 	yellow 	[255 255 0] 	 
    var WHITE       = 'WHITE';//7 	white 	[255 255 255] 	 
    var BROWN       = 'BROWN';//8 	brown 	[155 96 59] 	 
    var LIGHT_BROWN = 'LIGHT_BROWN';//9 	light brown 	[197 136 18] 	 
    var DARK_GREEN  = 'DARK_GREEN';//10 	dark green 	[100 162 64] 	 
    var DARKISH_BLUE = 'DARKISH_BLUE';// 11 	darkish blue 	[120 187 187] 	 
    var TAN          = 'TAN';//12 	tan 	[255 149 119] 	 
    var PLUM         = 'PLUM';//13 	plum (purplish) 	[144 113 208] 	 
    var ORANGE       = 'ORANGE';//14 	orange 	[255 163 0] 	 
    var GREY         = 'GREY';//15 	gray 	[183 183 183]
}
#if NO_ALPHA
// useful for canvas
@:forward
enum abstract TurtleColors( Int ) to Int from Int {
    var TurtleBlack       = 0x000000;
    var TurtleBlue        = 0x0000FF;
    var TurtleGreen       = 0x00FF00; 
    var TurtleCyan        = 0x00FFFF;
    var TurtleRed         = 0xFF0000;
    var TurtleMagenta     = 0xFF00FF;	 
    var TurtleYellow      = 0xFFFF00; 
    var TurtleWhite       = 0xFFFFFF;
    var TurtleBrown       = 0x9B603B;	 
    var TurtleLightBrown  = 0xC58812;	 
    var TurtleDarkGreen   = 0x64A240; 
    var TurtleDarkishBlue = 0x78BBBB; 
    var TurtleTan         = 0xFF9577;
    var TurtlePlum        = 0x9071D0; 
    var TurtleOrange      = 0xFFA300;
    var TurtleGrey        = 0xB7B7B7;
}
#else
@:forward
enum abstract TurtleColors( Int ) to Int from Int {
    var TurtleBlack       = 0xFF000000;
    var TurtleBlue        = 0xFF0000FF;
    var TurtleGreen       = 0xFF00FF00; 
    var TurtleCyan        = 0xFF00FFFF;
    var TurtleRed         = 0xFFFF0000;
    var TurtleMagenta     = 0xFFFF00FF;	 
    var TurtleYellow      = 0xFFFFFF00; 
    var TurtleWhite       = 0xFFFFFFFF;
    var TurtleBrown       = 0xFF9B603B;	 
    var TurtleLightBrown  = 0xFFC58812;	 
    var TurtleDarkGreen   = 0xFF64A240; 
    var TurtleDarkishBlue = 0xFF78BBBB; 
    var TurtleTan         = 0xFFFF9577;
    var TurtlePlum        = 0xFF9071D0; 
    var TurtleOrange      = 0xFFFFA300;
    var TurtleGrey        = 0xFFB7B7B7;
}
#end
#if INCLUDE_TURTLE_RGB_ARRAY
// mainly for reference
enum abstract TurtleRGB( String )  {
    var TurtleRGB_BLACK        = '0,0,0';
    var TurtleRGB_BLUE         = '0,0,255';
    var TurtleRGB_GREEN        = '0,255,0';
    var TurtleRGB_CYAN         = '0,255,255';
    var TurtleRGB_RED          = '255,0,0';
    var TurtleRGB_MAGENTA      = '255,0,255';
    var TurtleRGB_YELLOW       = '255,255,0';
    var TurtleRGB_WHITE        = '255,255,255';
    var TurtleRGB_BROWN        = '155,96,59';
    var TurtleRGB_LIGHT_BROWN  = '197,136,18';
    var TurtleRGB_DARK_GREEN   = '100,162,64';
    var TurtleRGB_DARKISH_BLUE = '120,187,187';
    var TurtleRGB_TAN          = '255,149,119';
    var TurtleRGB_PLUM         = '144,113,208';
    var TurtleRGB_ORANGE       = '255,163,0';
    var TurtleRGB_GREY         = '183,183,183';
    public inline function getRGB( c: TurtleRGB ): Array<Int>{
        var arrS =  cast( c, String ).split(',');
        var arrI = new Array<Int>();
        for( i in 0...arrS.length ){
            arrI[i] = Std.parseInt( arrS[i] );
        }
        return arrI;
    }
}
#end