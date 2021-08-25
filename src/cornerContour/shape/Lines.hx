package cornerContour.shape;
import cornerContour.shape.Quads;
import cornerContour.IPen;
import cornerContour.shape.structs.XY;
import cornerContour.shape.structs.Quad2D;

inline 
function lineAB( pen: IPen
               , A: XY, B: XY
               , width: Float, ?color: Null<Int> ): Int {
    var q = lineABmath( A, B, width );
    return quadDraw( pen, q, color );
}
inline 
function lineXY( pen: IPen
               , ax: Float, ay: Float, bx: Float, by: Float
               , width: Float, ?color: Null<Int> ): Int {
    var q = lineABCoordMath( ax, ay, bx, by, width );
    return quadDraw( pen, q, color );
}
// may not be most optimal
inline
function lineABmath( A: XY, B: XY, width: Float ): Quad2D {
    var dx: Float = A.x - B.x;
    var dy: Float = A.y - B.y;
    var P: XY = { x:A.x - width/2, y:A.y };
    var omega = Math.atan2( dy, dx ); // may need angle correction.
    var dim: XY = { x: width, y: dx*dx + dy*dy };
    return rotateVectorLine( P, dim, omega, A.x + width/2, A.y );
}
// may not be most optimal
inline
function lineABCoordMath( ax: Float, ay: Float, bx: Float, by: Float, width: Float ):Quad2D {
    var dx: Float = ax - bx;
    var dy: Float = ay - by;
    var P: XY = { x:ax - width/2, y:ay };
    var omega = Math.atan2( dy, dx ); // may need angle correction.
    var dim: XY = { x: width, y: dx*dx + dy*dy };
    return rotateVectorLine( P, dim, omega, ax + width/2, ay );
}
inline
function rotateVectorLine( pos: XY, dim: XY, omega: Float, pivotX: Float, pivotY: Float ): Quad2D {
    //   A   B
    //   D   C
    var px = pos.x;
    var py = pos.y;
    var dx = dim.x;
    var dy = dim.y;
    var A_: XY = { x: px,        y: py };
    var B_: XY = { x: px + dx,   y: py };
    var C_: XY = { x: px + dx,   y: py + dy };
    var D_: XY = { x: px,        y: py + dy };
    if( omega != 0. ){
        var sin = Math.sin( omega );
        var cos = Math.cos( omega );
        A_ = pivotCheap( A_, sin, cos, pivotX, pivotY );
        B_ = pivotCheap( B_, sin, cos, pivotX, pivotY );
        C_ = pivotCheap( C_, sin, cos, pivotX, pivotY );
        D_ = pivotCheap( D_, sin, cos, pivotX, pivotY );
    }
    return { a:A_, b:B_, c:C_, d:D_ };
}
inline
function pivotCheap( p: XY, sin: Float, cos: Float, pivotX: Float, pivotY: Float ): XY {
    var px = p.x - pivotX;
    var py = p.y - pivotY;
    var px2 = px * cos - py * sin;
    py = py * cos + px * sin;
    return { x: px2 + pivotX, y: py + pivotY };
}
class Lines {
    public var lineAB_: ( pen: IPen
                        , A: XY, B: XY
                        , width: Float, ?color: Null<Int> ) -> Int = lineAB;
    public var lineXY_: ( pen: IPen
                        , ax: Float, ay: Float, bx: Float, by: Float
                        , width: Float, ?color: Null<Int> ) -> Int = lineXY;
}
