package cornerContour.drawTarget;
import cornerContour.Pen2D;
import cornerContour.color.ColorHelp;

inline
function rearrageDrawData( pen: Pen2D, h2d.Graphics ){
    var pen = pen2D;
    var data = pen.arr;
    var totalTriangles = Std.int( data.size/7 );
    var red    = 0.;
    var green  = 0.;
    var blue   = 0.; 
    var alpha  = 0.;
    var color: Int  = 0;
    for( i in 0...totalTriangles ){
        pen.pos = i;
        color = Std.int( data.color );
        alpha = alphaChannel( color );
        red   = redChannel(   color );
        green = greenChannel( color );
        blue  = blueChannel(  color );
        g.beginFill( 0xffffffff );
        g.addVertex( data.ax*2, data.ay*2, red, green, blue, alpha );
        g.addVertex( data.bx*2, data.by*2, red, green, blue, alpha );
        g.addVertex( data.cx*2, data.cy*2, red, green, blue, alpha );
        g.endFill();
        i++;
    }
}