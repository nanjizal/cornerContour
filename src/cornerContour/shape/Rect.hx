package cornerContour.shape;

inline
function add2DQuad( pen: IPen
                  , ax: Float, ay: Float
                  , bx: Float, by: Float
                  , cx: Float, cy: Float
                  , dx: Float, dy: Float
                  , color: Color ): Int {
    pen.add2DTriangle( ax, ay, bx, by, dx, dy, color );
    pen.add2DTriangle( bx, by, cx, cy, dx, dy, color );
    return 2;
}
inline
function rectangle( pen: IPen
                  , x: Float, y: Float
                  , w: Float, h: Float ): Int {
    return add2DQuad( x, y, x + w, y, x + w, y + h, x, y + h, color );
}
