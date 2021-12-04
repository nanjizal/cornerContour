package cornerContour.shape.structs;
import cornerContour.shape.structs.XY;
@:structInit
private class Quad2D_ {
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
    public function clone(): Quad2D_ {
        return { a: a, b: b, c: c, d: d };
    }
}
@:forward
@:transitive
@:access( cornerContour.shape.structs.Quad2D )
abstract Quad2D( Quad2D_ ) to Quad2D_ from Quad2D_ {
    public inline function new( quad: Quad2D_ ){
        this = quad;
    }
    public var x( get, set ): Float;
    inline function get_x():Float {
        var p = if( this.a.x < this.b.x ){
            this.a.x;
        } else {
            this.b.x;
        }
        var q = if( this.c.x < this.d.x ){
            this.c.x;
        } else {
            this.d.x;
        }
        return Math.min( p, q );
    }
    inline function set_x( v: Float ): Float {
        var curX = get_x();
        var dx = v - curX;
        this.a.x += dx;
        this.b.x += dx;
        this.c.x += dx;
        this.d.x += dx;
        return v;
    }
    public var y( get, set ): Float;
    inline function get_y():Float {
        var p = if( this.a.y < this.b.y ){
            this.a.y;
        } else {
            this.b.y;
        }
        var q = if( this.c.y < this.d.y ){
            this.c.y;
        } else {
            this.d.y;
        }
        return Math.min( p, q );
    }
    inline function set_y( v: Float ): Float {
        var curY = get_y();
        var dy = v - curY;
        this.a.y += dy;
        this.b.y += dy;
        this.c.y += dy;
        this.d.y += dy;
        return v;
    }
    // untested
    public inline
    function scaleXcentre( sx: Float, ?rect: Rectangle ){
        if( rect == null ) var rect = bounds();
        var cx = rect.cx;
        this.a.x = scaleDimension( this.a.x, sx, cx );
        this.b.x = scaleDimension( this.b.x, sx, cx );
        this.c.x = scaleDimension( this.c.x, sx, cx );
        this.d.x = scaleDimension( this.d.x, sx, cx );
    }
    //untested
    public inline
    function scaleYcentre( sy: Float, ?rect: Rectangle ){
        if( rect == null ) var rect = bounds();
        var cy = rect.cy;
        this.a.y = scaleDimension( this.a.y, sy, cy );
        this.b.y = scaleDimension( this.b.y, sy, cy );
        this.c.y = scaleDimension( this.c.y, sy, cy );
        this.d.y = scaleDimension( this.d.y, sy, cy );
    }
    //untested
    public inline
    function scaleX_leftAlign( sx: Float, ?rect: Rectangle ){
        if( rect == null ) var rect = bounds();
        var cx = rect.cx;
        var w = rect.width;
        var ox = ( sx*w - w )/2;
        this.a.x = scaleDimension( this.a.x, sx, cx ) + ox;
        this.b.x = scaleDimension( this.b.x, sx, cx ) + ox;
        this.c.x = scaleDimension( this.c.x, sx, cx ) + ox;
        this.d.x = scaleDimension( this.d.x, sx, cx ) + ox;
    }
    //untested
    public inline
    function scaleX_rightAlign( sx: Float, ?rect: Rectangle ){
        if( rect == null ) var rect = bounds();
        var cx = rect.cx;
        var w = rect.width;
        var ox = -( sx*w - w );
        this.a.x = scaleDimension( this.a.x, sx, cx ) + ox;
        this.b.x = scaleDimension( this.b.x, sx, cx ) + ox;
        this.c.x = scaleDimension( this.c.x, sx, cx ) + ox;
        this.d.x = scaleDimension( this.d.x, sx, cx ) + ox;
    }
    //untested
    public inline
    function scaleY_topAlign( sy: Float, ?rect: Rectangle ){
        if( rect == null ) var rect = bounds();
        var cy = rect.cy;
        var h = rect.height;
        var oy = ( sy*h - h )/2;
        this.a.y = scaleDimension( this.a.y, sy, cy ) + oy;
        this.b.y = scaleDimension( this.b.y, sy, cy ) + oy;
        this.c.y = scaleDimension( this.c.y, sy, cy ) + oy;
        this.d.y = scaleDimension( this.d.y, sy, cy ) + oy;
    }
    //untested
    public inline
    function scaleY_bottomAlign( sy: Float, ?rect: Rectangle ){
        if( rect == null ) var rect = bounds();
        var cy = rect.cy;
        var h = rect.height;
        var oy = -( sy*h - h );
        this.a.y = scaleDimension( this.a.y, sy, cy ) + oy;
        this.b.y = scaleDimension( this.b.y, sy, cy ) + oy;
        this.c.y = scaleDimension( this.c.y, sy, cy ) + oy;
        this.d.y = scaleDimension( this.d.y, sy, cy ) + oy;
    }
    // untested
    public inline
    function scaleXY_alignTopLeft( sx: Float, sy: Float ){
        var rect = bounds();
        scaleX_leftAlign( sx, rect );
        scaleY_topAlign( sy, rect );
    }
    // untested
    public inline
    function scaleXY_alignTopRight( sx: Float, sy: Float ){
        var rect = bounds();
        scaleX_rightAlign( sx, rect );
        scaleY_topAlign( sy, rect );
    }
    // untested
    public inline
    function scaleXY_alignBottomRight( sx: Float, sy: Float ){
        var rect = bounds();
        scaleX_rightAlign( sx, rect );
        scaleY_bottomAlign( sy, rect );
    }
    // untested
    public inline
    function scaleXY_alignBottomLeft( sx: Float, sy: Float ){
        var rect = bounds();
        scaleX_leftAlign( sx, rect );
        scaleY_bottomAlign( sy, rect );
    }
    // untested
    public var width( get, set ): Float;
    inline function get_width(): Float {
        return bounds().width;
    }
    inline function set_width( v: Float ): Float {
        var rect = bounds();
        var sx = v/rect.width;
        scaleX_leftAlign( sx, rect );
        return v;
    }
    // untested
    public var height( get, set ): Float;
    inline function get_height(): Float {
        return bounds().height;
    }
    inline function set_height( v: Float ): Float {
        var rect = bounds();
        var sy = v/rect.height;
        scaleY_topAlign( sy, rect );
        return v;
    }
    // untested
    public var scale( never, set ): Float;
    inline function set_scale( v: Float ): Float {
        scaleCentre( v );
        return v;
    }
    //untested
    public inline
    function scaleCentre( s: Float ){
        var rect = bounds();
        scaleXcentre( s, rect );
        scaleYcentre( s, rect );
    }
    //untested
    inline function scaleDimension( dim: Float, s: Float, centre: Float ): Float {
        var delta = s*( centre - dim );
        return centre + delta;
    }
    public inline
    function bounds(): Rectangle {
        var axLess: Bool = false;
        var p = if( this.a.x < this.b.x ){
            axLess = true;
            this.a.x;
        } else {
            axLess = false;
            this.b.x;
        }
        var cxLess: Bool = false;
        var q = if( this.c.x < this.d.x ){
            cxLess = true;
            this.c.x;
        } else {
            cxLess = false;
            this.d.x;
        }
        var minX = Math.min( p, q );
        p = ( axLess )? this.b.x: this.a.x;
        q = ( cxLess )? this.d.x: this.c.x;
        var maxX = Math.max( p, q );
        //
        var ayLess: Bool = false;
        var p = if( this.a.y < this.b.y ){
            ayLess = true;
            this.a.y;
        } else {
            ayLess = false;
            this.b.y;
        }
        var cyLess: Bool = false;
        var q = if( this.c.y < this.d.y ){
            cyLess = true;
            this.d.y;
        } else {
            cyLess = false;
            this.d.y;
        }
        var minY = Math.min( p, q );
        p = ( ayLess )? this.b.y: this.a.y;
        q = ( cyLess )? this.d.y: this.c.y;
        var maxY = Math.max( p, q );
        return { x: minX, y: minY, width: maxX - minX, height: maxY - minY };
    }
    public inline 
    function rotateTrig( x: Float, y: Float, cos: Float, sin: Float ): Quad2D {
        this.a.x -= x;
        this.a.y -= y;
        this.b.x -= x;
        this.b.y -= y;
        this.c.x -= x;
        this.c.y -= y;
        this.d.x -= x;
        this.d.y -= y;
        var dx: Float;
        var dy: Float;
        dx  = this.a.x;
        dy  = this.a.y;
        this.a.x  = dx * cos - dy * sin;
        this.a.y  = dx * sin + dy * cos; 
        dx  = this.b.x;
        dy  = this.b.y;
        this.b.x  = dx * cos - dy * sin;
        this.b.y  = dx * sin + dy * cos; 
        dx  = this.c.x;
        dy  = this.c.y;
        this.c.x  = dx * cos - dy * sin;
        this.c.y  = dx * sin + dy * cos;
        dx  = this.d.x;
        dy  = this.d.y;
        this.d.x  = dx * cos - dy * sin;
        this.d.y  = dx * sin + dy * cos;
        this.a.x += x;
        this.a.y += y;
        this.b.x += x;
        this.b.y += y;
        this.c.x += x;
        this.c.y += y;
        return this;
    }
}
