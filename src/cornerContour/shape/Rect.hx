package cornerContour.shape;
import cornerContour.shape.Pies;
import fracs.Angles;

inline
function add2DQuad( pen: IPen
                  , ax: Float, ay: Float
                  , bx: Float, by: Float
                  , cx: Float, cy: Float
                  , dx: Float, dy: Float
                  , ?color: Null<Int> ): Int {
    pen.add2DTriangle( ax, ay, bx, by, dx, dy, color );
    pen.add2DTriangle( bx, by, cx, cy, dx, dy, color );
    return 2;
}
inline
function rectangle( pen: IPen
                  , x: Float, y: Float
                  , w: Float, h: Float
                  , ?color: Null<Int> ): Int {
    return add2DQuad( x, y, x + w, y, x + w, y + h, x, y + h, color );
}
//    a  b
//    d  c
inline
function squareOutline( pen: IPen
                      , px: Float, py: Float
                      , radius: Float, thick: Float
                      , ?color: Null<Int>
                      , ?theta: Null<Float> = 0 ): Int {
    var ax = 0.;
    var ay = 0.;
    var bx = 0.;
    var by = 0.;
    var cx = 0.;
    var cy = 0.;
    var dx = 0.;
    var dy = 0.;
    var a0x = 0.;
    var a0y = 0.;
    var b0x = 0.;
    var b0y = 0.;
    var c0x = 0.;
    var c0y = 0.;
    var d0x = 0.;
    var d0y = 0.;
    if( theta != 0 ){
        var pi = Math.PI;
        var pi4 = pi/4;
        var pi2 = pi/2;
        var sqrt2 = Math.sqrt( 2 );
        var r = radius*sqrt2;
        //    a
        // d     b
        //    c
        var aTheta = -pi + theta - pi4;
        var dTheta = -pi + theta + pi/2 - pi/4;
        var cTheta = theta - pi4;
        var bTheta = -pi + theta - pi2 - pi4;
        var as = Math.sin( aTheta );
        var ac = Math.cos( aTheta );
        var bs = Math.sin( bTheta );
        var bc = Math.cos( bTheta );
        var cs = Math.sin( cTheta );
        var cc = Math.cos( cTheta );
        var ds = Math.sin( dTheta );
        var dc = Math.cos( dTheta );
        var r0 = r - thick;
        ax = px + r * as;
        ay = py + r * ac;
        bx = px + r * bs;
        by = py + r * bc;
        cx = px + r * cs;
        cy = py + r * cc;
        dx = px + r * ds;
        dy = py + r * dc;
        a0x = px + r0 * as;
        a0y = py + r0 * ac;
        b0x = px + r0 * bs;
        b0y = py + r0 * bc;
        c0x = px + r0 * cs;
        c0y = py + r0 * cc;
        d0x = px + r0 * ds;
        d0y = py + r0 * dc;
    } else {
        ax = px - radius;
        ay = py - radius;
        var lx = radius*2;
        var ly = lx;
        bx = ax + lx;
        by = ay;
        cx = bx;
        cy = ay + ly;
        dx = ax;
        dy = cy;
        var radius0 = radius - thick;
        a0x = px - radius0;
        a0y = py - radius0;
        var l0x = radius0*2;
        var l0y = l0x;
        b0x = a0x + l0x;
        b0y = a0y;
        c0x = b0x;
        c0y = a0y + l0y;
        d0x = a0x;
        d0y = c0y;
    }// top 
    // c bx, b0y
    // d ax, a0y
    pen.add2DTriangle( ax, ay, bx, by, a0x, a0y, color );
    pen.add2DTriangle( bx, by, b0x, b0y, a0x, a0y, color );
    // bottom
    // a dx d0y
    // b cx c0y
    pen.add2DTriangle( d0x, d0y, c0x, c0y, dx, dy, color );
    pen.add2DTriangle( c0x, c0y, cx, cy, dx, dy, color  );
    // left
    pen.add2DTriangle( ax, ay, a0x, a0y, d0x, d0y, color );
    pen.add2DTriangle( ax, ay, d0x, d0y, dx, dy, color );
    // right
    pen.add2DTriangle( b0x, b0y, bx, by, c0x, c0y, color );
    pen.add2DTriangle( bx, by, cx, cy, c0x, c0y, color );
    return 8;
}
//    a  b
//    d  c
inline
function square( pen: IPen
               , px: Float, py: Float
               , radius: Float, 
               , ?color: Null<Int>
               , ?theta: Null<Float> = 0 ): Int {
    var ax = 0.;
    var ay = 0.;
    var bx = 0.;
    var by = 0.;
    var cx = 0.;
    var cy = 0.;
    var dx = 0.;
    var dy = 0.;
    if( theta != 0 ){
        var pi = Math.PI;
        var pi4 = pi/4;
        var pi2 = pi/2;
        var sqrt2 = Math.sqrt( 2 );
        var r = radius*sqrt2;
        //    a
        // d     b
        //    c
        var aTheta = -pi + theta - pi4;
        var dTheta = -pi + theta + pi/2 - pi/4;
        var cTheta = theta - pi4;
        var bTheta = -pi + theta - pi2 - pi4;
        ax = px + r * Math.sin( aTheta );
        ay = py + r * Math.cos( aTheta );
        bx = px + r * Math.sin( bTheta );
        by = py + r * Math.cos( bTheta );
        cx = px + r * Math.sin( cTheta );
        cy = py + r * Math.cos( cTheta );
        dx = px + r * Math.sin( dTheta );
        dy = py + r * Math.cos( dTheta );
    } else {
        ax = px - radius;
        ay = py - radius;
        var lx = radius*2;
        var ly = lx;
        bx = ax + lx;
        by = ay;
        cx = bx;
        cy = ay + ly;
        dx = ax;
        dy = cy;
    }
    return add2DQuad( pen, ax, ay, bx, by, cx, cy, dx, dy, color );
}
inline 
function diamond( pen: IPen
                , x: Float, y: Float
                , radius: Float
                , ?color: Null<Int>
                , ?theta: Float = 0. ): Int {
    return square( pen, x, y, radius, color, Math.PI/4 + theta );
}
inline 
function diamondOutline( paintType: PaintType
                       , x: Float, y: Float
                       , thick: Float
                       , radius: Float, 
                       , ?color: Null<Int>
                       , ?theta: Float = 0. ): Int {
    return squareOutline( pen, x, y, radius, thick, color, Math.PI/4 + theta );
}
// TODO: test and tweak.
inline
function roundedRectangle( pen: IPen
                         , x: Float, y: Float
                         , rx: Float, ry: Float
                         , width: Float, height: Float
                         , ?color: Null<Int> ): Int {
    // zero = down
    // clockwise seems to be wrong way round !
    // Needs fixing in Contour so can't change yet!
    // so all the angles are currently wrong!!
    var pi = Math.PI;
    var pi_2 = Math.PI/2;
    var ax = x + rx;
    var ay = y + ry;
    var bx = x + width - rx;
    var by = y + ry;
    var cx = bx;
    var cy = y + height - ry;
    var dx = ax;
    var dy = cy;
    var count = 0;
    // central fill
    count += rectangle( pen, ax, y, width - rx*2, height, color );
    var dimY = height - 2*radius;
    count += rectangle( pen, x,  ay, ry, dimY, color );
    count += rectangle( pen, bx, by, ry, dimY, color );
    count += pie( pen, ax, ay, rx, ry, -pi, -pi_2, CLOCKWISE, pen );
    count += pie( pen, bx, by, rx, ry, pi_2, pi,   CLOCKWISE, pen );
    count += pie( pen, cx, cy, rx, ry, pi_2, 0,  ANTICLOCKWISE, pen );
    count += pie( pen, dx, dy, rx, ry, 0, -pi_2, ANTICLOCKWISE, pen );
    return count;
}
inline
function roundedRectangleOutline( pen: IPen
                                , x: Float, y: Float
                                , rx: Float, ry: Float
                                , width: Float, height: Float
                                , thick: Float
                                , ?color: Null<Int> ): Int {
    // zero = down
    // clockwise seems to be wrong way round !
    // Needs fixing in Contour so can't change yet!
    // so all the angles are currently wrong!!
    var pi = Math.PI;
    var pi_2 = Math.PI/2;
    var ax = x + rx;
    var ay = y + ry;
    var bx = x + width - rx;
    var by = y + ry;
    var cx = bx;
    var cy = y + height - rx;
    var dx = ax;
    var dy = cy;
    var count = 0;
    count += rectangle( pen, ax, y, width - rx*2, thick, color );
    count += rectangle( pen, ax, y + height - thick, width - rx*2, thick, color );
    var dimY = height - 2*ry;
    count += rectangle( pen, x,  ay, thick, dimY, color );
    count += rectangle( pen, x + width - thick, by, thick, dimY, color );
    count += arc( pen, ax, ay, rx, ry, thick, -pi, -pi_2, CLOCKWISE, color );
    count += arc( pen, bx, by, rx, ry, thick, pi_2, pi,   CLOCKWISE, color );
    count += arc( pen, cx, cy, rx, ry, thick, pi_2, 0, ANTICLOCKWISE, color );
    count += arc( pen, dx, dy, rx, ry, thick, 0, -pi_2,ANTICLOCKWISE, color );
    return count;
}
