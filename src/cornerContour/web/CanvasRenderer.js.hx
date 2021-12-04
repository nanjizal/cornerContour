package cornerContour.web;
import cornerContour.web.Surface;
import cornerContour.Pen2D;

@:structInit
private class CanvasRenderer_ {
    public var surface:          Surface;
    public var pen:              Pen2D;
    public var width:            Float;
    public var height:           Float;
    public function new( surface: Surface, pen: Pen2D, width: Float, height: Float ){
        this.surface = surface;
        this.pen = pen;
        this.width = width;
        this.height = height;
    }
}
@:transitive
@:forward
@:access( cornerContour.web.CanvasRenderer_ )
abstract CanvasRenderer( CanvasRenderer_ ) from CanvasRenderer_ {
    public inline 
    function new( r: CanvasRenderer_ ){
        this = r;
    }
    public inline
    function drawData(){
        var pen = this.pen;
        var data = pen.arr;
        var totalTriangles = Std.int( data.size/7 );
        for( i in 0...totalTriangles ){
            pen.pos = i;
            // draw to canvas surface
            this.surface.triangle2DFill( data.ax, data.ay
                , data.bx, data.by
                , data.cx, data.cy
                , Std.int( data.color ) );
        }
    }
}