package cornerContour.io;
import cornerContour.io.Float32Flat;
import cornerContour.io.Float32Array;
import cornerContour.io.Float32FlatDepth;
@:transitive
@:forward
abstract Flat3x8( Float32FlatDepth ) from Float32FlatDepth to Float32FlatDepth {
    @:op([]) public inline 
    function readItem( k: Int ): Float {
        return this.readItem( index*24 + k );
    }
    @:op([])
    public inline 
    function writeItem( k: Int, v: Float ): Float {
        this.writeItem( index*24 + k, v );
        return v;
    }
    public inline 
    function new( len: Int ){
        this = new Float32FlatDepth( len );
    }
    public var index( get, set ): Int;
    inline
    function get_index(): Int {
        return this.index;
    }
    inline
    function set_index( id: Int ): Int {
        this.index = id;
        return id;
    }
    public inline
    function getFloat32Array(): Float32Array {
        return this.subarray( 2, this.size*24 + 2 );
    }
    public inline 
    function toEnd( id: Int, len: Int ){
        return this.rangeToEnd( id*24, Std.int( 24*len ), 24 );
    }
    public inline 
    function toStart( id: Int, len: Int ){
        return this.rangeToStart( id*24, Std.int( 24*len ) );
    }
    public inline
    function swap( id0: Int, id1: Int, len: Int ){
        return this.rangeSwitch( id0*24, id1*24, Std.int( 24 * len ) );
    }
}