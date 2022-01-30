package cornerContour.shaderTarget.limeTarget;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLBuffer;
inline
function clearAll( gl: WebGLRenderContext, width: Int, height: Int ){
    gl.viewport( 0, 0, width, height );
    gl.clearColor( 0.0, 0.0, 0.0, 1.0 );
    gl.clear( gl.COLOR_BUFFER_BIT );
}
inline
function programSetup( gl:          WebGLRenderContext
                     , strVertex:   String
                     , strFragment: String ): GLProgram {
     var program: GLProgram = gl.createProgram();
     gl.attachShader( program, shaderSetup( gl, gl.VERTEX_SHADER, strVertex ) );
     gl.attachShader( program, shaderSetup( gl, gl.FRAGMENT_SHADER, strFragment ) );
     gl.linkProgram( program );
     if( !gl.getProgramParameter( program, gl.LINK_STATUS ) ) {
         throw("Error linking program. " + gl.getProgramInfoLog( program ) );
         return null;
     }
     gl.validateProgram( program );
     if( !gl.getProgramParameter( program, gl.VALIDATE_STATUS ) ) {
         throw("Error validating program. " + gl.getProgramInfoLog( program ) );
         return null;
     }
     gl.useProgram( program );
     return program;
}
inline
function shaderSetup( gl: WebGLRenderContext
                     , shaderType: Int
                     , str: String ): GLShader {
     var shader = gl.createShader( shaderType );
     gl.shaderSource( shader, str );
     gl.compileShader( shader );
     if( !gl.getShaderParameter( shader, gl.COMPILE_STATUS ) ){
         throw("Error compiling shader. " + gl.getShaderInfoLog( shader ) );
         return null;
     }
     return shader;
}

// just used for docs
class HelpGL {
    public var clearAll_: 
        ( gl: WebGLRenderContext, width: Int, height: Int )->Void = clearAll;
    public var programSetup_:    ( gl:           WebGLRenderContext
                                 , strVertex:    String
                                 , strFragment:  String ) -> GLProgram = programSetup;
    public var shaderSetup_:     ( gl:           WebGLRenderContext
                                 , shaderType:   Int
                                 , str:          String ) -> GLShader  =  shaderSetup;
}