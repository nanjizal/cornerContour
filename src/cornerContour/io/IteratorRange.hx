package cornerContour.io;

@:access(IntIterator.min, IntIterator.max )
class IntIterStart {
    public var start: Int;
    public var max: Int;
    public function new( min_: Int, max_: Int ){
        start = min_;
        max = max_;
    }
}
@:transitive
@:access( IntIterator.min, IntIterator.max )
@:forward
abstract IteratorRange( IntIterStart ) from IntIterStart {
    public inline
    function new( min: Int, max: Int ){
        this = new IntIterStart( min, max );
    }
    @:from
    static inline
    public function fromIterator( ii: IntIterator ): IteratorRange {
        return new IteratorRange( ii.min, ii.max );
    }
    @:to
    function toIterStart():IteratorRange {
       return new IteratorRange( this.start, this.max );
    }
    public inline function iterator(){
        return this.start...this.max;
    }
    @:op(A + B) public static inline
    function adding( a: IteratorRange, b: IteratorRange ): IteratorRange {
      	return a.add( b );
    }
    public inline
    function add( b: IteratorRange ): IteratorRange {
        var begin: Int = Std.int( Math.min( this.start, b.max ) );
        var end = ( begin == this.start )? b.max: this.max;
        return new IteratorRange( begin, end );
    }
    public
    var length( get, set ): Int; 
    inline
    function get_length(): Int {
        return this.max - this.start + 1;
    }
    inline
    function set_length( l: Int ): Int {
        this.max = l - 1;
        return l;
    }
    inline
    public function contains( v: Int ): Bool {
        return ( v > ( this.start - 1 ) && ( v < this.max + 1 ) );
    }
    inline
    public function isWithin( ir: IteratorRange ): Bool {
        return contains( ir.start ) && contains( ir.max );
    }
    inline
    public function moveRange( v: Int ){
        this.start += v;
        this.max += v;
    }
    @:op(A += B)
    public inline static
    function addAssign( a: IteratorRange, v: Int ){
        a.moveRange( v );
        return a;
    } 
    @:op(A -= B)
    public inline static
    function minusAssign( a: IteratorRange, v: Int ){
        return a+=-v;
    }
    inline
    public function ifContainMove( v: Int, amount: Int ): Bool {
        var ifHas = contains( v );
        if( ifHas ) moveRange( amount );
        return ifHas; 
    }
}