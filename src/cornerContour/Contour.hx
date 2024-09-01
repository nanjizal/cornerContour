package cornerContour;
import fracs.Pi2pi;
import fracs.Fraction;
import cornerContour.color.ColorWheel24;
//import fracs.ZeroTo2pi;
import fracs.Angles;
//#if contour_includeSegments
//import notImplemented.segment.SixteenSeg;
//import notImplemented.segment.SevenSeg;
//#end
class Contour implements IContour {
    public var debugCol0      = redRadish;
    public var debugCol1      = gokuOrange;
    public var debugCol2      = carona;
    public var debugCol3      = flirtatious;
    public var debugCol4      = daffodil;
    public var debugCol5      = peraRocha;
    public var debugCol6      = fieldGreen;
    public var debugCol7      = maximumBlue;
    public var debugCol8      = celestialPlum;
    public var debugCol9      = earlySpringNight;
    public var debugCol10     = nebulaFuchsia;
    public var debugCol11     = royalFuchsia;
    public var debugCol12     = orangeSoda;
    public var pointsClock:     Array<Float> = [];
    public var pointsAnti:      Array<Float> = [];
    public var penultimateCX:   Float;
    public var penultimateCY:   Float;
    public var lastClockX:      Float;
    public var lastClockY:      Float;
    public var penultimateAX:   Float;
    public var penultimateAY:   Float;
    public var lastAntiX:       Float;
    public var lastAntiY:       Float;
    public var mitreLimit:      Float = 1.2;
    public var useMitre:        Bool = true; 
    var pen: IPen;
    var endLine: StyleEndLine;
    
    var ax: Null<Float>; // 0
    var ay: Null<Float>; // 0
    var bx: Null<Float>; // 1
    var by: Null<Float>; // 1
    var cx: Null<Float>; // 2
    var cy: Null<Float>; // 2
    
    var dx: Null<Float>; // 3     // computeDE checks null
    var dy: Null<Float>; // 3
    var ex: Null<Float>; // 4
    var ey: Null<Float>; // 4
    
    /*var fx: Float; // q0
    var fy: Float;
    var gx: Float; // q1
    var gy: Float;*/
    
    var dxPrev: Null<Float>; // computeDE checks null
    var dyPrev: Null<Float>;
    var exPrev: Null<Float>;
    var eyPrev: Null<Float>;
    var dxOld: Null<Float>;
    var dyOld: Null<Float>;
    var exOld: Null<Float>;
    var eyOld: Null<Float>;
    var jx: Null<Float>;
    var jy: Null<Float>;
    var lastClock: Bool;
    var jxOld: Float;
    var jyOld: Float;
    
    var kax: Float;
    var kay: Float;
    var kbx: Float;
    var kby: Float;
    var kcx: Float;
    var kcy: Float;
    var ncx: Float;
    var ncy: Float;
    var quadIndex: Float;
    public var angleA: Float; // smallest angle between lines
    public var halfA: Float;
    public var beta: Float;
    var r: Float;
    public var theta: Float;
    public var angle1: Null<Float>;  // triangleJoin checks null
    public var angle2: Float;
    inline static var smallDotScale = 0.07;
    public var endCapFactor = 0.5;//1.45;
    public function reset(){
        angleA = 0; //null;
        count = 0;
        kax = 0; //null;
        kay = 0; //null;
        kbx = 0; //null;
        kby = 0; //null;
        kcx = 0; //null; 
        kcy = 0; //null;
        ncx = 0; //null;
        ncy = 0; //null;
        ax = 0; //null;
        ay = 0; //null;
        bx = 0; //null;
        by = 0; //null;
        cx = 0; //null;
        cy = 0; //null;
        
        dx = null;
        dy = null;
        ex = null;
        ey = null;
        
        /*fx = null;
        fy = null;
        gx = null;
        gy = null;*/
        pointsClock.resize( 0 );
        pointsAnti.resize( 0 );
    } 
    
    //TODO: create lower limit for width   0.00001; ?
    public var count = 0;
    public function new( pen_: IPen, endLine_: StyleEndLine = no ){
        pen = pen_;
        endLine = endLine_;
    }
    
    public inline 
    function computeDE(){
        anglesCompute();
        if( dxPrev != null ) dxOld = dxPrev;
        if( dyPrev != null ) dyOld = dyPrev;
        if( exPrev != null ) exOld = exPrev;
        if( eyPrev != null ) eyOld = eyPrev;
        if( dx != null ) dxPrev = dx;
        if( dy != null ) dyPrev = dy;
        if( ex != null ) exPrev = ex;
        if( ey != null ) eyPrev = ey;
        dx = bx + r * Math.cos( angle1 );
        dy = by + r * Math.sin( angle1 );
        ex = bx + r * Math.cos( angle2 );
        ey = by + r * Math.sin( angle2 );
    }
    inline
    function anglesCompute(){
        theta = thetaCompute( ax, ay, bx, by );
        if( theta > 0 ){
            if( halfA < 0 ){
                angle2 = theta + halfA + Math.PI/2;
                angle1 =  theta - halfA;
            } else {
                angle1 =  theta + halfA - Math.PI;
                angle2 =  theta + halfA;
            }
        } else {
            if( halfA > 0 ){
                angle1 =  theta + halfA - Math.PI;
                angle2 =  theta + halfA;
            } else {
                angle2 = theta + halfA + Math.PI/2;
                angle1 =  theta - halfA;
            }
        }
    }
    inline
    function thetaComputeAdj( qx: Float, qy: Float ): Float {
        return -thetaCompute( ax, ay, qx, qy ) - Math.PI/2;
    }
    static inline 
    function thetaCompute( px: Float, py: Float, qx: Float, qy: Float ): Float {
        return Math.atan2( py - qy, px - qx );
    }
    public static inline 
    function dist( px: Float, py: Float, qx: Float, qy: Float  ): Float {
        var x = px - qx;
        var y = py - qy;
        return x*x + y*y;
    }
    
    
    
    public inline
    function triangleJoin( ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, curveEnds: Bool = false, overlap: Bool = false ){
        var oldAngle = ( dx != null )? angle1: null;  // I am not sure I can move this to curveJoins because angle1 is set by computeDE
        halfA = Math.PI/2;
        //if( dxOld != null ){  // this makes it a lot faster but a bit of path in some instance disappear needs more thought to remove....
            // dx dy ex ey
        //} else {
            // only calculate p3, p4 if missing - not sure if there are any strange cases this misses, seems to work and reduces calculations
            ax = bx_;
            ay = by_;
            bx = ax_;
            by = ay_;
            beta = Math.PI/2 - halfA;           // thickness
            r = ( width_/2 )*Math.cos( beta );  // thickness
            computeDE();
            //}
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        ax = ax_;
        ay = ay_;
        bx = bx_;
        by = by_;
        computeDE();
        //if( dxOld != null ){ //dxOld != null
            var clockWise = isClockwise( bx_, by_ );
            var theta0: Float;
            var theta1: Float;
            if( clockWise ){
                theta0 = thetaComputeAdj( dxOld, dyOld );
                theta1 = thetaComputeAdj( exPrev, eyPrev );
            } else {
                theta0 = thetaComputeAdj( exOld, eyOld );
                theta1 = thetaComputeAdj( dxPrev, dyPrev );
            }
            var dif = Angles.differencePrefer( theta0, theta1, SMALL );
            if( !overlap && count != 0 ) computeJ( width_, theta0, dif ); // don't calculate j if your just overlapping quads
            
            if( count == 0 && 
                ( endLine == begin 
               || endLine == both 
               || endLine == triangleBegin
               || endLine == triangleBoth
               || endLine == arrowBoth
               || endLine == arrowBegin
               || endLine == squareBegin
               || endLine == squareBoth
               || endLine == circleBegin
               || endLine == circleBoth 
               || endLine == ellipseBegin
               || endLine == ellipseBoth ) ) {
                /**
                 * draws arc at beginning of line
                 */
                addStartShape( ax, ay, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL_OLD );
            } 
            if( count == 0 && ( endLine == halfRound || endLine == quadrant ) ) {
                addStartShape( ax, ay, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI/2, SMALL_OLD );
            }
            /*if( count == 0 && ( endLine == bottomHalfRound || endLine == bottomRounded ) ) {
                addStartShape( ax, ay, width_/2, -angle1 - Math.PI/2 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI/2, SMALL_OLD );
            }*/
            
            if( overlap ){
                overlapQuad(); // not normal
            }else {
                if( count != 0 ) addQuads( clockWise, width_ );
                addInitialQuads( clockWise, width_ );
            }
            if( useMitre ){
                mitreDraw( ax_, ay_, bx_, by_, width_, clockWise );
            } else {
            if( curveEnds ){
                //joinArc
                if( clockWise ){
                    pieDifX( ax_, ay_, width_/2, theta0, dif, pointsClock );
                    triangle2DFill( dxOld, dyOld, exPrev, eyPrev, jx, jy );
                } else {
                    pieDifX( ax_, ay_, width_/2, theta0, dif, pointsAnti );
                    triangle2DFill( exOld, eyOld, dxPrev, dyPrev, jx, jy );
                }
            } else {
            // straight line between lines    
                if( count != 0 ){
                    if( overlap ){ // just draw down to a as overlapping quads
                        connectQuadsWhenQuadsOverlay( clockWise, width_ );
                    } else {
                        connectQuads( clockWise, width_ );
                    }
                }
            }
            }
            storeLastQuads();
            
            
        //if( curveEnds && !overlap && count != 0 ) addSmallTriangles( clockWise, width_ );
        /*
        #if contour_includeSegments
        #if contour_debugNumbers
            addNumbering( jx, jy, counter, width_ );
            counter++;
        #end
        #end
        */
        
        jxOld = jx;
        jyOld = jy;
        lastClock = clockWise;        
        count++;
        return;// triArr;
    }
    inline
    function overlapQuad(){
        triangle2DFill( dxPrev, dyPrev, dx, dy, ex, ey 
                            #if contour_debug ,debugCol8 #end );
        triangle2DFill( dxPrev, dyPrev, dx, dy, exPrev, eyPrev 
                            #if contour_debug ,debugCol12 #end );
    }
    // call to add round end to line
    public inline
    function end( width_: Float ){
        endEdges();
        if( count != 0 && ( endLine == StyleEndLine.end 
                         || endLine == StyleEndLine.both 
                         || endLine == StyleEndLine.triangleEnd
                         || endLine == StyleEndLine.triangleBoth
                         || endLine == StyleEndLine.arrowBoth
                         || endLine == StyleEndLine.arrowEnd
                         || endLine == StyleEndLine.squareEnd
                         || endLine == StyleEndLine.squareBoth
                         || endLine == StyleEndLine.circleEnd
                         || endLine == StyleEndLine.circleBoth
                         || endLine == StyleEndLine.ellipseEnd
                         || endLine == StyleEndLine.ellipseBoth
                         ) ) {  
            addEndShape( bx, by, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL_OLD );
        }
        if( count != 0 && ( endLine == StyleEndLine.halfRound || endLine == StyleEndLine.quadrant )){
            addEndShape( bx, by, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI/2, SMALL_OLD );
        }
        /*
        if( count != 0 && ( endLine == StyleEndLine.bottomHalfRound || endLine == StyleEndLine.bottomRounded )){
            addEndShape( bx, by, width_/2, -angle1 - Math.PI/2 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL_OLD );
        }*/
    }
    inline 
    function triangle2DFill( ax_: Float, ay_: Float, bx_: Float, by_: Float, cx_: Float, cy_: Float, color_: Int = -1 ){
        pen.triangle2DFill( ax_, ay_, bx_, by_, cx_, cy_, color_ );
    }
    inline
    function addStartShape( ax: Float, ay: Float, radius: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Int = -1, ?sides: Int = 36 ){
        var temp = new Array<Float>();
        startShape( ax, ay, radius, beta, gamma, prefer, temp, mark, sides );
        var pA = pointsAnti.length;
        var len = Std.int( temp.length/2 );
        var p4 = Std.int( temp.length/4 );
        for( i in 0...p4 ){
            pointsAnti[ pA++ ] = temp[ len - 2*i + 1];
            pointsAnti[ pA++ ] = temp[ len - 2*i ];
        }
        var pC = pointsClock.length;
        for( i in 0...p4 ){
            pointsClock[ pC++ ] = temp[ i*2 + len + 1];
            pointsClock[ pC++ ] = temp[ i*2 + len ];
        }
    }
    
    inline
    function addEndShape( ax: Float, ay: Float, radius: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Int = -1, ?sides: Int = 36 ){
        var temp = new Array<Float>();
        endShape( ax, ay, radius, beta, gamma, prefer, temp, mark, sides );
        var pA = pointsAnti.length;
        var len = Std.int( temp.length/2 );
        for( i in 0...len + 2 ){
            pointsAnti[ pA++ ] = temp[ i ];
        }
        var pC = pointsClock.length;
        for( i in 1...Std.int( len/2 + 1 ) ){
            pointsClock[ pC++ ] = temp[ temp.length - 2*i ];
            pointsClock[ pC++ ] = temp[ temp.length - 2*i - 1 ];
        }
    }
    
    inline
    function addPie( ax: Float, ay: Float, radius: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Int = -1, ?sides: Int = 36 ){
        pie( ax, ay, radius, beta, gamma, prefer, mark, sides );
    }
    inline
    function computeJ( width_: Float, theta0: Float, dif: Float ){
        var gamma = Math.abs( dif )/2;
        var h = ( width_/2 )/Math.cos( gamma );
        var start: Pi2pi = theta0;
        var start2: Float = start;
        var delta = start2 + dif/2 + Math.PI;
        jx = ax + h * Math.sin( delta );
        jy = ay + h * Math.cos( delta );
    }
    inline 
    function addDot( x: Float, y: Float, color: Int, width_: Float ){
        var w = width_ * smallDotScale;
        circle( x, y, w, color );
    }
    #if contour_debug
    inline
    function addDebugLine( x0: Float, y0: Float, x1: Float, y1: Float, width_: Float, col: Int, colStart: Int = 1 ){
        var w = width_*smallDotScale/2;
        var dx = (x1 - x0);
        var dy = (y1 - y0);
        var len = Std.int( Math.min( 100, Math.max( dx, dy ) ) );
        dx = dx/len;
        dy = dy/len;
        for( i in 0...len ){
            if( i < 5 ){
                circle( x0 + dx*i, y0 + dy*i, w*2, colStart );
            } else {
                circle( x0 + dx*i, y0 + dy*i, w, col );
            }
        }
    }
    #end
    inline
    function addSmallTriangles( clockWise: Bool, width_: Float ){
        if( clockWise ){
            triangle2DFill( ax, ay, dxOld,  dyOld,  jx, jy #if contour_debug ,debugCol1 #end );
            triangle2DFill( ax, ay, exPrev, eyPrev, jx, jy #if contour_debug ,debugCol3 #end );
            #if contour_debugPoints triangle2DFillangleCorners( dxOld, dyOld, exPrev, eyPrev, width_ ); #end
        } else {
            triangle2DFill( ax, ay, exOld, eyOld, jx, jy #if contour_debug ,debugCol1 #end );
            triangle2DFill( ax, ay, dxPrev, dyPrev, jx, jy #if contour_debug ,debugCol3 #end );
            #if contour_debugPoints triangle2DFillangleCorners( exOld, eyOld, dxPrev, dyPrev, width_ ); #end
        }
    }
    inline
    function triangle2DFillangleCorners( oldx_: Float, oldy_: Float, prevx_: Float, prevy_: Float, width_: Float ){
        var w = width_ * smallDotScale;
        circle( oldx_, oldy_, w, debugCol4 );
        circle( prevx_, prevy_, w, debugCol3 );
        circle( ax, ay, w, debugCol10 );
        circle(  jx, jy, w, debugCol5 );
    }
    inline
    function triangle2DFillangleCornersLess( oldx_: Float, oldy_: Float, prevx_: Float, prevy_: Float, width_: Float ){
        var w = width_ * smallDotScale;
        circle( oldx_, oldy_, w, debugCol4  );
        circle( prevx_, prevy_, w, debugCol3 );
        circle( jx, jy, w, debugCol5 );
    }
    // The triangle between quads
    inline
    function connectQuadsWhenQuadsOverlay( clockWise: Bool, width_: Float ){
        if( clockWise ){
            triangle2DFill( dxOld, dyOld, exPrev, eyPrev, ax, ay );
            #if contour_debugPoints 
                triangle2DFillangleCornersLess( dxOld, dyOld, exPrev, eyPrev, width_ ); 
            #end
        } else {
            triangle2DFill( exOld, eyOld, dxPrev, dyPrev, ax, ay );
            #if contour_debugPoints 
                triangle2DFillangleCornersLess( exOld, eyOld, dxPrev, dyPrev, width_ ); 
            #end
        }
    }
    // The triangle between quads
    inline
    function connectQuads( clockWise: Bool, width_: Float ){
        if( clockWise ){
            triangle2DFill( dxOld, dyOld, exPrev, eyPrev, jx, jy );
            #if contour_debugPoints 
                triangle2DFillangleCornersLess( dxOld, dyOld, exPrev, eyPrev, width_ ); 
            #end
        } else {
            triangle2DFill( exOld, eyOld, dxPrev, dyPrev, jx, jy );
            #if contour_debugPoints
                triangle2DFillangleCornersLess( exOld, eyOld, dxPrev, dyPrev, width_ ); 
            #end
        }
    }
    // these are Quads that don't use the second inner connection so they overlap at the end
    // draw these first and replace them?
    inline 
    function addInitialQuads( clockWise: Bool, width_: Float ){
        //These get replaced as drawing only to leave the last one
        
        quadIndex = pen.pos; //triArr.length;
        
        if( count == 0 ){ // first line
            penultimateAX = dxPrev;
            penultimateAY = dyPrev;
            lastAntiX     = ex;
            lastAntiY     = ey; 
            penultimateCX = dx;
            penultimateCY = dy;
            lastClockX    = exPrev;
            lastClockY    = eyPrev;
            triangle2DFill( dxPrev, dyPrev, dx, dy, ex, ey 
                #if contour_debug ,debugCol8 #end );
            triangle2DFill( dxPrev, dyPrev, dx, dy, exPrev, eyPrev 
                #if contour_debug ,debugCol12 #end );
        } else {
            if( clockWise && !lastClock ){
                penultimateAX = jx;
                penultimateAY = jy;
                lastAntiX     = ex;
                lastAntiY     = ey;
                penultimateCX = dx;
                penultimateCY = dy;
                lastClockX    = exPrev;
                lastClockY    = eyPrev;
                // FIXED
                triangle2DFill( jx, jy, dx, dy, ex, ey 
                    #if contour_debug ,debugCol8 #end );
                triangle2DFill( jx, jy, dx, dy, exPrev, eyPrev 
                    #if contour_debug ,debugCol12 #end );
            }
            if( clockWise && lastClock ){
                penultimateAX = jx;
                penultimateAY = jy;
                lastAntiX     = ex;
                lastAntiY     = ey;
                penultimateCX = dx;
                penultimateCY = dy;
                lastClockX    = exPrev;
                lastClockY    = eyPrev;
                // FIXED 
                triangle2DFill( jx, jy, dx, dy, ex, ey 
                    #if contour_debug ,debugCol8 #end );
                triangle2DFill( jx, jy, dx, dy, exPrev, eyPrev 
                    #if contour_debug ,debugCol12 #end );
            }
            if( !clockWise && !lastClock ){
                penultimateCX = dx;
                penultimateCY = dy;
                lastClockX    = jx;
                lastClockY    = jy;
                penultimateAX = dxPrev;
                penultimateAY = dyPrev;
                lastAntiX     = ex;
                lastAntiY     = ey;
                // FIXED 
                triangle2DFill( dxPrev, dyPrev, dx, dy, jx, jy 
                    #if contour_debug ,debugCol8 #end );
                triangle2DFill( dxPrev, dyPrev, dx, dy, ex, ey 
                    #if contour_debug ,debugCol12 #end );
            }
            if( !clockWise && lastClock ){
                penultimateAX = dxPrev;
                penultimateAY = dyPrev;
                lastAntiX     = ex;
                lastAntiY     = ey;
                
                penultimateCX = jx;
                penultimateCY = jy;
                lastClockX    = dx;
                lastClockY    = dy;
                
                triangle2DFill( jx, jy, dx, dy, ex, ey 
                    #if contour_debug ,debugCol8 #end );
                triangle2DFill( dxPrev, dyPrev, jx, jy, ex, ey 
                    #if contour_debug ,debugCol12 #end );
            }
        }
    }
    
    public function endEdges(){
        var pC = pointsClock.length;
        var pA = pointsAnti.length;
        pointsClock[ pC++ ] = penultimateCX;
        pointsClock[ pC++ ] = penultimateCY;
        pointsClock[ pC++ ] = lastClockX;
        pointsClock[ pC++ ] = lastClockY;
        pointsAnti[  pA++ ] = penultimateAX;
        pointsAnti[  pA++ ] = penultimateAY;
        pointsAnti[  pA++ ] = lastAntiX;
        pointsAnti[  pA++ ] = lastAntiY; 
    }
    /* numbering requires reworking SevenSeg, and it's quite heavy comment out for now
    #if contour_includeSegments
    inline
    function addNumbering( x0: Float, y0: Float, num: Int, width_: Float ){
        var w = width_*smallDotScale*4;
        var seven = new SevenSeg( w, (12/8)*w );
        seven.addNumber( num, x0 - width_/3, y0 );
        addArray( seven.triArr );
    }
    #end
    */
    var counter = 0;
    // replace the section quads with quads with both inner points
    // inline 
    function addQuads( clockWise: Bool, width_: Float ){
        //return;
        // 7 = clock side
        // 6 = antiClock side
        
        // Store current position of trianges drawn
        var currQuadIndex = pen.pos;
        
        var pC = 0;
        var pA = 0;
        if( clockWise && !lastClock ){
            if( count == 1 ){ // deals with first case
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = jx;
                pointsAnti[ pA++ ] = jy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = kbx;
                pointsClock[ pC++ ] = kby;
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy; 
                
                pen.pos = quadIndex + 1;
                triangle2DFill( kax, kay, kbx, kby, ncx, ncy #if contour_debug ,debugCol7 #end );
                // untested
                // addDebugLine( kbx, kby, ncx, ncy, width_, 3 ); 
            } else {
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = jx;
                pointsAnti[ pA++ ] = jy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = jxOld;
                pointsClock[ pC++ ] = jyOld;
                pointsClock[ pC++ ] = kbx;
                pointsClock[ pC++ ] = kby;
                
                pen.pos = quadIndex + 1;
                triangle2DFill( kax, kay, kbx, kby, jxOld, jyOld #if contour_debug ,debugCol7 #end );
                //addDebugLine( kbx, kby,jxOld, jyOld, width_, 3 );
                //addDebugLine( jxOld, jyOld, kbx, kby, width_, 3 );
            }
            pen.pos = quadIndex;
            triangle2DFill( kax, kay, kbx, kby, jx, jy #if contour_debug ,debugCol6 #end );
            //addDebugLine( jx, jy, kax, kay, width_, 4 );
            //addDebugLine( kax, kay, jx, jy, width_, 4 );
        }
        if( clockWise && lastClock ){
            if( count == 1 ){
                // to check
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = jx;
                pointsAnti[ pA++ ] = jy;
                pointsAnti[ pA++ ] = kbx;
                pointsAnti[ pA++ ] = kby;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = kax;
                pointsClock[ pC++ ] = kay;
                pointsClock[ pC++ ] = kbx;
                pointsClock[ pC++ ] = kby;
                
                pen.pos = quadIndex;
                triangle2DFill( kax, kay, kbx, kby, jx, jy #if contour_debug ,debugCol6 #end );
                pen.pos = quadIndex + 1;
                triangle2DFill( kax, kay, kbx, kby, ncx, ncy #if contour_debug ,debugCol7 #end );
                // addDebugLine( kbx, kby, jx, jy, width_, 4 ); //NOT USED STILL TO TEST
            } else {
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = jxOld;
                pointsAnti[ pA++ ] = jyOld;
                pointsAnti[ pA++ ] = jx;
                pointsAnti[ pA++ ] = jy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy;
                pointsClock[ pC++ ] = kbx;
                pointsClock[ pC++ ] = kby;
                
                pen.pos = quadIndex;
                triangle2DFill( jxOld, jyOld, kbx, kby, jx, jy #if contour_debug ,debugCol6 #end );
                
                pen.pos = quadIndex + 1;
                triangle2DFill( jxOld, jyOld, kbx, kby, ncx, ncy #if contour_debug ,debugCol7 #end );
                // used reverse 3,4kax, kay,
                //addDebugLine( jx, jy, jxOld, jyOld, width_, 4 );
                // used reverse 3,4,5 ... does not go right in other direction
                //addDebugLine( kbx, kby, ncx, ncy , width_, 3 );
            }
        }
        
        if( !clockWise && !lastClock ){
            
            pen.pos = quadIndex;
            triangle2DFill( kax, kay, jx, jy, kcx, kcy #if contour_debug ,debugCol6 #end );
            // used 1,2,3 reverse 1, 2  correct :)
            //addDebugLine( kax, kay, kcx, kcy, width_, 4 );
            if( count == 1 ){
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = kcx;
                pointsAnti[ pA++ ] = kcy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy;
                pointsClock[ pC++ ] = jx;
                pointsClock[ pC++ ] = jy;
                pen.pos = quadIndex + 1;
                triangle2DFill( kax, kay, jx, jy, ncx, ncy #if contour_debug ,debugCol7 #end );
                //addDebugLine( ncx, ncy, jx, jy, width_, 3 );
            } else {
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = kcx;
                pointsAnti[ pA++ ] = kcy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = jxOld;
                pointsClock[ pC++ ] = jyOld;
                pointsClock[ pC++ ] = jx;
                pointsClock[ pC++ ] = jy;
                pen.pos = quadIndex + 1;
                triangle2DFill( kax, kay, jx, jy, jxOld, jyOld #if contour_debug ,debugCol7 #end );
                //addDebugLine( jxOld, jyOld, jx, jy, width_, 3 );
            }
        }
        // NO IDEA IF THIS ONE WORKS!!!
        if( !clockWise && lastClock ){
            if( count == 1 ){
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kcx;
                pointsAnti[ pA++ ] = kcy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = jx;
                pointsClock[ pC++ ] = jy;
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy;
                pen.pos = quadIndex;
                triangle2DFill( kax, kay, jx, jy, kcx, kcy #if contour_debug ,debugCol6 #end );
                pen.pos = quadIndex + 1;
                triangle2DFill( kax, kay, jx, jy, ncx, ncy #if contour_debug ,debugCol7 #end );
            } else {
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = jxOld;
                pointsAnti[ pA++ ] = jyOld;
                pointsAnti[ pA++ ] = kcx;
                pointsAnti[ pA++ ] = kcy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = jx;
                pointsClock[ pC++ ] = jy;
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy;
                pen.pos = quadIndex;
                triangle2DFill( jxOld, jyOld, jx, jy, kcx, kcy #if contour_debug ,debugCol6 #end );
                pen.pos = quadIndex + 1;
                triangle2DFill( jxOld, jyOld, jx, jy, ncx, ncy #if contour_debug ,debugCol7 #end );
            }
        }
        // reset pen pos
        pen.pos = currQuadIndex;
        
    }
    inline function storeLastQuads(){
        kax = dxPrev;
        kay = dyPrev;
        kbx = dx;
        kby = dy;
        ncx = exPrev;
        ncy = eyPrev;
        kcx = ex;
        kcy = ey;
    }
    inline function isClockwise( x: Float, y: Float ): Bool {
         return dist( dxOld, dyOld, x, y ) > dist( exOld, eyOld, x, y );
    }
    
    public inline 
    function line( ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, ?endLineCurve: StyleEndLine = no ){
                    // thick
        ax = bx_;
        ay = by_;
        bx = ax_;
        by = ay_;
        halfA = Math.PI/2;
        // thickness
        beta = Math.PI/2 - halfA;
        r = ( width_/2 )*Math.cos( beta );
        // 
        computeDE();
        var dxPrev_ = dx;
        var dyPrev_ = dy;
        var exPrev_ = ex;
        var eyPrev_ = ey;
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        ax = ax_;
        ay = ay_;
        bx = bx_;
        by = by_;
        computeDE();
        switch( endLineCurve ){
            case StyleEndLine.no: 
                // don't draw ends
            case StyleEndLine.begin: 
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                
            case StyleEndLine.end:
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.both:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.halfRound:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI/2, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI/2, SMALL );
            /*case StyleEndLine.bottomHalfRound:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );*/
            case StyleEndLine.triangleBegin:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
            case StyleEndLine.triangleEnd:
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.triangleBoth:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.arrowBegin:
                 addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
            case StyleEndLine.arrowEnd:
                 addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.arrowBoth:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.quadrant:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI/2, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI/2, SMALL );
                //UNTESTED
            case StyleEndLine.circleBegin:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
            case StyleEndLine.circleEnd:
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.circleBoth:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.squareBegin:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
            case StyleEndLine.squareEnd:
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.squareBoth:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.ellipseBegin: 
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
            
            case StyleEndLine.ellipseEnd:
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case StyleEndLine.ellipseBoth:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
                // END UNTESTED
            /*case StyleEndLine.bottomRounded:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );*/
        }
        triangle2DFill( dxPrev_, dyPrev_, dx, dy, exPrev_, eyPrev_ );
        triangle2DFill( dxPrev_, dyPrev_, dx, dy, ex, ey );
    }
    public inline
    function mitreDraw( ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, clockWise: Bool ){
        if( jx != null && jy != null ){
        // bx_, by_ currently not required... but incase.
        // work out the opposite point to j, ie the mitre corner.
        //   calculate the difference from centre
        var deltaX = ax_ - jx;
        var deltaY = ay_ - jy;
        //   reflect j in relation to a
        var mitreCornerX = ax_ + deltaX;
        var mitreCornerY = ay_ + deltaY;
        // calculate distance between mitreCorner and centre a.
        var distXY = Math.sqrt(deltaX*deltaX + deltaY*deltaY);
        // calculate the miter cut off distance.
        var mitreVal = mitreLimit*width_/2;
        // see if it is applicable
        var mitreLimited = distXY > mitreVal;
        // find the ratio for extending the lines to the mitre cut off. 
        var mitreRatio = mitreVal/distXY; 
        if( clockWise ){
            if( !mitreLimited ) { // simple case no mitre cropped
                triangle2DFill( dxOld, dyOld, mitreCornerX, mitreCornerY, exPrev, eyPrev );
            } else {
                var deltaX1 = dxOld  + mitreRatio*( mitreCornerX - dxOld );
                var deltaY1 = dyOld  + mitreRatio*( mitreCornerY - dyOld );
                var deltaX2 = exPrev + mitreRatio*( mitreCornerX - exPrev );
                var deltaY2 = eyPrev + mitreRatio*( mitreCornerY - eyPrev );
                // split mitre cropped into two triangle from the first line to the crop 
                triangle2DFill( dxOld, dyOld, deltaX1, deltaY1, deltaX2, deltaY2 );
                // from the first line to second crop point and then to second line
                triangle2DFill( dxOld, dyOld, deltaX2, deltaY2, exPrev, eyPrev );
            }
            // draw normal triangle corner 
            triangle2DFill( dxOld, dyOld, exPrev, eyPrev, jx, jy );
        } else {
            if( !mitreLimited ) { // see notes above
                triangle2DFill( exOld, eyOld, mitreCornerX, mitreCornerY, dxPrev, dyPrev );
            } else {
                var deltaX1 = exOld  + mitreRatio*( mitreCornerX - exOld );
                var deltaY1 = eyOld  + mitreRatio*( mitreCornerY - eyOld );
                var deltaX2 = dxPrev + mitreRatio*( mitreCornerX - dxPrev );
                var deltaY2 = dyPrev + mitreRatio*( mitreCornerY - dyPrev );
                triangle2DFill( exOld, eyOld, deltaX1, deltaY1, deltaX2, deltaY2 );
                triangle2DFill( exOld, eyOld, deltaX2, deltaY2, dxPrev, dyPrev );
            }
            triangle2DFill( exOld, eyOld, dxPrev, dyPrev, jx, jy );
        }
        }
    }
    // moved from Shaper and modified to do color at same time.
    public inline
    function circle( ax: Float, ay: Float
                   , radius: Float
                   , color = -1, ?sides: Int = 36, ?omega: Float = 0. ): Int {
        var pi: Float = Math.PI;
        var theta: Float = pi/2 + omega;
        var step: Float = pi*2/sides;
        var bx = 0.;
        var by = 0.;
        var cx = 0.;
        var cy = 0.;
        for( i in 0...sides ){
            bx = ax + radius*Math.sin( theta );
            by = ay + radius*Math.cos( theta );
            theta += step;
            cx = ax + radius*Math.sin( theta );
            cy = ay + radius*Math.cos( theta );
            triangle2DFill( ax, ay, bx, by, cx, cy, color );
        }
        return sides;
    }
    /**
     * When calling Pie you can specify the DifferencePreference of what should be colored in terms of the two angles provided.
     * For example for drawing a packman shape you would want the use DifferencePreference.LARGE .
     **/
    public inline
    function pie( ax: Float, ay: Float
                , radius: Float, beta: Float, gamma: Float
                , prefer: DifferencePreference 
                , color: Int = -1
                , ?sides: Int = 36 ): Int {
        // choose a step size based on smoothness ie number of sides expected for a circle
        var pi = Math.PI;
        var step = pi*2/sides;
        var dif = Angles.differencePrefer( beta, gamma, prefer );
        var positive = ( dif >= 0 );
        var totalSteps = Math.ceil( Math.abs( dif )/step );
        // adjust step with smaller value to fit the angle drawn.
        var step = dif/totalSteps;
        var angle: Float = beta;
        var cx = 0.;
        var cy = 0.;
        var bx = 0.;
        var by = 0.;
        
        var dx = ax + radius*Math.sin( angle );
        var dy = ay + radius*Math.cos( angle );
        //if( !( endLine == StyleEndLine.triangleBoth 
        //    || endLine == StyleEndLine.triangleBegin ){
        for( i in 0...totalSteps+1 ){
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            if( i != 0 ){ // start on second iteration after b is populated.
                triangle2DFill( ax, ay, bx, by, cx, cy, color );
            }
            angle = angle + step;
            bx = cx;
            by = cy;
        } 
        /*} else {//( endLine == StyleEndLine.triangleBoth ){
            angle = beta - step*totalSteps/2;
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            triangle2DFill( ax, ay, bx, by, dx, dy, color );
            bx = cx;
            by = cy;
            angle -= step*totalSteps/2;
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            triangle2DFill( ax, ay, bx, by, cx, cy, color );
            totalSteps += 2;
        }*/
        // TODO: does this require halfRound??
        /*
        if( endLine == StyleEndLine.halfRound ){
            angle = angle + step*totalSteps/2-step;
            cx = ax + radius*Math.sin( angle )*(Math.sqrt(2));
            cy = ay + radius*Math.cos( angle )*(Math.sqrt(2));
            triangle2DFill( ax, ay, bx, by, cx, cy, color );
            bx = cx;
            by = cy;
            angle += step*(totalSteps/2);
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            triangle2DFill( ax, ay, bx, by, cx, cy, color );
            totalSteps += 2;
        }
        */
        
        return totalSteps;
    }
    /**
     * When calling Pie you can specify the DifferencePreference of what should be colored in terms of the two angles provided.
     * For example for drawing a packman shape you would want the use DifferencePreference.LARGE .
     **/
    public //inline
    function startShape( ax: Float, ay: Float
                 , radius:   Float, beta: Float, gamma: Float
                 , prefer:   DifferencePreference
                 , edgePoly: Array<Float>
                 , color: Int = -1
                 , ?sides: Int = 36 ): Int {
        // choose a step size based on smoothness ie number of sides expected for a circle
        var pi = Math.PI;
        var step = pi*2/sides;
        var dif = Angles.differencePrefer( beta, gamma, prefer );
        var positive = ( dif >= 0 );
        var totalSteps = Math.ceil( Math.abs( dif )/step );
        // adjust step with smaller value to fit the angle drawn.
        var step = dif/totalSteps;
        var angle: Float = beta;
        var beta2 = 0.;
        if( endLine.isEllipseBeginBoth ) {
            angle = Math.PI/2;
            beta2 = 2*Math.PI - beta + Math.PI/2;
        }
        var cx = 0.;
        var cy = 0.;
        var bx = 0.;
        var by = 0.;
        var p2 = edgePoly.length;
        var ex = 0.;
        var ey = 0.;
        var fx = 0.;
        var fy = 0.;
        var gx = 0.;
        var gy = 0.;
        var delta = 0.;
        if( endLine.isCircleBeginBoth ){
            var angle2 = beta - step*totalSteps/2;
            fx = ax - 0.75*endCapFactor*radius*Math.sin( angle2 );
            fy = ay - 0.75*endCapFactor*radius*Math.cos( angle2 );
            radius = radius*2;
            delta = Math.pow( radius/2, 2 );
        }
        
        if( !endLine.isStraightEdgesBegins ){
                if( endLine == StyleEndLine.quadrant ){//|| endLine == StyleEndLine.bottomRounded ){
                    var angle2 = beta - 2*step*totalSteps;
                    //if( endLine == StyleEndLine.bottomRounded ) angle2 -= Math.PI/2;
                    ax = ax + radius*Math.sin( angle2 );
                    ay = ay + radius*Math.cos( angle2 );
                    radius *= 2;
                }
        for( i in 0...totalSteps+1 ){
            if( endLine.isCircleBeginBoth ){
                cx = fx + 0.5*endCapFactor*radius*Math.sin( angle );
                cy = fy + 0.5*endCapFactor*radius*Math.cos( angle );
                ex = fx - 0.5*endCapFactor*radius*Math.sin( angle );
                ey = fy - 0.5*endCapFactor*radius*Math.cos( angle );
            } else if( endLine.isEllipseBeginBoth ){
                var ry = endCapFactor*radius;
                cx = ax + radius*Math.sin( angle );
                cy = ay + ry*Math.cos( angle );
                var cos = Math.cos( beta2 );
                var sin = Math.sin( beta2 );
                cx -= ax;
                cy -= ay;
                var ccx  = cx;
                var ccy  = cy;
                cx  = ccx * cos - ccy * sin;
                cy  = ccx * sin + ccy * cos; 
                cx += ax;
                cy += ay;
            } else {
                cx = ax + radius*Math.sin( angle );
                cy = ay + radius*Math.cos( angle );
            }
            edgePoly[ p2++ ] = cx;
            edgePoly[ p2++ ] = cy;
            if( i != 0 ){ // start on second iteration after b is populated.
                triangle2DFill( ax, ay, bx, by, cx, cy, color );
                if( endLine.isCircleBeginBoth ){
                    var deltaG = Math.pow( ay - gy, 2 ) + Math.pow( ax - gx, 2 );
                    var deltaE = Math.pow( ay - ey, 2 ) + Math.pow( ax - ex, 2 );
                    if( deltaE > delta || deltaG > delta ){
                        triangle2DFill( ax, ay, gx, gy, ex, ey, color );
                    }
                }
            }
            angle = angle + step;
            bx = cx;
            by = cy;
            if( endLine.isCircleBeginBoth ){
                gx = ex;
                gy = ey;
            }
        }
        /* overkill removed
        if( endLine == StyleEndLine.bottomHalfRound ){
            angle = beta - step*totalSteps/2;
            cx = ax + radius*Math.sin( angle )*(Math.sqrt(2));
            cy = ay + radius*Math.cos( angle )*(Math.sqrt(2));
            //triangle2DFill( ax, ay, bx, by, dx, dy, color );
            bx = cx;
            by = cy;
            angle -= step*totalSteps/2;
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            //triangle2DFill( ax, ay, bx, by, cx, cy, color );
            totalSteps += 2;
        }
        */
        if( endLine == StyleEndLine.halfRound ){
            angle = angle + step*totalSteps/2-step;
            cx = ax + radius*Math.sin( angle )*(Math.sqrt(2));
            cy = ay + radius*Math.cos( angle )*(Math.sqrt(2));
            triangle2DFill( ax, ay, bx, by, cx, cy, color );
            bx = cx;
            by = cy;
            angle += step*(totalSteps/2);
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            triangle2DFill( ax, ay, bx, by, cx, cy, color );
            totalSteps += 2;
        }
        } else {
            if( endLine.isArrowBeginBoth ){
                angle = beta;
                var ddx = ax - radius*endCapFactor*Math.sin( angle );
                var ddy = ay - radius*endCapFactor*Math.cos( angle );
                //circle( dx, dy, 5, 0xFFFF0000 );
                angle = beta - step*totalSteps/2;
                cx = ax - radius*endCapFactor*Math.sin( angle );
                cy = ay - radius*endCapFactor*Math.cos( angle );
                //circle( cx, cy, 5, 0xFFFF00ff );
                triangle2DFill( ddx, ddy, cx, cy, ax, ay, color );
                bx = cx;
                by = cy;
                angle += step*totalSteps/2;
                cx = ax + radius*endCapFactor*Math.sin( angle );
                cy = ay + radius*endCapFactor*Math.cos( angle );
                //circle( cx, cy, 5, 0xFFFFff00 );
                triangle2DFill( ax, ay, bx, by, cx, cy, color );
            } else if( endLine.isTriangleBeginBoth ){
                angle = beta;
                var ddx = ax - radius*Math.sin( angle );
                var ddy = ay - radius*Math.cos( angle );
                angle = beta + step*totalSteps/2;
                cx = ax + radius*Math.sin( angle );
                cy = ay + radius*Math.cos( angle );
                triangle2DFill( ddx, ddy, cx, cy, ax, ay, color );
                bx = cx;
                by = cy;
                angle -= step*totalSteps/2;
                cx = ax + radius*Math.sin( angle );
                cy = ay + radius*Math.cos( angle );
                triangle2DFill( ax, ay, bx, by, cx, cy, color );
            } else if( endLine.isSquareBeginBoth ){
                    angle = beta;
                    var ddx = ax - radius*endCapFactor*Math.sin( angle );
                    var ddy = ay - radius*endCapFactor*Math.cos( angle );
                    //circle( dx, dy, 5, 0xFFFF0000 );
                    angle = beta - step*totalSteps/2;
                    cx = ddx - 2*radius*endCapFactor*Math.sin( angle );
                    cy = ddy - 2*radius*endCapFactor*Math.cos( angle );
                    //circle( cx, cy, 5, 0xFFFF00ff );
                    //pen.triangle2DGrad( dx, dy, cx, cy, ax, ay, col.colorAnti, half, half );
                    var lastAngle = angle;
                    angle += step*totalSteps/2;
                    ex = ax + radius*endCapFactor*Math.sin( angle );
                    ey = ay + radius*endCapFactor*Math.cos( angle );
                    //circle( ex, ey, 5, 0xFFFFff00 );
                    fx = ex - 2*radius*endCapFactor*Math.sin( lastAngle );
                    fy = ey - 2*radius*endCapFactor*Math.cos( lastAngle );
                    //circle( fx, fy, 5, 0xFFFFff00 );
                    triangle2DFill( fx, fy, cx, cy, ddx, ddy, color );
                    triangle2DFill( fx, fy, ddx, ddy, ex, ey, color );
            
                } else {
                    // not applicable
                }
            totalSteps += 2;
        }
        
        return totalSteps;
    }
    /**
     * When calling Pie you can specify the DifferencePreference of what should be colored in terms of the two angles provided.
     * For example for drawing a packman shape you would want the use DifferencePreference.LARGE .
     **/
    public inline
    function endShape( ax: Float, ay: Float
                 , radius:   Float, beta: Float, gamma: Float
                 , prefer:   DifferencePreference
                 , edgePoly: Array<Float>
                 , color: Int = -1
                 , ?sides: Int = 36 ): Int {
        // choose a step size based on smoothness ie number of sides expected for a circle
        var pi = Math.PI;
        var step = pi*2/sides;
        var dif = Angles.differencePrefer( beta, gamma, prefer );
        var positive = ( dif >= 0 );
        var totalSteps = Math.ceil( Math.abs( dif )/step );
        // adjust step with smaller value to fit the angle drawn.
        var step = dif/totalSteps;
        var angle: Float = beta;
        var beta2 = 0.;
        if( endLine.isEllipseEndBoth ) {
            angle = Math.PI/2;
            beta2 = 2*Math.PI - beta + Math.PI/2;
        }
        var cx = 0.;
        var cy = 0.;
        var bx = 0.;
        var by = 0.;
        var p2 = edgePoly.length;
        var ex = 0.;
        var ey = 0.;
        var fx = 0.;
        var fy = 0.;
        var gx = 0.;
        var gy = 0.;
        var delta = 0.;
        if( endLine.isCircleEndBoth ){
            var angle2 = beta - step*totalSteps/2;
            fx = ax - 0.75*endCapFactor*radius*Math.sin( angle2 );
            fy = ay - 0.75*endCapFactor*radius*Math.cos( angle2 );
            radius = radius*2;
            delta = Math.pow( radius/2, 2 );
        }
        
        var ddx = ax + radius*Math.sin( angle );
        var ddy = ay + radius*Math.cos( angle );
        
        
         if( !endLine.isStraightEdgesEnds ){
                 if( endLine == StyleEndLine.quadrant ){//|| endLine == StyleEndLine.bottomRounded ){
                     var angle2 = beta - 2*step*totalSteps;
                     //if( endLine == StyleEndLine.bottomRounded ) angle2 -= Math.PI/2;
                     ax = ax + radius*Math.sin( angle2 );
                     ay = ay + radius*Math.cos( angle2 );
                     radius *= 2;
                 }
        
        for( i in 0...totalSteps+1 ){
            if( endLine.isCircleEndBoth ){
                cx = fx + 0.5*endCapFactor*radius*Math.sin( angle );
                cy = fy + 0.5*endCapFactor*radius*Math.cos( angle );
                ex = fx - 0.5*endCapFactor*radius*Math.sin( angle );
                ey = fy - 0.5*endCapFactor*radius*Math.cos( angle );
            } else if( endLine.isEllipseEndBoth ){
                var ry = endCapFactor*radius;
                cx = ax + radius*Math.sin( angle );
                cy = ay + ry*Math.cos( angle );
                var cos = Math.cos( beta2 );
                var sin = Math.sin( beta2 );
                cx -= ax;
                cy -= ay;
                var ccx  = cx;
                var ccy  = cy;
                cx  = ccx * cos - ccy * sin;
                cy  = ccx * sin + ccy * cos; 
                cx += ax;
                cy += ay;
            } else {
                cx = ax + radius*Math.sin( angle );
                cy = ay + radius*Math.cos( angle );
            }
            edgePoly[ p2++ ] = cx;
            edgePoly[ p2++ ] = cy;
            if( i != 0 ){ // start on second iteration after b is populated.
                triangle2DFill( ax, ay, bx, by, cx, cy, color );
                
                if( endLine.isCircleEndBoth ){
                    var deltaG = Math.pow( ay - gy, 2 ) + Math.pow( ax - gx, 2 );
                    var deltaE = Math.pow( ay - ey, 2 ) + Math.pow( ax - ex, 2 );
                    if( deltaE > delta || deltaG > delta ){
                        triangle2DFill( ax, ay, gx, gy, ex, ey, color );
                    }
                }
            }
            angle = angle + step;
            bx = cx;
            by = cy;
            if( endLine.isCircleEndBoth ){
                gx = ex;
                gy = ey;
            }
        }
        /* Overkill removed
        if( endLine == StyleEndLine.bottomHalfRound ){
            angle = beta - step*totalSteps/2;
            cx = ax + radius*Math.sin( angle )*(Math.sqrt(2));
            cy = ay + radius*Math.cos( angle )*(Math.sqrt(2));
            //triangle2DFill( ax, ay, bx, by, dx, dy, color );
            bx = cx;
            by = cy;
            angle -= step*totalSteps/2;
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            //triangle2DFill( ax, ay, bx, by, cx, cy, color );
            totalSteps += 2;
        }
        */
        if( endLine == StyleEndLine.halfRound ){
            angle = angle + step*totalSteps/2 - step;
            cx = ax + radius*Math.sin( angle )*(Math.sqrt(2));
            cy = ay + radius*Math.cos( angle )*(Math.sqrt(2));
            triangle2DFill( ax, ay, bx, by, cx, cy, color );
            bx = cx;
            by = cy;
            angle += step*(totalSteps/2);
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            triangle2DFill( ax, ay, bx, by, cx, cy, color );
            totalSteps += 2;
        } 
        } else {//( endLine == StyleEndLine.triangleBoth ){
            if( endLine == arrowBoth || endLine == arrowEnd ){
                angle = beta;
                var dx = ax - radius*endCapFactor*Math.sin( angle );
                var dy = ay - radius*endCapFactor*Math.cos( angle );
                //circle( dx, dy, 5, 0xFFFF0000 );
                angle = beta - step*totalSteps/2;
                cx = ax - radius*endCapFactor*Math.sin( angle );
                cy = ay - radius*endCapFactor*Math.cos( angle );
                //circle( cx, cy, 5, 0xFFFF00ff );
                triangle2DFill( ddx, ddy, cx, cy, ax, ay, color );
                bx = cx;
                by = cy;
                angle += step*totalSteps/2;
                cx = ax + radius*endCapFactor*Math.sin( angle );
                cy = ay + radius*endCapFactor*Math.cos( angle );
                //circle( cx, cy, 5, 0xFFFFff00 );
                triangle2DFill( ax, ay, bx, by, cx, cy, color );
            } else if( endLine.isTriangleEndBoth ){
                angle = beta;
                var dx = ax - radius*Math.sin( angle );
                var dy = ay - radius*Math.cos( angle );
                //circle( dx, dy, 5, 0xFFFF0000 );
                angle = beta - step*totalSteps/2;
                cx = ax - radius*Math.sin( angle );
                cy = ay - radius*Math.cos( angle );
                //circle( cx, cy, 5, 0xFFFF00ff );
                triangle2DFill( ddx, ddy, cx, cy, ax, ay, color );
                bx = cx;
                by = cy;
                angle += step*totalSteps/2;
                cx = ax + radius*Math.sin( angle );
                cy = ay + radius*Math.cos( angle );
                //circle( cx, cy, 5, 0xFFFFff00 );
                triangle2DFill( ax, ay, bx, by, cx, cy, color );
            } else if( endLine.isSquareEndBoth ){
               angle = beta;
               var dx = ax - radius*endCapFactor*Math.sin( angle );
               var dy = ay - radius*endCapFactor*Math.cos( angle );
               //circle( dx, dy, 5, 0xFFFF0000 );
               angle = beta - step*totalSteps/2;
               cx = dx - 2*radius*endCapFactor*Math.sin( angle );
               cy = dy - 2*radius*endCapFactor*Math.cos( angle );
               //circle( cx, cy, 5, 0xFFFF00ff );
               //pen.triangle2DGrad( dx, dy, cx, cy, ax, ay, col.colorAnti, half, half );
               var lastAngle = angle;
               angle += step*totalSteps/2;
               ex = ax + radius*endCapFactor*Math.sin( angle );
               ey = ay + radius*endCapFactor*Math.cos( angle );
               //circle( ex, ey, 5, 0xFFFFff00 );
               fx = ex - 2*radius*endCapFactor*Math.sin( lastAngle );
               fy = ey - 2*radius*endCapFactor*Math.cos( lastAngle );
               //circle( fx, fy, 5, 0xFFFFff00 );
               triangle2DFill( fx, fy, cx, cy, ddx, ddy, color );
               triangle2DFill( fx, fy, ddx, ddy, ex, ey, color );

           } else {
               // not applicable
           }
            totalSteps += 2;
            
        }
        return totalSteps;
    }
    public inline
    function pieDifX( ax: Float, ay: Float
                    , radius: Float, beta: Float, dif: Float
                    , edgePoly: Array<Float>
                    , color: Int = -1
                    , ?sides: Int = 36 ): Int {
        // choose a step size based on smoothness ie number of sides expected for a circle
        var pi = Math.PI;
        var step = pi*2/sides;
        var positive = ( dif >= 0 );
        var totalSteps = Math.ceil( Math.abs( dif )/step );
        // adjust step with smaller value to fit the angle drawn.
        var step = dif/totalSteps;
        var angle: Float = beta;
        var cx = 0.;
        var cy = 0.;
        var bx = 0.;
        var by = 0.;
        var p2 = edgePoly.length;
        for( i in 0...totalSteps+1 ){
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            edgePoly[ p2++ ] = cx;
            edgePoly[ p2++ ] = cy;
            if( i != 0 ){ // start on second iteration after b is populated.
                triangle2DFill( ax, ay, bx, by, cx, cy, color );
            }
            angle = angle + step;
            bx = cx;
            by = cy;
        }
        
        return totalSteps;
    }
}

