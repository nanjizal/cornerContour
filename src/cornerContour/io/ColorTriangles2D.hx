package cornerContour.io;
import cornerContour.io.Flat3x6;
@:transitive
@:forward
abstract ColorTriangles2D( Flat3x6 ){
    public inline function new( len: Int ){
        this = new Flat3x6( len );
    }
    public static inline
    function create( len: Int ){
        return new ColorTriangles2D( len * 18 );
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
    
    public var redA( get, set ): Float;
    function get_redA(): Float {
        return this[ 2 ];
    }
    function set_redA( v: Float ): Float {
        this.writeItem( 2, v );
        return v;
    }
    
    public var greenA( get, set ): Float;
    inline
    function get_greenA(): Float {
        return this[ 3 ];
    }
    inline
    function set_greenA( v: Float ): Float {
        this.writeItem( 3, v );
        return v;
    }
    public var blueA( get, set ): Float;
    inline
    function get_blueA(): Float {
        return this[ 4 ];
    }
    inline
    function set_blueA( v: Float ): Float {
        this.writeItem( 4, v );
        return v;
    }
    public var alphaA( get, set ): Float;
    inline
    function get_alphaA(): Float {
        return this[ 5 ];
    }
    inline
    function set_alphaA( v: Float ): Float {
        this.writeItem( 5, v );
        return v;
    }
    
    public var bx( get, set ): Float;
    function get_bx(): Float {
        return this[ 6 ];
    }
    function set_bx( v: Float ): Float {
        this.writeItem( 6, v );
        return v;
    }
    public var by( get, set ): Float;
    function get_by(): Float {
        return this[ 7 ];
    }
    function set_by( v: Float ): Float {
        this.writeItem( 7, v );
        return v;
    }
    
    public var redB( get, set ): Float;
    function get_redB(): Float {
        return this[ 8 ];
    }
    function set_redB( v: Float ): Float {
        //this[ 10 ] = v;
        this.writeItem( 8, v );
        return v;
    }
    
    public var greenB( get, set ): Float;
    inline
    function get_greenB(): Float {
        return this[ 9 ];
    }
    inline
    function set_greenB( v: Float ): Float {
        this.writeItem( 9, v );
        return v;
    }
    public var blueB( get, set ): Float;
    inline
    function get_blueB(): Float {
        return this[ 10 ];
    }
    inline
    function set_blueB( v: Float ): Float {
        this.writeItem( 10, v );
        return v;
    }
    public var alphaB( get, set ): Float;
    inline
    function get_alphaB(): Float {
        return this[ 11 ];
    }
    inline
    function set_alphaB( v: Float ): Float {
        this.writeItem( 11, v );
        return v;
    }
    
    public var cx( get, set ): Float;
    function get_cx(): Float {
        return this[ 12 ];
    }
    function set_cx( v: Float ): Float {
        this.writeItem( 12, v );
        return v;
    }
    public var cy( get, set ): Float;
    function get_cy(): Float {
        return this[ 13 ];
    }
    function set_cy( v: Float ): Float {
        this.writeItem( 13, v );
        return v;
    }
    
    public var redC( get, set ): Float;
    function get_redC(): Float {
        return this[ 14 ];
    }
    function set_redC( v: Float ): Float {
        this.writeItem( 14, v );
        return v;
    }
    
    public var greenC( get, set ): Float;
    inline
    function get_greenC(): Float {
        return this[ 15 ];
    }
    inline
    function set_greenC( v: Float ): Float {
        this.writeItem( 15, v );
        return v;
    }
    public var blueC( get, set ): Float;
    inline
    function get_blueC(): Float {
        return this[ 16 ];
    }
    inline
    function set_blueC( v: Float ): Float {
        this.writeItem( 16, v );
        return v;
    }
    public var alphaC( get, set ): Float;
    inline
    function get_alphaC(): Float {
        return this[ 17 ];
    }
    inline
    function set_alphaC( v: Float ): Float {
        this.writeItem( 17, v );
        return v;
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
        // assume shape is 2D with depth at moment.
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
    function moveDeltaXY( dx: Float, dy: Float ){
        ax += dx;
        ay += dy;
        bx += dx;
        by += dy;
        cx += dx;
        cy += dy;
    }
    public inline
    function moveRangeXY( range: IteratorRange
                        , dx: Float, dy: Float ){
        var temp = this.pos;
        for( i in range ){
            this.pos = i;
            moveDeltaXY( dx, dy );
        }
        this.pos = temp;
    }
    public inline
    function alphaRange( range: IteratorRange
                        , a: Float ){
        var temp = this.pos;
        for( i in range ){
            this.pos = i;
            alpha = a;
        }
        this.pos = temp;
    }
    public inline
    function argbRange( range: IteratorRange, argb_: Int ){
        var temp = this.pos;
        for( i in range ){
            this.pos = i;
            argb = argb_;
        }
        this.pos = temp;
    }
    public inline
    function rgbRange( range: IteratorRange, rgb_: Int ){
        var temp = this.pos;
        for( i in range ){
            this.pos = i;
            rgb = rgb_;
        }
        this.pos = temp;
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
    public
    function hitRange( range: IteratorRange, px: Float, py: Float ): Bool {
        var temp = this.pos;
        var hit = false;
        for( i in range ){
            this.pos = i;
            if( fullHit( px, py ) ){
                hit = true;
                break;
            }
        }
        this.pos = temp;
        return hit;
    }
    public inline
    function rangeCollisionRough( range1: IteratorRange, range2: IteratorRange ){
        var temp2 = this.pos;
        var hit = false;
        //var b1 = boundingRange( range1 );
        //var b2 = boundingRange( range2 );
        for( i in range1 ){
            this.pos = i;
            var dx = ( ax + bx + cx )/3;
            var dy = ( ay + by + cy )/3;
            if( hitRange( range2, dx, dy ) ){
                hit = true;
                break;
            }
        }
        this.pos = temp2;
        return hit;
    } //http://www.emanueleferonato.com/2012/06/18/algorithm-to-determine-if-a-point-is-inside-a-triangle-with-mathematics-no-hit-test-involved/
    public
    function fullHit( px: Float, py: Float ): Bool {
        var aHit = ( px > x && px < right && py > y && py < bottom );
        if( !aHit ) return false;
        return liteHit( px, py );
    }
    public inline
    function rotateRange( range: IteratorRange, x: Float, y: Float, theta: Float ){
        var temp = this.pos;
        for( i in range ){
           this.pos = i;
           rotate( x, y, theta );
        }
        this.pos = temp;
    }
    public inline 
    function rotate( x: Float, y: Float, theta: Float ){
        var cos = Math.cos( theta );
        var sin = Math.sin( theta );
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
    function colorTriangles( color: Int, times: Int ){
        for( i in 0...times ) {
            argb = color;
            this.pos++;
        }
    }
    public inline
    function cornerColors( colorA: Int, colorB: Int, colorC: Int ){
        argbA = colorA;
        argbB = colorB;
        argbC = colorC;
    }
    public inline
    function blendColorRange( color: Int, range: IteratorRange
                            , t: Float , smooth: Bool = true ){
        var temp = this.pos;
        for( i in range ){
           this.pos = i;
           blendColor( color, t, smooth );
        }
        this.pos = temp;
    }
    public inline
    function blendBetweenColorRange( color: Int, color2: Int
                                   , range: IteratorRange
                                   , t: Float , smooth: Bool = true ){
        var temp = this.pos;
        for( i in range ){
           this.pos = i;
           blendBetweenColor( color, color2, t, smooth );
        }
        this.pos = temp;
    }
    public inline
    function blendColorsRange( colorA: Int, colorB: Int, colorC: Int
                            , range: IteratorRange
                            , t: Float , smooth: Bool = true ){
        var temp = this.pos;
        for( i in range ){
           this.pos = i;
           blendColors( colorA, colorB, colorC, t, smooth );
        }
        this.pos = temp;
    }
    public inline
    function blendBetweenColorsRange( colorA: Int, colorB: Int, colorC: Int
                                   , color2A: Int, color2B: Int, color2C: Int
                                   , range: IteratorRange
                                   , t: Float , smooth: Bool = true ){
        var temp = this.pos;
        for( i in range ){
           this.pos = i;
           blendBetweenColors( colorA, colorB, colorC, color2A, color2B, color2C, t, smooth );
        }
        this.pos = temp;
    }
    public inline
    function boundingRange( range: IteratorRange ): { x: Float, y: Float, width: Float, height: Float }{
        var temp = this.pos;
        var minX: Float = 1000000000;
        var minY: Float = 1000000000;
        var maxX: Float = -1000000000;
        var maxY: Float = -1000000000;
        for( i in range ){
            this.pos = i;
            if( ax < minX ) minX = ax;
            if( ay < minY ) minY = ay;
            if( bx < minX ) minX = bx;
            if( by < minY ) minY = by;
            if( cx < minX ) minX = cx;
            if( cy < minY ) minY = cy;
            
            if( ax > maxX ) maxX = ax;
            if( ay > maxY ) maxY = ay;
            if( bx > maxX ) maxX = bx;
            if( by > maxY ) maxY = by;
            if( cx > maxX ) maxX = cx;
            if( cy > maxY ) maxY = cy;
        }
        this.pos = temp;
        return { x: minX, y: minY, width: maxX-minX, height: maxY-minY };
    }
    public inline
    function scaleRangeXY( range: IteratorRange, sx: Float, sy: Float ){
        var bounds = boundingRange( range );
        var temp = this.pos;
        var w = bounds.width;
        var h = bounds.height;
        var minX = bounds.x;
        var minY = bounds.y;
        var maxX = bounds.x + bounds.width;
        var maxY = bounds.y + bounds.height;
        for( i in range ){
            this.pos = i;
            ax = minX + sx*( ax - minX );
            bx = minX + sx*( bx - minX );
            cx = minX + sx*( cx - minX );
            ay = maxY + sy*( ay - maxY );
            by = maxY + sy*( by - maxY );
            cy = maxY + sy*( cy - maxY );
        }
        this.pos = temp;
    }
    public inline
    function scaleRangeXB( range: IteratorRange, sx: Float, sy: Float ){
        var bounds = boundingRange( range );
        var temp = this.pos;
        var w = bounds.width;
        var h = bounds.height;
        var minX = bounds.x;
        var minY = bounds.y;
        var maxX = bounds.x + bounds.width;
        var maxY = bounds.y + bounds.height;
        for( i in range ){
            this.pos = i;
            ax = minX + sx*( ax - minX );
            bx = minX + sx*( bx - minX );
            cx = minX + sx*( cx - minX );
            ay = minY + sy*( ay - minY );
            by = minY + sy*( by - minY );
            cy = minY + sy*( cy - minY );
        }
        this.pos = temp;
    }
    public inline
    function scaleRangeRY( range: IteratorRange, sx: Float, sy: Float ){
        var bounds = boundingRange( range );
        var temp = this.pos;
        var w = bounds.width;
        var h = bounds.height;
        var minX = bounds.x;
        var minY = bounds.y;
        var maxX = bounds.x + bounds.width;
        var maxY = bounds.y + bounds.height;
        for( i in range ){
            this.pos = i;
            ax = maxX + sx*( ax - maxX );
            bx = maxX + sx*( bx - maxX );
            cx = maxX + sx*( cx - maxX );
            ay = maxY + sy*( ay - maxY );
            by = maxY + sy*( by - maxY );
            cy = maxY + sy*( cy - maxY );
        }
        this.pos = temp;
    }
    public inline
    function scaleRangeRB( range: IteratorRange, sx: Float, sy: Float ){
        var bounds = boundingRange( range );
        var temp = this.pos;
        var w = bounds.width;
        var h = bounds.height;
        var minX = bounds.x;
        var minY = bounds.y;
        var maxX = bounds.x + bounds.width;
        var maxY = bounds.y + bounds.height;
        for( i in range ){
            this.pos = i;
            ax = maxX + sx*( ax - maxX );
            bx = maxX + sx*( bx - maxX );
            cx = maxX + sx*( cx - maxX );
            ay = minY + sy*( ay - minY );
            by = minY + sy*( by - minY );
            cy = minY + sy*( cy - minY );
        }
        this.pos = temp;
    }
    public inline
    function scaleRangeCentre( range: IteratorRange, sx: Float, sy: Float ){
        var bounds = boundingRange( range );
        var temp = this.pos;
        var w = bounds.width;
        var sw = sx*w;
        var h = bounds.height;
        var sh = sy*h;
        var minX = bounds.x;
        var minY = bounds.y;
        var maxX = bounds.x + bounds.width;
        var maxY = bounds.y + bounds.height;
        var dw = ( sw - w )/2;
        var dh = ( sh - h )/2;
        for( i in range ){
            this.pos = i;
            ax = minX + sx*( ax - minX ) - dw;
            bx = minX + sx*( bx - minX ) - dw;
            cx = minX + sx*( cx - minX ) - dw;
            ay = maxY + sy*( ay - maxY ) + dh;
            by = maxY + sy*( by - maxY ) + dh;
            cy = maxY + sy*( cy - maxY ) + dh;
        }
        this.pos = temp;
    }
    public inline
    function blendBetweenColors( colorA: Int, colorB: Int, colorC: Int
                               , color2A: Int, color2B: Int, color2C: Int
                               , t: Float , smooth: Bool = true ) {
        
        var rA = redChannel(   colorA );
        var gA = greenChannel( colorA );
        var bA = blueChannel(  colorA );
        var aA = alphaChannel( colorA );
        var rB = redChannel(   colorB );
        var gB = greenChannel( colorB );
        var bB = blueChannel(  colorB );
        var aB = alphaChannel( colorB );
        var rC = redChannel(   colorC );
        var gC = greenChannel( colorC );
        var bC = blueChannel(  colorC );
        var aC = alphaChannel( colorC );
        var r2A = redChannel(   color2A );
        var g2A = greenChannel( color2A );
        var b2A = blueChannel(  color2A );
        var a2A = alphaChannel( color2A );
        var r2B = redChannel(   color2B );
        var g2B = greenChannel( color2B );
        var b2B = blueChannel(  color2B );
        var a2B = alphaChannel( color2B );
        var r2C = redChannel(   color2C );
        var g2C = greenChannel( color2C );
        var b2C = blueChannel(  color2C );
        var a2C = alphaChannel( color2C );
        // blend each channel colors
        var v = ( smooth )? smootherStep( t ): t;
        redA   = blend( rA, r2A, v );
        blueA  = blend( bA, b2A, v );
        greenA = blend( gA, g2A, v );
        alphaA = blend( aA, a2A, v );
        redB   = blend( rB, r2B, v );
        blueB  = blend( bB, b2B, v );
        greenB = blend( gB, g2B, v );
        alphaB = blend( aB, a2B, v );
        redC   = blend( rC, r2C, v );
        blueC  = blend( bC, b2C, v );
        greenC = blend( gC, g2C, v );
        alphaC = blend( aC, a2C, v );
    }
    public inline
    function blendBetweenColor( color: Int, color2: Int
                               , t: Float , smooth: Bool = true ) {
        
        var r = redChannel(   color );
        var g = greenChannel( color );
        var b = blueChannel(  color );
        var a = alphaChannel( color );
        var r2 = redChannel(   color2 );
        var g2 = greenChannel( color2 );
        var b2 = blueChannel(  color2 );
        var a2 = alphaChannel( color2 );
        // blend each channel colors
        var v = ( smooth )? smootherStep( t ): t;
        redA   = blend( r, r2, v );
        blueA  = blend( b, b2, v );
        greenA = blend( g, g2, v );
        alphaA = blend( a, a2, v );
        redB   = blend( r, r2, v );
        blueB  = blend( b, b2, v );
        greenB = blend( g, g2, v );
        alphaB = blend( a, a2, v );
        redC   = blend( r, r2, v );
        blueC  = blend( b, b2, v );
        greenC = blend( g, g2, v );
        alphaC = blend( a, a2, v );
    }
    public inline
    function blendColor( color: Int, t: Float , smooth: Bool = true ) {
        
        var r = redChannel(   color );
        var g = greenChannel( color );
        var b = blueChannel(  color );
        var a = alphaChannel( color );
        // blend each channel colors
        var v = ( smooth )? smootherStep( t ): t;
        redA   = blend( redA,   r, v );
        blueA  = blend( blueA,  b, v );
        greenA = blend( greenA, g, v );
        alphaA = blend( alphaA, a, v );
        redB   = blend( redB,   r, v );
        blueB  = blend( blueB,  b, v );
        greenB = blend( greenB, g, v );
        alphaB = blend( alphaB, a, v );
        redC   = blend( redC,   r, v );
        blueC  = blend( blueC,  b, v );
        greenC = blend( greenC, g, v );
        alphaC = blend( alphaC, a, v );
    }
    public inline
    function blendColors( colorA: Int, colorB: Int, colorC: Int
                        , t: Float , smooth: Bool = true ) {
        
        var rA = redChannel(   colorA );
        var gA = greenChannel( colorA );
        var bA = blueChannel(  colorA );
        var aA = alphaChannel( colorA );
        var rB = redChannel(   colorB );
        var gB = greenChannel( colorB );
        var bB = blueChannel(  colorB );
        var aB = alphaChannel( colorB );
        var rC = redChannel(   colorC );
        var gC = greenChannel( colorC );
        var bC = blueChannel(  colorC );
        var aC = alphaChannel( colorC );
        // blend each channel colors
        var v = ( smooth )? smootherStep( t ): t;
        redA   = blend( redA,   rA, v );
        blueA  = blend( blueA,  bA, v );
        greenA = blend( greenA, gA, v );
        alphaA = blend( alphaA, aA, v );
        redB   = blend( redB,   rB, v );
        blueB  = blend( blueB,  bB, v );
        greenB = blend( greenB, gB, v );
        alphaB = blend( alphaB, aB, v );
        redC   = blend( redC,   rC, v );
        blueC  = blend( blueC,  bC, v );
        greenC = blend( greenC, gC, v );
        alphaC = blend( alphaC, aC, v );
    }
    public var alpha( never, set ): Float;
    inline
    function set_alpha( a: Float ): Float {
        alphaA = a;
        alphaB = a;
        alphaC = a;
        return a;
    }
    public var rgb( never, set ): Int;
    inline
    function set_rgb( col: Int ): Int {
        rgbA = col;
        rgbB = col;
        rgbC = col;
        return col;
    }
    public var rgbA( get, set ): Int;
    inline
    function set_rgbA( col: Int ): Int {
        redA   = redChannel( col );
        blueA  = blueChannel( col );
        greenA = greenChannel( col );
        alphaA = 1.;
        return col;
    }
    inline
    function get_rgbA():Int {
        return     Math.round( blueA  * 255 )
               | ( Math.round( greenA * 255 ) << 8 ) 
               | ( Math.round( redA   * 255 ) << 16 );
    }
    public var rgbB( get, set ): Int;
    inline
    function set_rgbB( col: Int ): Int {
        redB   = redChannel( col );
        blueB  = blueChannel( col );
        greenB = greenChannel( col );
        alphaB = 1.;
        return col;
    }
    inline
    function get_rgbB():Int {
        return     Math.round( blueB  * 255 )
               | ( Math.round( greenB * 255 ) << 8 ) 
               | ( Math.round( redB   * 255 ) << 16 );
    }
    public var rgbC( get, set ): Int;
    inline
    function set_rgbC( col: Int ): Int {
        redC   = redChannel( col );
        blueC  = blueChannel( col );
        greenC = greenChannel( col );
        alphaC = 1.;
        return col;
    }
    inline
    function get_rgbC():Int {
        return     Math.round( blueC  * 255 )
               | ( Math.round( greenC * 255 ) << 8 ) 
               | ( Math.round( redC   * 255 ) << 16 );
    }
    public var argb( never, set ): Int;
    inline
    function set_argb( col: Int ): Int {
        argbA = col;
        argbB = col;
        argbC = col;
        return col;
    }
    public var argbA( get, set ): Int;
    inline
    function set_argbA( col: Int ): Int {
        redA   = redChannel( col );
        blueA  = blueChannel( col );
        greenA = greenChannel( col );
        alphaA = alphaChannel( col );
        return col;
    }
    inline
    function get_argbA():Int {
        return    ( Math.round( alphaA * 255 ) << 24 ) 
                | ( Math.round( redA   * 255 ) << 16) 
                | ( Math.round( greenA * 255 ) << 8) 
                |   Math.round( blueA  * 255 );
    }
    public var argbB( get, set ): Int;
    inline
    function set_argbB( col: Int ): Int {
        redB   = redChannel( col );
        blueB  = blueChannel( col );
        greenB = greenChannel( col );
        alphaB = alphaChannel( col );
        return col;
    }
    inline
    function get_argbB():Int {
        return    ( Math.round( alphaB * 255 ) << 24 ) 
                | ( Math.round( redB   * 255 ) << 16) 
                | ( Math.round( greenB * 255 ) << 8) 
                |   Math.round( blueB  * 255 );
    }
    public var argbC( get, set ): Int;
    inline
    function set_argbC( col: Int ): Int {
        redC   = redChannel( col );
        blueC  = blueChannel( col );
        greenC = greenChannel( col );
        alphaC = alphaChannel( col );
        return col;
    }
    inline
    function get_argbC():Int {
        return    ( Math.round( alphaC * 255 ) << 24 ) 
                | ( Math.round( redC   * 255 ) << 16) 
                | ( Math.round( greenC * 255 ) << 8) 
                |   Math.round( blueC  * 255 );
    }
    public inline
    function prettyStringVert(){
        return  '{ ax: ' + ax + ', ay: ' + ay + ' }' + '\n' +
                '{ bx: ' + bx + ', by: ' + by + ' }' + '\n' +
                '{ cx: ' + cx + ', cy: ' + cy + ' }' + '\n';
    }
    public inline
    function prettyAllVert(){
        this.pos = 0;
        var str = 'FlatColorTriangle - Verts: \n';
        for( i in 0...this.size ) {
            str += prettyStringVert();
            this.next();
        }
        this.pos = 0;
        return str;
    }
    public inline
    function hex( v: Int ): String {
        return '0x' + StringTools.hex( v );
    }
    public inline
    function hexA(): String {
        return hex( argbA );
    }
    public inline
    function hexB(): String {
        return hex( argbB );
    }
    public inline
    function hexC(): String {
        return hex( argbC );
    }
    public inline
    function hexAll(){
        this.pos = 0;
        var str = 'FlatColorTriangle - RGBA: \n';
        for( i in 0...this.size ) {
            str += 'colorA: ' + hexA() + ', colorB: ' + hexB() +', colorC: ' + hexC() + '\n';
            this.next();
        }
        this.pos = 0;
        return str;
    }
    inline
    function blend( a: Float, b: Float, t: Float ): Float {
        return a + t * ( b - a );
    }
    // Ken Perlin smoothStep 
    inline 
    function smootherStep( t: Float ): Float {
      return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
    }
    public static inline
    function alphaChannel( int: Int ) : Float
        return ((int >> 24) & 255) / 255;
    public static inline
    function redChannel( int: Int ) : Float
        return ((int >> 16) & 255) / 255;
    public static inline
    function greenChannel( int: Int ) : Float
        return ((int >> 8) & 255) / 255;
    public static inline
    function blueChannel( int: Int ) : Float
        return (int & 255) / 255;
}