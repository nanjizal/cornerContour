## Wiring up to toolkit.
So for instance we could wire it up to [Ceramic](https://jeremyfa.com/what-is-ceramic-engine/) toolkit.
```Haxe
    override function create() {
        mesh = new Mesh();
        rearrageDrawData();
        mesh.anchor(0, 0);
        mesh.pos(0, 0);
        mesh.scale( 1 );
        mesh.alpha = 1;
        mesh.colorMapping = VERTICES;
        add(mesh);
    }
    public
    function rearrageDrawData(){
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
            mesh.colors[ l ]     = data.color;
            mesh.colors[ l + 1 ] = data.color;
            mesh.colors[ l + 2 ] = data.color;
            l = mesh.indices.length;
            mesh.indices[ l ] = count;
            count++;
            mesh.indices[ l + 1 ] = count;
            count++;
            mesh.indices[ l + 2 ] = count;
            count++;
        }
    }
```
## Using with other graphics toolkits.

- [ drawing with Heaps ](https://github.com/nanjizal/cornerContourHeapsTest)
- [ drawing with Lime ](https://github.com/nanjizal/cornerContourLimeTest)
- [ drawing with Kha ](https://github.com/nanjizal/cornerContourKhaGraphics4Test)
- [ drawing with Ceramic ](https://github.com/nanjizal/cornerContourCeramicTest)
- drawing with OpenFL - still to explore technical details.

## With WebGL, Gluon or Canvas
- [ drawing with WebGL ](https://github.com/nanjizal/cornerContourWebGLTest)
- [ drawing with Canvas ](https://github.com/nanjizal/cornerContourCanvasTest)
- [ drawing with Gluon ](https://github.com/nanjizal/cornerContourGluonTest)
