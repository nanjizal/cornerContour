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
        return Std.int( this[ 6 ] );
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
        return Math.min( Math.min( ay, by ), cy );
    }
    inline
    function set_y( y: Float ): Float {
        var dy = y - get_y();
        ay = ay + dy;
        by = by + dy;
        cy = cy + dy;
        return y;
    }
    public var wid( get, set ): Float;
    inline
    function get_wid(): Float {
        return right - x;
    }
    public var midX( get, set ): Float;
    inline
    function get_midX(): Float {
        return ( right + x )/2;
    }
    inline
    function set_midX( mx: Float ): Float {
        var dmx = mx - get_midX();
        x = dmx;
        return mx;
    }
    public var midY( get, set ): Float;
    inline
    function get_midY(): Float {
        return ( bottom + y )/2;
    }
    inline
    function set_midY( my: Float ): Float {
        var dmy = my - get_midY();
        y = dmy;
        return my;
    }
    inline
    function set_wid( w: Float ): Float {
        scaleX( w/get_wid() );
        return w;
    }
    inline
    function scaleX( sx: Float ): Float {
        return if( sx == 1. ){
            1;
        } else {
            var curX = x;
            if( ax != curX ) ax = ax + ( ax - curX ) * sx;
            if( bx != curX ) bx = bx + ( bx - curX ) * sx;
            if( cx != curX ) cx = cx + ( cx - curX ) * sx;
            return sx;
        }
    }
    /*
    // NOT SURE THESE WILL WORK LIKE THIS, NEEDS THOUGHT
    inline
    function scaleXRange( range: IteratorRange, sx: Float ){
        var curPos = this.pos;
        for( i in pos ){
            this.pos = i;
            scaleX( sx );
        }
        this.pos = curPos;
    }
    */
    public var hi( get, set ): Float;
    inline
    function get_hi(): Float {
        return bottom - y;
    }
    inline
    function set_hi( h: Float ): Float {
        scaleY( h/get_hi() );
        return h;
    }
    inline
    function scaleY( sy: Float ): Float {
        return if( sy == 1. ){
            1;
        } else {
            var curY = y;
            if( ay != curY ) ay = ay + ( ay - curY ) * sy;
            if( by != curY ) by = by + ( by - curY ) * sy;
            if( cy != curY ) cy = cy + ( cy - curY ) * sy;
            sy;
        }
    }
    /*
    // NOT SURE THESE WILL WORK LIKE THIS, NEEDS THOUGHT
    inline
    function scaleYRange( range: IteratorRange, sy: Float ){
        var curPos = this.pos;
        for( i in pos ){
            this.pos = i;
            scaleY( sy );
        }
        this.pos = curPos;
    }
    */
    public inline
    function getXRange( range: IteratorRange ): Float {
        var curPos = this.pos;
        var minX = 100000000000;
        for( i in range ){
            this.pos = i;
            if( x < minX ) minX = x;
        }
        this.pos = curPos;
        return minX;
    }
    public inline
    function getYRange( range: IteratorRange ): Float {
        var curPos = this.pos;
        var minY = 1000000000000;
        for( i in range ){
            this.pos = i;
            if( y < minY ) minY = y;
        }
        this.pos = curPos;
        return minY;
    }
    public inline
    function getWidRange( range: IteratorRange ): Float {
        var curPos = this.pos;
        var minW = 100000000000;
        var w: Float;
        for( i in range ){
            this.pos = i;
            w = wid;
            if( w < minW ) minW = w;
        }
        this.pos = curPos;
        return minW;
    }
    public inline
    function getHiRange( range: IteratorRange ): Float {
        var curPos = this.pos;
        var minH = 1000000000000;
        var h: Float;
        for( i in range ){
            this.pos = i;
            h = hi;
            if( hi < minH ) minH = hi;
        }
        this.pos = curPos;
        return minH;
    }
    public inline
    function getRangeBounds(  range: IteratorRange )
                            : { x: Float, y: Float, width: Float, height: Float }{
        return { x: getXRange(range), y: getYRange(range)
               , width: getWidRange(range), height: getHiRange(range) };
    }
    public inline
    function xRange( range: IteratorRange, px: Float ){
        var minX = getXRange( range );
        var dx = px - minX;
        translateRange( range, dx, 0 );
    }
    public
    function yRange( range: IteratorRange, py: Float ){
        var minY = getYRange( range );
        var dy = py - minY;
        translateRange( range, 0, dy );
    }
    /*
    public inline
    function widRange( range: IteratorRange, pw: Float ){
        var minWid = getWidRange( range );
        var dw = pw - minWind;
        //
    }
    public
    function hiRange( range: IteratorRange, ph: Float ){
        var minHi = getHiRange( range );
        var dh = ph - minHi;
        //
    }
    */
    public 
    function translateRange( range: IteratorRange, dx: Float, dy: Float ){
        var curPos = this.pos;
        for( i in range ){
            this.pos = i;
            translate( dx, dy );
        } 
        this.pos = curPos;
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
    public inline
    function translate( dx: Float, dy: Float ){
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
    // Added to support wxwidgets
    public
    function fillaRGBs( rgbs: haxe.io.UInt8Array
                      , alphas: haxe.io.UInt8Array, width: Int ){
        var sx = Std.int( x - 1 );
        var lx = Std.int( right + 1 );
        var sy = Std.int( y - 1);
        var ly = Std.int( bottom + 1);
        var offset: Int;
        var p: Int;
        var pa: Int;
        var c: Int;
        for( px in sx...lx ){
            for( py in sy...ly ){
                p = (px + width * py) * 3;
                pa = (px + width * py);
                if( liteHit( px, py ) ){
                    c = colorInt;
                    var a = (c >> 24 ) & 0xFF;
                    var r = (c >> 16) & 0xFF;
                    var g = (c >> 8) & 0xFF;
                    var b = (c ) & 0xFF;
                    var axi = Std.int( ax );
                    var ayi = Std.int( ay );
                    var bxi = Std.int( bx );
                    var byi = Std.int( by );
                    var cxi = Std.int( cx );
                    var cyi = Std.int( cy );
                    alphas[ pa ]  = a;
                    rgbs[ p ]     = r;
                    rgbs[ p + 1 ] = g;
                    rgbs[ p + 2 ] = b;
                    plotRGBLine( rgbs, alphas, axi, ayi
                                             , bxi, byi, width, a,r,g,b );
                    plotRGBLine( rgbs, alphas, bxi, byi
                                  , cxi, cyi, width, a,r,g,b );
                    plotRGBLine( rgbs, alphas, cxi, cyi
                                  , axi, ayi, width, a,r,g,b );
                }
            }
        }
    }
    // @author Zingl Alois
    // @date 17.12.2012
    // @version 1.1
    // http://members.chello.at/~easyfilter/bresenham.html
    function plotRGBLine(  rgbs: haxe.io.UInt8Array
                       ,   alphas: haxe.io.UInt8Array
                       ,   x0: Int,    y0: Int
                       ,   x1: Int,    y1: Int
                       ,   width: Int
                       ,   a: Int
                       ,   r: Int
                       ,   g: Int
                       ,   b: Int
                       )
        {
            var dx: Int =  Std.int( Math.abs( x1 - x0 ) );
            var sx: Int = ( x0 < x1 )? 1 : -1;
            var dy: Int = Std.int( - Math.abs( y1 - y0 ) );
            var sy: Int = ( y0 < y1 )? 1 : -1;
            var err: Int = dx + dy;
            var e2: Int;// error value e_xy
            var p: Int; 
            var pa: Int;
                                                           
            // added safety get out as forever while's are dangerous
            var count = 0;
            while( true ){                                              // loop
                if( count > 5000 ) break;
                p =  (x0 + width * y0) * 3;
                pa = (x0 + width * y0);
                alphas[ pa ]  = a;
                rgbs[ p ]     = r;
                rgbs[ p + 1 ] = g;
                rgbs[ p + 2 ] = b;
                if( x0 == x1 && y0 == y1 ) break;
                e2 = 2*err;
                if( e2 >= dy ){                                         // e_xy+e_x > 0
                    err += dy;
                    x0 += sx;
                }
                if( e2 <= dx ){                                         // e_xy+e_y < 0
                    err += dx;
                    y0 += sy;
                }
                count++;
            }
        }
         //http://www.emanueleferonato.com/2012/06/18/algorithm-to-determine-if-a-point-is-inside-a-triangle-with-mathematics-no-hit-test-involved/
    public
    function fullHit( px: Float, py: Float ): Bool {
        if( px > x && px < right && py > y && py < bottom ) return true;
        return liteHit( px, py );
    }
    public
    function fullHitRange( range: IteratorRange, px: Float, py: Float ): Array<Int> {
        var hits = new Array<Int>();
        var curPos = this.pos;
        var curHit = false;
        for( i in range ){
            this.pos = i;
            if( fullHit( px, py ) ) hits[ hits.length ] = i;
        }
        this.pos = curPos;
        return hits; 
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
