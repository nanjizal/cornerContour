package cornerContour.demo.svg;

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

var quadtest_d      = "M200,300 Q400,50 600,300 T1000,300";
var cubictest_d     = "M100,200 C100,100 250,100 250,200S400,300 400,200";

/** 
 * draws cubic SVG
 */
function cubicSvg( pen2D: Pen2D, width: Float = 10 ){
    var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.both );
    sketcher.width = width;
    // function to adjust color of curve along length
    sketcher.colourFunction = function( colour: Int, x: Float, y: Float, x_: Float, y_: Float ):  Int {
        return Std.int( colour-1*x*y );
    }
    var translateContext = new TranslationContext( sketcher, 50, 200 );
    var p = new SvgPath( translateContext );
    p.parse( cubictest_d );
}
/**
 * draws quad SVG
 */
function quadSvg( pen2D: Pen2D, width: Float = 1. ){
    var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.both );
    sketcher.width = width;
    // function to adjust width of curve along length
    sketcher.widthFunction = function( width: Float, x: Float, y: Float, x_: Float, y_: Float ): Float{
        return width+0.008*2;
    }
    var translateContext = new ScaleTranslateContext( sketcher, 0, 100, 0.5, 0.5 );
    var p = new SvgPath( translateContext );
    p.parse( quadtest_d );
}
