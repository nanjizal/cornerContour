package cornerContour.shape.structs;
import cornerContour.shape.structs.XY;
@:structInit
class Rectangle_ {
    public var x: Float;
    public var y: Float;
    public var width: Float;
    public var height: Float;
    function new( x: Float, y: Float, width: Float, height: Float ){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
    public function clone(): Rectangle_ {
        return { x: x, y: y, width: width, height: height };
    }
}
@:forward
abstract Rectangle( Rectangle_ ) to Rectangle_ from Rectangle_ {
    public inline function new( rectangle: Rectangle_ ){
        this = rectangle;
    }
    public var right( get, set ): Float;
    inline
    function get_right(): Float {
        return this.x + this.width;
    }
    inline
    function set_right( v: Float ): Float {
        this.width = v - this.x;
        return v;
    }
    public var bottom( get, set ): Float;
    inline
    function get_bottom(): Float {
        return this.y + this.height;
    }
    inline
    function set_bottom( v: Float ): Float {
        this.height = v - this.y;
        return v;
    }
    public var bottomRight( get, set ): XY;
    inline
    function get_bottomRight(): XY {
        return { x: right, y: bottom };
    }
    inline
    function set_bottomRight( v: XY ): XY {
        right = v.x;
        bottom = v.y;
        return v;
    }
    public var cx( get, set ):Float;
    inline
    function get_cx(): Float {
        return this.x + this.width/2;
    }
    inline
    function set_cx( v: Float ): Float {
        this.x = v - this.width/2;
        return v;
    }
    public var cy( get, set ):Float;
    inline
    function get_cy(): Float {
        return this.y + this.height/2;
    }
    inline
    function set_cy( v: Float ): Float {
        this.y = v - this.height/2;
        return v;
    }
    public var centre( get, set ): XY;
    inline
    function get_centre(): XY {
        return { x: cx, y: this.y + this.height };
    }
    inline
    function set_centre( v: XY ): XY {
        var cx = v.x;
        var cy = v.y;
        this.x = cx - this.width/2;
        this.y = cy - this.height/2;
        return v;
    }
    public inline
    function rotatedQuad( x: Float, y: Float, theta: Float ): Quad2D {
        var cos = Math.cos( theta );
        var sin = Math.sin( theta );
        var quad = toQuad2D();
        return quad.rotateTrig( x, y, cos, sin );
    }
    public inline
    function rotatedBounds( x: Float, y: Float, theta: Float ): Rectangle {
        return rotatedQuad( x, y, theta ).bounds();
    }
    @:to
    public inline
    function toQuad2D(): Quad2D {
        return { a: { x: this.x, y: this.y }
               , b: { x: right,  y: this.y }
               , c: { x: right,  y: bottom }
               , d: { x: this.x, y: bottom } };
    }
    public inline
    function hit( v: XY ): Bool {
        var hx = v.x;
        var hy = v.y;
        return ( hx > this.x && hy > this.y && hx < right && hy < bottom );
    }
}