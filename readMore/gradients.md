## Gradients

- [Two color gradient accross the width of the line, experimental wip](https://github.com/nanjizal/cornerContourWebGLThickGradient)
- trilateral3 has some gradient support.
- Using an equation for color

you can use an equation to define color, it can provide last color, and the previous and current x, y position,
 it does not currently provide an approximate length along a line which might be useful, or provide information on the current width.

```Haxe
    /** 
     * draws cubic SVG
     */
    public
    function cubicSVG(){
        var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.both );
        sketcher.width = 10;
        // function to adjust color of curve along length
        sketcher.colourFunction = function( colour: Int, x: Float, y: Float, x_: Float, y_: Float ):  Int {
            return Math.round( colour-1*x*y );
        }
        var translateContext = new TranslationContext( sketcher, 50, 200 );
        var p = new SvgPath( translateContext );
        p.parse( cubictest_d );
    }
  ```
