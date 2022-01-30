package cornerContour.drawTarget;
import cornerContour.Pen2D;
import cornerContour.color.ColorHelp;
    
inline
function rearrangeDrawData( pen2D: Pen2D, g: cornerContour.web.Surface ){
    var pen = pen2D;
    var data = pen.arr;
    var totalTriangles = Std.int( data.size/7 );
    for( i in 0...totalTriangles ){
        pen.pos = i;
        // draw to canvas surface
        var alpha: Float = getAlpha( data.color );
        g.triangle2DFillandAlpha( data.ax, data.ay
            , data.bx, data.by
            , data.cx, data.cy
            , getColor( data.color ), getAlpha( data.color ) );
    }
}