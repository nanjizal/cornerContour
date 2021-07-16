package cornerContour;

typedef PenType = {
    var triangle2DFill: ( Float, Float, Float, Float, Float, Float, Int ) -> Int;
    public function get_pos(): Float;
    public function set_pos( v: Float ): Float;
}
@:forward
abstract PenAbstract( PenType ) to PenType from PenType {
    public inline function new( penType: PenType ){
        this = penType;
    }
    public var pos( get, set ): Float ;
    inline function get_pos(): Float {
        return this.get_pos();
    }
    inline function set_pos( v: Float ): Float {
        this.set_pos( v );
        return v; 
    }
}