import cornerContour.io.Float32Array;
import cornerContour.io.ColorTriangles2D;
import cornerContour.io.IteratorRange;
import cornerContour.io.Array2DTriangles;
// contour code
import cornerContour.Sketcher;
import cornerContour.Pen2D;
import cornerContour.StyleSketch;
import cornerContour.StyleEndLine;
// SVG path parser
import justPath.*;
import justPath.transform.ScaleContext;
import justPath.transform.ScaleTranslateContext;
import justPath.transform.TranslationContext;

import js.html.webgl.RenderingContext;
import js.html.CanvasRenderingContext2D;

// html stuff
import cornerContour.web.Sheet;
import cornerContour.web.DivertTrace;
import cornerContour.shape.Circles;

import htmlHelper.tools.AnimateTimer;
import cornerContour.web.RendererTexture;
import cornerContour.web.Renderer;

// webgl gl stuff
import cornerContour.web.ShaderColor2D;
import cornerContour.web.HelpGL;
import cornerContour.web.BufferGL;
import cornerContour.web.GL;
import cornerContour.web.ImageLoader;

// js webgl 
import js.html.webgl.Buffer;
import js.html.webgl.RenderingContext;
import js.html.webgl.Program;
import js.html.webgl.Texture;

// js generic
import js.Browser;
import js.html.MouseEvent;
import js.html.Event;

class MouseRedCircle {
    // cornerContour specific code
    var sketcher:       Sketcher;
    var pen2Dtexture:   Pen2D;
    var pen2D:          Pen2D;
    // WebGL/Html specific code
    public var gl:               RenderingContext;
    // general
    public var width:            Int;
    public var height:           Int;
    public var mainSheet:        Sheet;
    var divertTrace:             DivertTrace;
    
    var rendererTexture:         RendererTexture;
    var renderer:                Renderer;
    
    public var imageLoader:      ImageLoader;
    public function new(){
        width = 1024;
        height = 768;
        creategl();
        // use Pen to draw to Array
        initContours();
        renderer        = { gl: gl, pen: pen2D,        width: width, height: height };
        //rendererTexture = { gl: gl, pen: pen2Dtexture, width: width, height: height };
        //imageLoader = new ImageLoader( [], setup, true );
        //imageLoader.loadEncoded( [ HaxeLogo.png ], [ 'haxeLogo' ] );
        initDraw();
    }
    inline
    function creategl( ){
        mainSheet = new Sheet();
        mainSheet.create( width, height, true );
        gl = mainSheet.gl;
    }
    public
    function initContours(){
        pen2D = new Pen2D( 0xFFffFFff );
        pen2D.currentColor = 0xFFffFFff;
        //pen2Dtexture = new Pen2D( 0xFFffFFff );
        //pen2Dtexture.currentColor = 0xFFffFFff;
        //sketcher = new Sketcher( pen2Dtexture, StyleSketch.Fine, StyleEndLine.no );
        sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.no );

    }
    var x = 100.;
    var y = 100.;

    inline
    function drawingShape(){
        allRange = new Array<IteratorRange>();
        pen2D.pos = 0;
        pen2D.arr = new Array2DTriangles();
        
        var s = Std.int( pen2D.pos );
        if( mainSheet.isDown ) {
            circle( pen2D, mainSheet.mouseX, mainSheet.mouseY, 50, 0xFFFF0000 );
            x = mainSheet.mouseX;
            y = mainSheet.mouseY;
        } else {
            circle( pen2D, x, y, 50, 0xFFFF0000 );
        }
        allRange.push( s...Std.int( pen2D.pos ) );
    }
    public function initDraw(){
        drawingShape();
        //drawingTexture();
        //rendererTexture.rearrangeData();
        //rendererTexture.setup();
        //rendererTexture.modeEnable();
        renderer.rearrangeData();
        renderer.setup();
        renderer.modeEnable();
        setAnimate();
        mainSheet.initMouseGL();
    }
    var allRange = new Array<IteratorRange>();
    inline
    function render(){
        clearAll( gl, width, height, .9, .9, .9, 1. );
        // for black.
        //clearAll( gl, width, height, 0., 0., 0., 1. );
        // draw order irrelevant here
        //drawingTexture();
        drawingShape();
        // you can adjust draw order
        //renderTexture();
        renderShape();
    }
    inline
    function renderShape(){
        //if( mainSheet.isDown ){
        renderer.modeEnable();
        renderer.rearrangeData(); // destroy data and rebuild
        renderer.updateData(); // update
        renderer.drawData( allRange[0].start...allRange[0].max );
            //}
    }
    inline
    function setAnimate(){
        AnimateTimer.create();
        AnimateTimer.onFrame = function( v: Int ) render();
    }
}
