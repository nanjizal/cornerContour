package cornerContour.drawTarget;
import cornerContour.Pen2D;
import cornerContour.color.ColorHelp;
import hxPixels.Pixels;
import pixelDrawing.Triangle;

inline
function rearrageDrawData( pen2D: Pen2D, g: hxPixels.Pixels ){
    var pen = pen2D;
    var data = pen.arr;
    var totalTriangles = Std.int( data.size/7 );
    var color_: Int = 0;
    var alpha_: Float = 1.;
    for( i in 0...totalTriangles ){
        pen.pos = i;
        // draw to canvas surface
        var arr = [ data.ax, data.ay, data.bx, data.by, data.cx, data.cy ];
        var t = new Triangle( g, arr );
        color_ = rgbInt( Std.int( data.color ) );
        alpha_ = getAlpha( data.color );
        // not working yet??
        t.alpha( color_, alpha_ );
        t.plot( color_, alpha_, 3 );
    }
}