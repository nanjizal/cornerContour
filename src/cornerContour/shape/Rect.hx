package cornerContour.shape;
import cornerContour.shape.Pie;

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
    // TODO: need to adjust to a pie that accepts rx, ry
    var radius = rx; 
    count += pie( pen, ax, ay, radius, -pi, -pi_2, CLOCKWISE, pen );
    count += pie( pen, bx, by, radius, pi_2, pi,   CLOCKWISE, pen );
    count += pie( pen, cx, cy, radius, pi_2, 0,  ANTICLOCKWISE, pen );
    count += pie( pen, dx, dy, radius, 0, -pi_2, ANTICLOCKWISE, pen );
    return count;
}
inline
function roundedRectangleOutline( paintType: PaintType
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
    count += rectangle( paintType, ax, y, width - rx*2, thick );
    count += rectangle( paintType, ax, y + height - thick, width - rx*2, thick );
    var dimY = height - 2*ry;
    count += rectangle( paintType, x,  ay, thick, dimY );
    count += rectangle( paintType, x + width - thick, by, thick, dimY );
    // TODO: need to adjust to a pie that accepts rx, ry
    count += arc( paintType, ax, ay, radius, thick, -pi, -pi_2, CLOCKWISE );
    count += arc( paintType, bx, by, radius, thick, pi_2, pi,   CLOCKWISE );
    count += arc( paintType, cx, cy, radius, thick, pi_2, 0, ANTICLOCKWISE );
    count += arc( paintType, dx, dy, radius, thick, 0, -pi_2,ANTICLOCKWISE );
    return count;
}
