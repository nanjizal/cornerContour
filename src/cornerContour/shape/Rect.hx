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
