package cornerContour.drawTarget;
import cornerContour.color.ColorHelp;

inline
function rearrageDrawData( pen: Pen2D, g: ceramic.Mesh ){
    var pen = pen2D;
    var data = pen.arr;
    var totalTriangles = Std.int( data.size/7 );
    var count = 0;
    for( i in 0...totalTriangles ){
        pen.pos = i;
        var l = mesh.vertices.length;
        mesh.vertices[ l ]     = data.ax;
        mesh.vertices[ l + 1 ] = data.ay;
        mesh.vertices[ l + 2 ] = data.bx;
        mesh.vertices[ l + 3 ] = data.by;
        mesh.vertices[ l + 4 ] = data.cx;
        mesh.vertices[ l + 5 ] = data.cy;
        l = mesh.colors.length;
        mesh.colors[ l ]     = cast data.color;
        mesh.colors[ l + 1 ] = cast data.color;
        mesh.colors[ l + 2 ] = cast data.color;
        l = mesh.indices.length;
        mesh.indices[ l ] = count;
        count++;
        mesh.indices[ l + 1 ] = count;
        count++;
        mesh.indices[ l + 2 ] = count;
        count++;
    }
}