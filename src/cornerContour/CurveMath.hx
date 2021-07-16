package cornerContour;
inline
function distance(  px: Float, py: Float, qx: Float, qy: Float ): Float {
    var x = px - qx;
    var y = py - qy;
    return Math.sqrt( x*x + y*y );
}
var quadStep: Float = 0.03;
// Create Quadratic Curve
inline
function quadCurve( p: Array<Float>, ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ): Array<Float> {
    var step = calculateQuadStep( ax, ay, bx, by, cx, cy );
    var l = p.length;
    p[ l++ ] = ax;
    p[ l++ ] = ay;
    var t = step;
    while( t < 1. ){
        p[ l++ ] = quadratic( t, ax, bx, cx );
        p[ l++ ] = quadratic( t, ay, by, cy );
        t += step;
    }
    p[ l++ ] =  cx;
    p[ l++ ] =  cy;
    return p;
}
inline
var cubicStep: Float = 0.03;
// Create Cubic Curve
inline
function cubicCurve( p: Array<Float>, ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float, dx: Float, dy: Float ): Array<Float> {
    var step = calculateCubicStep( ax, ay, bx, by, cx, cy, dx, dy );
    var l = p.length;
    p[ l++ ] = ax;
    p[ l++ ] = ay;
    var t = step;
    while( t < 1. ){
        p[ l++ ] = cubic( t, ax, bx, cx, dx );
        p[ l++ ] = cubic( t, ay, by, cy, dy );
        t += step;
    }
    p[ l++ ] =  dx;
    p[ l++ ] =  dy;
    return p;
}
inline
function calculateQuadStep( ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ): Float {
    var approxDistance = distance( ax, ay, bx, by ) + distance( bx, by, cx, cy );
    if( approxDistance == 0 ) approxDistance = 0.000001;
    return Math.min( 1/( approxDistance*0.707 ), quadStep );
}
inline
function calculateCubicStep( ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float, dx: Float, dy: Float ): Float {
    var approxDistance = distance( ax, ay, bx, by ) + distance( bx, by, cx, cy ) + distance( cx, cy, dx, dy );
    if( approxDistance == 0 ) approxDistance = 0.000001;
    return Math.min( 1/( approxDistance*0.707 ), cubicStep );
}
inline
function quadraticThru( t: Float, s: Float, c: Float, e: Float ): Float {
    c = 2*c - 0.5*( s + e );
    return quadratic( t, s, c, e );
}
inline
function quadratic( t: Float, s: Float, c: Float, e: Float ): Float {
    var u = 1 - t;
    return Math.pow( u, 2 )*s + 2*u*t*c + Math.pow( t, 2 )*e;
}
inline
function cubic( t: Float, s: Float, c1: Float, c2: Float, e: Float ): Float {
    var u = 1 - t;
    return  Math.pow( u, 3 )*s + 3*Math.pow( u, 2 )*t*c1 + 3*u*Math.pow( t, 2 )*c2 + Math.pow( t, 3 )*e;
}