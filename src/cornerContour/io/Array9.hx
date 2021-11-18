package cornerContour.io;
import cornerContour.io.ArrayFlat;
import cornerContour.io.ArrayFlatDepth;
@:transitive
@:forward
abstract Array9( ArrayFlatDepth ) {
    @:op([]) public inline 
    function readItem( k: Int ): Float {
        return this.readItem( index*9 + k );
    }
    //@:op([]) 
    public inline 
    function writeItem( k: Int, v: Float ): Float {
        this.writeItem( index*9 + k, v );
        return v;
    }
    public inline 
    function new(){
        this = new ArrayFlatDepth();
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
    function toEnd( id: Int, len: Int ){
        return this.rangeToEnd( id*9, Std.int( 9 * len ) , this.size );
    }
    public inline 
    function toStart( id: Int, len: Int ){
        return this.rangeToStart( id*9, Std.int( 9 * len ) );
    }
    public inline
    function swap( id0: Int, id1: Int, len: Int ){
        return this.rangeSwitch( id0*9, id1*9, Std.int( 9 * len ) );
    }
    public inline
    function cloneToPos( id: Int, len: Int ){
        return this.cloneRangeToPos( id*9, Std.int( 9 * len ), this.size );
    }
}