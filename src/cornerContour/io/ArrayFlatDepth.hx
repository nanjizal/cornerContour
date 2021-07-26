
package cornerContour.io;
import cornerContour.io.ArrayFlat;
@:transitive
@:forward
abstract ArrayFlatDepth( ArrayFlat ){
    public inline
    function new(){
        this = new ArrayFlat();
    }
    public inline
    function getArray(): Float32Array {
        var fa32 = new Float32Array( this.length - 1 );
        for( i in 0...( this.length - 1 ) ){
            fa32[ i ] = this.readItem( i );
        }
        return fa32;
    }
    public
    function rangeToEnd( starting: Int, totalLen: Int, section: Int ){
        var ending: Int = starting + totalLen;
        var temp = [];
        var count = 0;
        // store values to move
        for( i in starting...ending ) {
            temp[ count++ ] = this[ i ];
        }
        // shift top half values down to fill hole
        var left = section - ending;
        for( i in 0...left ) {
            this[ starting + i ] = this[ ending + i ];
        }
        // draw at end.
        var last = section;
        var reserveTop = last - totalLen;
        count = 0;
        for( i in reserveTop...last ) {
            this[ i ] = temp[ count++ ];
        }
        temp = null;
        return true;
    }
    public inline
    function rangeToStart( starting: Int, totalLen: Int ){
        if( starting == 0 ) return false;
        var ending = starting + totalLen;
        var temp = [];
        var count = 0;
        // store values to move
        for( i in starting...ending ){
            temp[ count ] = this[ i ];
            count++;
        }
        // shift bottom half values up to fill hole from top
        count = totalLen;
        for( i in 0...starting ){
            this[ ending - 1 - i ] = this[ starting - 1 - i ];
        }
        // add values to start
        count = 0;
        for( i in 0...totalLen ){
            this[ i ] = temp[ count - 2 ];
            count++;
        }
        temp = null;
        return true;
    }
    public inline
    function rangeSwitch( start0: Int, start1: Int, totalLen: Int ){
        if( start0 + totalLen > this.size && start1 + totalLen > this.size ){
            var temp0: Float;
            var temp1: Float;
            for( i in 0...totalLen ){
                temp0 = this[ start0 + i ];
                temp1 = this[ start1 + i ];
                this[ start0 + i ] = temp1;
                this[ start1 + i ] = temp0;
            }
            return true;
        } else {
            return false;
        }
    }
}
