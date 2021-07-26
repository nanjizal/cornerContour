package cornerContour.io;
// arr[0] defines pos the position, pos is used to get items
@:transitive
@:forward
abstract ArrayFlat( Array<Float> ){
    @:op([]) //@:arrayAccess
    public inline
    function readItem( k: Int ): Float {
      return this[ k + 1 ];
    }
    @:op([])
    public inline
    function writeItem( k: Int, v: Float ): Float {
        this[ k + 1 ] = v;
        return v;
    }
    public inline
    function new(){
        this = new Array<Float>();
        this[0] = 0.; // init iteratior no.
    }
    public var size( get, never ): Int;
    inline
    function get_size(): Int {
        return this.length - 1;
    }
    public var index( get, set ): Int;
    inline
    function get_index(): Int {
        return Std.int( pos );
    }
    inline
    function set_index( id: Int ): Int {
        pos = id;
        return id;
    }
    public var pos( get, set ): Float;
    inline
    function get_pos(): Float {
        return this[ 0 ];
    }
    inline
    function set_pos( pos_: Float ): Float {
        this[ 0 ] = pos_;
        return pos_;
    }
    public inline
    function hasNext() return pos < get_size();
    public inline
    function next(): Float {
        pos = pos + 1.;
        return pos;
    }
    @:op(A++) public inline
    function increment() {
        return next();
    }
    public inline 
    function setArray( arr: Array<Float> ){
        this = arr;
    }
    public inline
    function clone(): ArrayFlat {
        var af = new ArrayFlat();
        af.setArray( this.copy() );
        return return af;
    }
}
