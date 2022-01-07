package cornerContour.ai;

import hxDaedalus.ai.EntityAI;
import hxDaedalus.data.Edge;
import hxDaedalus.data.Face;
import hxDaedalus.data.math.Point2D;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Vertex;
import hxDaedalus.iterators.FromMeshToVertices;
import hxDaedalus.iterators.FromVertexToHoldingFaces;
import hxDaedalus.iterators.FromVertexToIncomingEdges;
import hxDaedalus.data.Face;
import hxDaedalus.iterators.FromFaceToInnerEdges;
import cornerContour.Sketcher;
import cornerContour.color.ColorHelp;
import cornerContour.shape.Circles;

class ContourDaedalus {
    
    public var edgesColor:Int = 0xFF999999;
    public var edgesWidth:Float = 1;
    public var edgesAlpha:Float = .25;
    public var constraintsColor:Int = 0xFFFF0000;
    public var constraintsWidth:Float = 2;
    public var constraintsAlpha:Float = 1.0;
    public var verticesColor:Int = 0xFF0000FF;
    public var verticesRadius:Float = .5;
    public var verticesAlpha:Float = .25;
    public var pathsColor:Int = 0xFFFF00FF;//FFC010;
    public var pathsWidth:Float = 1.5;
    public var pathsAlpha:Float = .75;
    public var entitiesColor:Int = 0xFF00FF00;
    public var entitiesWidth:Float = 1;
    public var entitiesAlpha:Float = .75;
    public var faceColor: Int = 0xFFff00ff;
    public var faceWidth: Float = 1;
    public var faceAlpha: Float = .5;
    public var faceToEdgeIter = new FromFaceToInnerEdges();
    
    
    public function new(){}
    inline public function circle( g: Sketcher
                                 , p: { x: Float, y: Float }
                                 , radius: Float, color: Int, alpha: Float = 1.
                                 ){
        if( alpha != 1. ) color = colorAlpha( color, alpha ); 
        cornerContour.shape.Circles.circle( g.pen, p.x, p.y, radius, color );
    }
    /*
    inline public function label( g: Sketcher
                                , p: { x: Float, y: Float }
                                , t: String, font: Font
                                , fontSize: Int
                                , color: Int
                                , alpha: Float ){
        throw haxe.Exception.thrown('label not supported');
    }
    */
    inline public function lineP( g: Sketcher
                                , p0: { x: Float, y: Float }
                                , p1: { x: Float, y: Float }
                                , color: Int, alpha: Float, strength: Float ){
        g.lineStyle( strength, color, alpha );
        g.moveTo( p0.x, p0.y );
        g.lineTo( p1.x, p1.y );
    }
    public
    function drawVertex( g: Sketcher, vertex : Vertex): Void {
        circle( g, vertex.pos, verticesRadius, verticesColor, verticesAlpha );
        #if showVerticesIndices
            // todo add font!
            // label( g2, p, new Point( vertex.pos.x + 5, vertex.pos.y + 5, font, fontSize, 0xFFFFFFFF, verticesAlpha );
        #end
    }
    public
    function drawFace( g: Sketcher, face: Face ) : Void {
        faceToEdgeIter.fromFace = face;
        var count = 0;
        var edge;
        // fills need resolve
        g.lineStyle( faceWidth, faceColor, faceAlpha );
        var p: Point2D;
        while( true ){
            edge = faceToEdgeIter.next();
            if( edge == null ) break;
            p = edge.originVertex.pos;
            if( count == 0 ) g.moveTo( p.x, p.y );
            p = edge.destinationVertex.pos;
            g.lineTo( p.x, p.y );
            count++;
        }
    }
    public
    function drawEdge( g: Sketcher, edge : Edge ): Void {
        var p0 = edge.originVertex.pos;
        var p1 = edge.destinationVertex.pos;
        if( edge.isConstrained ){
            lineP( g, p0, p1, constraintsColor, constraintsAlpha, constraintsWidth );
        } else {
            lineP( g, p0, p1, edgesColor, edgesAlpha, edgesWidth );
        }
    }
    public
    function drawMesh( g: Sketcher, mesh: Mesh ): Void {
        var all = mesh.getVerticesAndEdges();
        for (v in all.vertices) drawVertex( g, v );
        for (e in all.edges) drawEdge( g, e );
    }
    public
    function drawEntity( g: Sketcher, entity: EntityAI ): Void {
        circle( g, entity, entity.radius, entitiesColor, entitiesAlpha );
    }
    public
    function drawEntities( g: Sketcher, vEntities:Array<EntityAI> ): Void {
        for (i in 0...vEntities.length) drawEntity( g, vEntities[ i ] );
    }
    public
    function drawPath( g: Sketcher, path:Array<Float>, cleanBefore:Bool = false): Void {
        if (path.length == 0) return;
        g.lineStyle( pathsWidth, pathsColor, pathsAlpha );
        g.moveTo( path[0], path[1] );
        var i = 2;
        while( i < path.length ) {
            g.lineTo( path[ i ], path[ i + 1 ] );
            i += 2;
        }
    }
}