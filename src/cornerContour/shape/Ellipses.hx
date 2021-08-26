package cornerContour.shape;
import cornerContour.IPen;
import fracs.Angles;

inline 
function ellipse( pen: IPen
                , ax: Float, ay: Float
                , rx: Float, ry: Float
                , ?color: Null<Int>
                , ?sides: Int = 36 ): Int {
    var pi = Math.PI;
    var theta = pi/2;
    var step = pi*2/sides;
    var bx: Float;
    var by: Float;
    var cx: Float;
    var cy: Float;
    for( i in 0...sides ){
        bx = ax + rx*Math.sin( theta );
        by = ay + ry*Math.cos( theta );
        theta += step;
        cx = ax + rx*Math.sin( theta );
        cy = ay + ry*Math.cos( theta );
        pen.triangle2DFill( ax, ay, bx, by, cx, cy, color );
    }
    return sides;
}
inline 
function ellipseOutline( pen: IPen
                        , ax: Float, ay: Float
                        , rx: Float, ry: Float
                        , thick: Float
                        , ?color: Null<Int>
                        , ?sides: Int = 36 ): Int {
    var pi = Math.PI;
    var theta = pi/2;
    var step = pi*2/sides;
    var bx: Float;
    var by: Float;
    var cx: Float;
    var cy: Float;
    var b2x: Float;
    var b2y: Float;
    var c2x: Float;
    var c2y: Float;
    var rx2 = rx - thick/2;
    var ry2 = ry - thick/2;
    for( i in 0...sides ){
        bx = ax + rx*Math.sin( theta );
        by = ay + ry*Math.cos( theta );
        b2x = ax + rx2*Math.sin( theta );
        b2y = ay + ry2*Math.cos( theta );
        theta += step;
        cx = ax + rx*Math.sin( theta );
        cy = ay + ry*Math.cos( theta );
        c2x = ax + rx2*Math.sin( theta );
        c2y = ay + ry2*Math.cos( theta );
        pen.triangle2DFill( bx, by, cx, cy, b2x, b2y, color );
        pen.triangle2DFill( cx, cy, c2x, c2y, b2x, b2y, color );
   }
   return sides*2;
}
inline
function ellipsePie( pen: IPen
                   , ax: Float, ay: Float
                   , rx: Float, ry: Float
                   , beta: Float, gamma: Float
                   , prefer: DifferencePreference
                   , ?color: Null<Int>
                   , ?sides: Int = 36 ): Int {
    // choose a step size based on smoothness ie number of sides expected for a circle
    var pi = Math.PI;
    var step = pi*2/sides;
    var dif = Angles.differencePrefer( beta, gamma, prefer );
    var positive = ( dif >= 0 );
    var totalSteps = Math.ceil( Math.abs( dif )/step );
    // adjust step with smaller value to fit the angle drawn.
    var step = dif/totalSteps;
    var angle: Float = beta;
    var cx: Float;
    var cy: Float;
    var bx: Float = 0;
    var by: Float = 0;
    for( i in 0...totalSteps+1 ){
        cx = ax + rx*Math.sin( angle );
        cy = ay + ry*Math.cos( angle );
        if( i != 0 ){ // start on second iteration after b is populated.
            pen.triangle2DFill( ax, ay, bx, by, cx, cy, color );
        }
        angle = angle + step;
        bx = cx;
        by = cy;
    }
    return totalSteps;
}
// TODO: Ellipse pie outline
class Ellipses {
    public var ellipse_: ( pen: IPen
                         , ax: Float, ay: Float
                         , rx: Float, ry: Float
                         , ?color: Null<Int>
                         , ?sides: Int ) -> Int = ellipse;
    public var ellipsePie_: ( pen: IPen
                            , ax: Float, ay: Float
                            , rx: Float, ry: Float
                            , beta: Float, gamma: Float
                            , prefer: DifferencePreference
                            , ?color: Null<Int>
                            , ?sides: Int ) -> Int = ellipsePie;

}