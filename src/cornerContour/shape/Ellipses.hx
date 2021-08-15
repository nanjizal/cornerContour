package cornerContour.shape;
import cornerContour.IPen;
import fracs.Angles;

inline 
function ellipse( pen: Pen
                , ax: Float, ay: Float
                , rx: Float, ry: Float
                , sides: Int = 36 ): Int {
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
        pen.add2DTriangle( ax, ay, bx, by, cx, cy, color );
    }
    return sides;
}
inline 
function ellipseOutline( pen: Pen
                , ax: Float, ay: Float
                , rx: Float, ry: Float
                , thickness: Float
                , sides: Int = 36 ): Int {
  // TODO: not implemented
  return sides;
}
inline
function ellipsePie( paintType: PaintType
                   , ax: Float, ay: Float
                   , rx: Float, ry: Float
                   , beta: Float, gamma: Float
                   , prefer: DifferencePreference
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
            pen.add2DTriangle( ax, ay, bx, by, cx, cy, color );
        }
        angle = angle + step;
        bx = cx;
        by = cy;
    }
    return totalSteps;
}
// TODO: Ellipse pie outline
