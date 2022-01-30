package cornerContour.web;
import js.html.CanvasRenderingContext2D;
/**
 * new CanvasPlus({ x: Float, y: Float, me: CanvasRenderingContext2D });
 */
@:structInit
class CanvasPlus {
    public var x = 0.; 
    public var y = 0.;
    public var me: CanvasRenderingContext2D;
    function new( me: CanvasRenderingContext2D, x: Float = 0, y: Float = 0 ){
        this.x = x; 
        this.y = y;
        this.me = me;
    }
}
@:forward
abstract Surface( CanvasPlus ) to CanvasPlus from CanvasPlus {
    public inline
    function new( canvasPlus: CanvasPlus ){
        this = canvasPlus;
    }
    public inline
    function lineStyle( wid: Float, col: Int, alpha: Float ){
        this.me.lineWidth = wid;
            var r = (col >> 16) & 0xFF;
            var g = (col >> 8) & 0xFF;
            var b = (col) & 0xFF;
            var a = alpha;
            this.me.strokeStyle = 'rgba($r,$g,$b,$a)';
    }
    public inline
    function beginFill( col: Int, alpha: Float ){
        var r = (col >> 16) & 0xFF;
        var g = (col >> 8) & 0xFF;
        var b = (col) & 0xFF;
        var a = alpha;
        this.me.fillStyle = 'rgba($r,$g,$b,$a)';
        this.me.beginPath();
    }
    public inline
    function endFill(){
        this.me.stroke();
        this.me.closePath();
        this.me.fill();
    }
    public inline
    function moveTo( x: Float, y: Float ): Void {
        this.x = x;
        this.y = y;
        this.me.moveTo( x, y );
    }
    public inline
    function lineTo( x: Float, y: Float ): Void {
        this.x = x;
        this.y = y;
        this.me.lineTo( x, y );
    }
    inline
    function midBezier( s: Float, c: Float, e: Float ): Float {
        return 2*c - 0.5*( s + e );
    }
    public inline
    function quadThru( x1: Float, y1: Float
                     , x2: Float, y2: Float ){
        x1 = midBezier( this.x, x1, x2 );
        y1 = midBezier( this.y, y1, y2 );
        quadTo( x1, y1, x2, y2 );
    }
    public inline
    function quadTo( x1: Float, y1: Float
                          , x2: Float, y2: Float ): Void {
        this.me.quadraticCurveTo( x1, y1, x2, y2 );
        this.x = x2;
        this.y = x2;
    }
    public inline
    function curveTo( x1: Float, y1: Float
                                   , x2: Float, y2: Float
                           , x3: Float, y3: Float ): Void {
        this.me.bezierCurveTo( x1, y1, x2, y2, x3, y3 );
        this.x = x2;
        this.y = x2;
    }
    public inline
    function triangle2DFill( ax: Float, ay: Float
                           , bx: Float, by: Float
                           , cx: Float, cy: Float
                           , color: Int ): Int {
        beginFill( color, 1. - 0.000000000000001);
        lineStyle( 0.000000000000001, color, 1. - 0.000000000000001);
        moveTo( ax, ay );
        lineTo( bx, by );
        lineTo( cx, cy );
        endFill();
        return 1;
    }
    public inline
    function triangle2DFillandAlpha( ax: Float, ay: Float
                           , bx: Float, by: Float
                           , cx: Float, cy: Float
                           , color: Int, alpha: Float ): Int {
        beginFill( color, alpha );
        lineStyle( 0.0000000000000001, color, 0.0 );
        moveTo( ax, ay );
        lineTo( bx, by );
        lineTo( cx, cy );
        endFill();
        return 1;
    }
    /** 
     * possible approach to some limited support for thick gradients!!
     * concept to pass 3 colors assume 2 will be same
     * calculate gradient assuming it needs to be as long as the longest 
     * or perhaps change to average?
     * and the angle from different colored corner to  
     * dx, dy the mid point between sides same color.
     * // UNTESTED!!
     */
    public inline
    function triangle2DLinearGradient( ax: Float, ay: Float
                               , bx: Float, by: Float
                               , cx: Float, cy: Float
                               , colorA: Int, alphaA: Float
                               , colorB: Int, alphaB: Float
                               , colorC: Int, alphaC: Float
                               , direction: Int ): Int {
        // you can only have two colors!!
        var cornerC = ( colorA == colorB );
        var cornerA = ( colorB == colorC );
        var cornerB = ( colorC == colorA );
        // Add check this happens!
        var col0 = 'rgba(0,0,0,0)';
        var col1 = 'rgba(0,0,0,0)';
        var length: Float;
        var x1 = 0.;
        var y1 = 0.;
        var abx = ( ax - bx ) * ( ax - bx );
        var bcx = ( bx - cx ) * ( bx - cx );
        var cax = ( cx - ax ) * ( cx - ax );
        var aby = ( ay - by ) * ( ay - by );
        var bcy = ( by - cy ) * ( by - cy );
        var cay = ( cy - ay ) * ( cy - ay );
        var ab = Math.sqrt( abx + aby );
        var bc = Math.sqrt( bcx + bcy );
        var ca = Math.sqrt( cax + cay );
        var dx = 0.;
        var dy = 0.;
        var h = 0.;
        var angle = 0.;
        var length = 0.000000001;
        if( cornerC ){
            x1 = cx;
            y1 = cy;
            
            dx = ( ax + bx )/2;
            dy = ( ay + by )/2;
            h = Math.sqrt( dx*dx + dy*dy );
            dx = cx - dx;
            dy = cy - dy;
            angle = Math.atan2( dx, dy );
            
            length = Math.max( bc, ca );
            var a0 = alphaC;
            var r0 = (colorC >> 16) & 0xFF;
            var g0 = (colorC >> 8) & 0xFF;
            var b0 = (colorC) & 0xFF;
            col0 = 'rgba($r0,$g0,$b0,$a0)';
            var a1 = alphaA;
            var r1 = (colorA >> 16) & 0xFF;
            var g1 = (colorA >> 8) & 0xFF;
            var b1 = (colorA) & 0xFF;
            col1 = 'rgba($r1,$g1,$b1,$a1)';
        }
        if( cornerB ){
            x1 = bx;
            y1 = by;
            
            dx = ( ax + cx )/2;
            dy = ( ay + cy )/2;
            h = Math.sqrt( dx*dx + dy*dy );
            dx = bx - dx;
            dy = by - dy;
            angle = Math.atan2( dx, dy );
            
            length = Math.max( bc, ab );
            var a0 = alphaB;
            var r0 = (colorB >> 16) & 0xFF;
            var g0 = (colorB >> 8) & 0xFF;
            var b0 = (colorB) & 0xFF;
            col0 = 'rgba($r0,$g0,$b0,$a0)';
            var a1 = alphaA;
            var r1 = (colorA >> 16) & 0xFF;
            var g1 = (colorA >> 8) & 0xFF;
            var b1 = (colorA) & 0xFF;
            col1 = 'rgba($r1,$g1,$b1,$a1)';
        }
        if( cornerA ){
            x1 = ax;
            y1 = ay;
            
            dx = ( bx + cx )/2;
            dy = ( by + cy )/2;
            h = Math.sqrt( dx*dx + dy*dy );
            dx = ax - dx;
            dy = ay - dy;
            angle = Math.atan2( dx, dy );
            
            length = Math.max( ab, ca );
            var a0 = alphaA;
            var r0 = (colorA >> 16) & 0xFF;
            var g0 = (colorA >> 8) & 0xFF;
            var b0 = (colorA) & 0xFF;
            col0 = 'rgba($r0,$g0,$b0,$a0)';
            var a1 = alphaB;
            var r1 = (colorB >> 16) & 0xFF;
            var g1 = (colorB >> 8) & 0xFF;
            var b1 = (colorB) & 0xFF;
            col1 = 'rgba($r1,$g1,$b1,$a1)';
        }
        var x2 = x1 + Math.cos( angle ) * length;
        var y2 = y1 + Math.sin( angle ) * length;
        // create and render gradient
        var grad = this.me.createLinearGradient( x1, y1, x2, y2 );
        grad.addColorStop( 0, col0 );
        grad.addColorStop( 1, col1 );
        this.me.fillStyle = grad;
        //this.me.beginPath();
        // just make red hopefully will not be shown.
        lineStyle( 0.0000000000000001, 0xFF0000, 0. );
        moveTo( ax, ay );
        lineTo( bx, by );
        lineTo( cx, cy );
        endFill();
        return 1;
    }
}