
package cornerContour.drawTarget;
import cornerContour.Pen2D;
//import cornerContour.color.ColorHelp;
import vision.ds.Image;
import pixelDrawing.Triangle;

inline
function rearrageDrawData( pen2D: Pen2D, g: vision.ds.Image ){
    var pen = pen2D;
    var data = pen.arr;
    var totalTriangles = Std.int( data.size/7 );
    var color_: Int = 0;
    var alpha_: Float = 1.;
    for( i in 0...totalTriangles ){
        pen.pos = i;
        // draw to canvas surface
        visionFillTri( data.ax, data.ay, data.bx, data.by, data.cx, data.cy, Std.int( data.color ) );
    }
}

inline
function visionFillTri( ax: Float, ay: Float, bx: Float, cx: Float, cy: Float, color: Int ){
     var maxX = Std.int( Math.max( Math.max( ax, bx ), cx ) );
     var minX = Std.int( Math.min( Math.min( ax, bx ), cx ) );
     var maxY = Std.int( Math.max( Math.max( ay, by ), cy ) );
     var minY = Std.int( Math.min( Math.min( ay, by ), cy ) );
     var s0 = p0y*p2x - p0x*p2y;
     var sx = p2y - p0y;
     var sy = p0x - p2x;
     var t0 = p0x*p1y - p0y*p1x;
     var tx = p0y - p1y;
     var ty = p1x - p0x;
     var var A = -by*cx + ay*(-bx + cx) + ax*(by - cy) + bx*cy;
     for( x in minX...maxX ){
        for( y in minY...maxY ){
            if( hitTest( x, y, sx, sy, tx, ty, minX, maxY, minY, maxX, A ) ) Image.setPixel( Std.int( x ), Std.int( y ), col );
        }
     }
}

inline 
function hitTest( x: Float, y: Float, sx: Float, sy: Float, tx: Float, ty: Float, minX: Int, maxX: Int, minY: Int, maxY: Int, A: Float ): Bool {
    // check bounding box first.
    if( !( x > minX && x < maxX && y > minY && y < maxY ) ) return false;
    var s = s0 + sx*x + sy*y;
    var t = t0 + tx*x + ty*y;
    if (s <= 0 || t <= 0) return false;
    return (s + t) < A;
}
