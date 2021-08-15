package cornerContour.shape.structs;
import cornerContour.shape.structs.XY;
@:structInit
class Quad2D {
    public var a: XY;
    public var b: XY;
    public var c: XY;
    public var d: XY;
    function new( a: XY, b: XY, c: XY, d: XY ){
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
    }
    public function clone(): Quad2D {
        return { a: a, b: b, c: c, d: d };
    }
}
