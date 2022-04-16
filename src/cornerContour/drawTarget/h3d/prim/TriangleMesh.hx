package cornerContour.drawTarget.h3d.prim.TriangleMesh;
import cornerContour.Pen2D;
// color unsupported, currently rotation not as expected?
/** example use
        var triMesh = new TriangleMesh( pen2D, width, height );
        triMesh.unindex();
        triMesh.addNormals();
        triMesh.addUVs();
        var mat = h3d.mat.Material.create();
        var obj = new h3d.scene.Mesh( triMesh, mat, s3d );
        obj.material.texture = h3d.mat.Texture.fromColor(0xFFFFFF);
        s3d.addChild( obj );
 */
class TriangleMesh extends h3d.prim.Polygon {
    var width: Int;
    var height: Int;
    public function new( pen2D: Pen2D, width: Int, height: Int ) {
        this.width = width;
        this.height = height;
        var pen = pen2D;
        var data = pen.arr;
        var totalTriangles = Std.int( data.size/7 );
        var vertices = [];
        var indices = new hxd.IndexBuffer();
        var s: Int = 0;
        for( i in 0...totalTriangles ){
            pen.pos = i;
            vertices.push(new h3d.col.Point(data.ax, data.ay, 0.));
            vertices.push(new h3d.col.Point(data.bx, data.by, 0.));
            vertices.push(new h3d.col.Point(data.cx, data.cy, 0.));
            s = Std.int(i*3);
            indices.push( s+0 );
            indices.push( s+1 );
            indices.push( s+2 );
        }
        super(vertices, indices);
    }
    public inline
    function gx( v: Float ): Float {
        return -( 1 - 2*v/width );
    }
    public inline
    function gy( v: Float ): Float {
        return ( 1 - 2*v/height );
    }
}
