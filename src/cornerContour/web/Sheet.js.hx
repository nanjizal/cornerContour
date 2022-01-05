package cornerContour.web;
#if js 
import js.Browser;
import js.html.Element;
import js.html.CanvasElement;
import js.html.BodyElement;
import js.html.webgl.RenderingContext;
import js.html.CanvasRenderingContext2D;
//import js.html.webgl.WebGL2RenderingContext;
import js.html.webgl.ContextAttributes;
import js.html.CanvasElement;
import js.Browser;
import js.html.MouseEvent;
import js.html.Event;
import js.html.KeyboardEvent;
class Sheet {
    public var isDown:         Bool = true;
    public var mouseDown:      Void -> Void;
    public var mouseUp:        Void -> Void;
    public var mouseMove:      Void -> Void;
    public var dragPositionChange: Void -> Void;
    public var mouseX:         Float;
    public var mouseY:         Float;
    public var pixelRatio:     Float;
    public var width:          Int;
    public var height:         Int;
    //public var penX:           Float;
    //public var penY:           Float;
    public var domGL:            Element;
    public var domGL2D:           Element;
    public var onReady:        Void->Void;
    public var canvasGL:       CanvasElement;
    public var canvas2D:       CanvasElement;
    public var gl:             RenderingContext;
    public var cx:             CanvasRenderingContext2D;
    public inline function new(){}
    public
    function create( width_: Int = 600, height_: Int = 600, autoChild: Bool = false ){
        width               = width_;
        height              = height_;
        canvasGL            = Browser.document.createCanvasElement();
        canvasGL.width      = width;
        canvasGL.height     = height;
        var body = Browser.document.body;
        body.style.overflow = "hidden";
        body.style.position = 'fixed';
        pixelRatio = Browser.window.devicePixelRatio;
        if( pixelRatio == null ) pixelRatio = 1.;
        var bodyEL: Element = cast Browser.document.body;
        styleZero( bodyEL );
        domGL               = cast canvasGL;
        styleZero( domGL );
        if( autoChild ) body.appendChild( cast canvasGL );
        canvas2D            = Browser.document.createCanvasElement();
        canvas2D.width      = width;
        canvas2D.height     = height;
        domGL2D             = cast canvasGL;
        styleZero( domGL );
        if( autoChild ) body.appendChild( cast canvas2D );
        //gl                  = canvasGL.getContextWebGL();
        //gl                  = canvas.getContext("webgl", { alpha: false }};
        gl                  = canvasGL.getContext("webgl", { premultipliedAlpha: false } );
        cx                  = canvas2D.getContext('2d');
    }
    public inline
    function styleZero( domGL: Element ){
        var style         = domGL.style;
        style.paddingLeft = px( 0 );
        style.paddingTop  = px( 0 );
        style.left        = px( 0 );
        style.top         = px( 0 );
        style.marginLeft  = px( 0 );
        style.marginTop   = px( 0 );
        style.position    = "absolute";
    }
    public inline
    function styleLeft( left: Int ){
        var style      = domGL.style;
        style.left     = px( left );
        style.height   = px( 500 );
        style.width    = px( 500 );
        style.zIndex   = '99';
        style.overflow = 'auto';
    }
    public inline
    function initMouseGL(){
        var body = Browser.document.body;
        body.onmousedown = mouseDownInternal;
        body.onmouseup   = mouseUpInternal;
    }
    public function mouseXY( e: Event ){
        var rect = canvasGL.getBoundingClientRect();
        var m: MouseEvent = cast( e, MouseEvent );
        var oldX = mouseX;
        var oldY = mouseY;
        var oldIsDown = isDown;
        mouseX = m.clientX - rect.left;
        mouseY = m.clientY - rect.top;
        isDown = true;
        
        // need to record if position changed
        var mouseMoved = oldX != mouseX && oldY != mouseY;
        // need to record mouse change if pressed down after up
        var upDown = isDown != oldIsDown;
        if( mouseMoved || upDown ){
            if( dragPositionChange != null ) dragPositionChange();
        }
    }
    inline
    function mouseDownInternal( e: Event ){
        mouseXY( e );
        if( mouseDown != null ) mouseDown();
        var body = Browser.document.body;
        body.onmousemove = mouseMoveInternal;
    }
    inline 
    function mouseMoveInternal( e: Event ){
        mouseXY( e );
        if( mouseMove != null ) mouseMove();
    }
    inline
    function mouseUpInternal( e: Event ){
        var body = Browser.document.body;
        mouseXY( e );
        body.onmousemove = null;
        isDown = false;
        if( mouseUp != null ) mouseUp();
    }
    // unsure if this in correct should be ImageElement?
    public inline
    function draw( sheet: Sheet, dx: Int = 0, dy: Int = 0 ){
        cx.drawImage( sheet.canvasGL, dx, dy, sheet.width, sheet.height );
    }
    public inline
    function clear(){
        cx.clearRect( 0, 0, width, height );
    }
    inline
    function px( v: Int ): String {
        return Std.string( v + 'px' );
    }
    inline 
    function extractPx( s: String ): Int {
        var len = s.length - 2;
        return Std.parseInt( s.substr( 0, len ) );
    }
    inline
    function rgbaString( col: Int, ?alpha: Float ){
        return if( alpha != null && alpha != 1.0 ){
            var r = (col >> 16) & 0xFF;
            var g = (col >> 8) & 0xFF;
            var b = (col) & 0xFF;
            'rgba($r,$g,$b,$alpha)';
        } else {
            '#' + StringTools.hex( col, 6 );
        }
    }
    public inline
    function rgbaFloat( col: Int, alpha: Float = 1. ):{ r: Float, g: Float, b: Float, alpha: Float }{
        var r = (col >> 16) & 0xFF;
        var g = (col >> 8) & 0xFF;
        var b = (col) & 0xFF;
        return { r: r, g: g, b: b, alpha: alpha }
    }
    public var x( get, set ): Int;
    inline
    function set_x( x_: Int ):Int {
        ( cast this ).style.left = px( x_ );
        return( x_ );
    }
    inline
    function get_x(): Int {
        var style = ( cast this ).style;
        return extractPx( style.left );
    }
    public var y( get, set ): Int;
    inline
    function set_y( y_: Int ):Int {
        ( cast this ).style.left = px( y_ );
        return( y_ );
    }
    inline
    function get_y(): Int {
        var style = ( cast this ).style;
        return extractPx( style.top );
    }
}
#end