package cornerContour.shape;
import cornerContour.IPen;
import fracs.Angles;

/**
 * When calling Pie you can specify the DifferencePreference of what should be colored in terms of the two angles provided.
 * For example for drawing a packman shape you would want the use DifferencePreference.LARGE .
 **/
inline
function pie( pen: IPen
            , ax: Float, ay: Float
            , rx: Float, ry: Float
            , beta: Float, gamma: Float
            , prefer: DifferencePreference
            , ?color: Null<Int>
            , ?sides: Null<Int> = 36 ): Int {
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
        // TODO: need to check
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
// TODO: need to check
inline
function arc( pen: IPen
            , ax: Float, ay: Float
            , rx: Float, ry: Float
            , width: Float, height: Float, beta: Float, gamma: Float
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
    var dx: Float = 0;
    var dy: Float = 0;
    var ex: Float = 0;
    var ey: Float = 0;
    var r2 = rx - width;
    var r3 = ry - height;
    for( i in 0...totalSteps+1 ){
        cx = ax + rx*Math.sin( angle );
        cy = ay + ry*Math.cos( angle );
        ex = ax + r2*Math.sin( angle );
        ey = ay + r3*Math.cos( angle );
        if( i != 0 ){ // start on second iteration after b and d are populated.
            pen.add2DTriangle( dx, dy, bx, by, cx, cy, color );
            pen.add2DTriangle( dx, dy, cx, cy, ex, ey, color );
        }
        angle = angle + step;
        bx = cx;
        by = cy;
        dx = ex;
        dy = ey;
    }
    return totalSteps*2;
}
