package cornerContour.io;
import cornerContour.io.Array7;
@:transitive
@:forward
abstract Array2DTriangles( Array7 ) from Array7 to Array7 {
    public inline function new(){
        this = new Array7();
    }
    public static inline
    function create(){
        return new Array2DTriangles();
    }
    public var ax( get, set ): Float;
    function get_ax(): Float {
        return this[ 0 ];
    }
    function set_ax( v: Float ): Float {
        this.writeItem( 0, v );
        return v;
    }
    public var ay( get, set ): Float;
    function get_ay(): Float {
        return this[ 1 ];
    }
    function set_ay( v: Float ): Float {
        this.writeItem( 1, v );
        return v;
    }
    public var bx( get, set ): Float;
    function get_bx(): Float {
        return this[ 2 ];
    }
    function set_bx( v: Float ): Float {
        this.writeItem( 2, v );
        return v;
    }
    public var by( get, set ): Float;
    function get_by(): Float {
        return this[ 3 ];
    }
    function set_by( v: Float ): Float {
        this.writeItem( 3, v );
        return v;
    }
    public var cx( get, set ): Float;
    function get_cx(): Float {
        return this[ 4 ];
    }
    function set_cx( v: Float ): Float {
        this.writeItem( 4, v );
        return v;
    }
    public var cy( get, set ): Float;
    function get_cy(): Float {
        return this[ 5 ];
    }
    function set_cy( v: Float ): Float {
        this.writeItem( 5, v );
        return v;
    }
    public var color( get, set ): Float;
    function get_color(): Float {
        return this[ 6 ];
    }
    function set_color( v: Float ): Float {
        this.writeItem( 6, v );
        return v;
    }
    public var colorInt( get, set ): Int;
    function get_colorInt(): Int {
        return Math.round( this[ 6 ] );
    }
    function set_colorInt( v: Int ): Int {
        this.writeItem( 6, Std.int( v ) );
        return v;
    }
    /*
    // removed as suspect it's better done manually.
    public
    function applyFill( fill2D: ( Float, Float, Float, Float, Float, Float, Int )->Void ): Int {
        var tot = Std.int(this.size/7);
        for( i in 0...tot ){
            this.pos = i;
            fill2D( ax, ay, bx, by, cx, cy, colorInt );
        }
        return tot;
    }
    */
    public inline
    function triangle2DFill( ax_: Float, ay_: Float
                  , bx_: Float, by_: Float
                  , cx_: Float, cy_: Float
                  , ?color_: Null<Int> ): Int {
        triangle( ax_, ay_, bx_, by_, cx_, cy_ );
        if( color_ == null ) {
          colorInt = 0xFF0000; 
        } else {
          colorInt = color_;
        }
        return 1;
    }
    @:keep
    public function triangle( ax_: Float, ay_: Float
                            , bx_: Float, by_: Float
                            , cx_: Float, cy_: Float ){
        ax = ax_;
        ay = ay_;
        bx = bx_;
        by = by_;
        cx = cx_;
        cy = cy_;
        var windingAdjusted = adjustWinding();
        if( windingAdjusted ){
            ax = ax_;
            ay = ay_;
            bx = cx_;
            by = cy_;
            cx = bx_;
            cy = by_;
        }
        return windingAdjusted;
    }
    public function adjustWinding():Bool { // check sign
        return ( (ax * by - bx * ay) + (bx * cy - cx * by) + (cx * ay - ax * cy) )>0;
    }
    public var x( get, set ): Float;
    inline
    function get_x() {
        return Math.min( Math.min( ax, bx ), cx );
    }
    inline
    function set_x( x: Float ): Float {
        var dx = x - get_x();
        ax = ax + dx;
        bx = bx + dx;
        cx = cx + dx;
        return x;
    }
    public var y( get, set ): Float;   
    inline
    function get_y(): Float {
        return Math.max( Math.max( ay, by ), cy );
    }
    inline
    function set_y( y: Float ): Float {
        var dy = y - get_y();
        ay = ay + dy;
        by = by + dy;
        cy = cy + dy;
        return y;
    }
    public var right( get, never ): Float;
    inline
    function get_right(): Float {
        return Math.max( Math.max( ax, bx ), cx );
    }
    public var bottom( get, never ): Float;
    inline
    function get_bottom(): Float {
        return Math.max( Math.max( ay, by ), cy );
    }
    function moveDelta( dx: Float, dy: Float ){
        ax += dx;
        ay += dy;
        bx += dx;
        by += dy;
        cx += dx;
        cy += dy;
    }
    public static inline
    function sign( n: Float ): Int {
        return Std.int( Math.abs( n )/n );
    }
    public
    function distHit( px: Float, py: Float ): Float {
        if( liteHit( px, py ) ) return 0;
        var dA = Math.pow( Math.pow( px - ax, 2 ) + Math.pow( py - ay, 2 ), 0.5 );
        var dB = Math.pow( Math.pow( px - bx, 2 ) + Math.pow( py - by, 2 ), 0.5 );
        var dC = Math.pow( Math.pow( px - cx, 2 ) + Math.pow( py - cy, 2 ), 0.5 );
        return Math.min( Math.min( dA, dB ), dC );
    }
    // no bounds checking
    public inline
    function liteHit( px: Float, py: Float ): Bool {
        var planeAB = ( ax - px )*( by - py ) - ( bx - px )*( ay - py );
        var planeBC = ( bx - px )*( cy - py ) - ( cx - px )*( by - py );
        var planeCA = ( cx - px )*( ay - py ) - ( ax - px )*( cy - py );
        return sign( planeAB ) == sign( planeBC ) && sign( planeBC ) == sign( planeCA );
    }
    //http://www.emanueleferonato.com/2012/06/18/algorithm-to-determine-if-a-point-is-inside-a-triangle-with-mathematics-no-hit-test-involved/
    public
    function fullHit( px: Float, py: Float ): Bool {
        if( px > x && px < right && py > y && py < bottom ) return true;
        return liteHit( px, py );
    }
    public inline 
    function rotate( x: Float, y: Float, theta: Float ){
        var cos = Math.cos( -theta );
        var sin = Math.sin( -theta );
        rotateTrig( x, y, cos, sin );
    }
    public inline 
    function rotateTrig( x: Float, y: Float, cos: Float, sin: Float ){
        ax -= x;
        ay -= y;
        bx -= x;
        by -= y;
        cx -= x;
        cy -= y;
        var dx: Float;
        var dy: Float;
        dx  = ax;
        dy  = ay;
        ax  = dx * cos - dy * sin;
        ay  = dx * sin + dy * cos; 
        dx  = bx;
        dy  = by;
        bx  = dx * cos - dy * sin;
        by  = dx * sin + dy * cos; 
        dx  = cx;
        dy  = cy;
        cx  = dx * cos - dy * sin;
        cy  = dx * sin + dy * cos;
        ax += x;
        ay += y;
        bx += x;
        by += y;
        cx += x;
        cy += y;
    }
    public inline
    function prettyString(){
        return  '{ ax: ' + ax + ', ay: ' + ay + ' }' + '\n' +
                '{ bx: ' + bx + ', by: ' + by + ' }' + '\n' +
                '{ cx: ' + cx + ', cy: ' + cy + ' }' + '\n' + 
                '{ color: ' + color + ' }' + '\n';
    }
    public inline
    function hex(): String {
        return '0x' + StringTools.hex( colorInt );
    }
}
