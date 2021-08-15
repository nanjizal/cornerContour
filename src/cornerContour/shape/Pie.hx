package cornerContour.shape;
import fracs.Angles;

/**
 * When calling Pie you can specify the DifferencePreference of what should be colored in terms of the two angles provided.
 * For example for drawing a packman shape you would want the use DifferencePreference.LARGE .
 **/
inline
function pie( paintType: PaintType
            , ax: Float, ay: Float
            , radius: Float, beta: Float, gamma: Float
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
        cx = ax + radius*Math.sin( angle );
        cy = ay + radius*Math.cos( angle );
        if( i != 0 ){ // start on second iteration after b is populated.
            pen.add2DTriangle( ax, ay, bx, by, cx, cy, color );
        }
        angle = angle + step;
        bx = cx;
        by = cy;
    }
    return totalSteps;
}
