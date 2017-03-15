//
//  EffectMaterial.swift
//  ARGame
//
//  Created by James Rogers on 10/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class EffectMaterial : Effect
{
    private var colourDiffuse: GLKVector4 = GLKVector4Make(0.0, 0.0, 0.0, 0.0)
    private var colourSpecular: GLKVector4 = GLKVector4Make(0.0, 0.0, 0.0, 0.0)
    private var shininess: GLfloat = 0.0
    
    public init()
    {
        // Set shader parameters
        let vertName: String = "ShaderMaterial"
        let fragName: String = "ShaderMaterial"
        
        let vertAttribs: [(GLint, String)] = [(ShaderVertexAttrib.position.rawValue, "position"),
                                              (ShaderVertexAttrib.normal.rawValue,   "normal"),
                                              (ShaderVertexAttrib.texCoord.rawValue, "texCoord")]
        
        let uniformNames:[String] = ["projectionMatrix", "viewMatrix", "modelMatrix",
                                     "normalMatrix",
                                     "viewPosition",
                                     "colour",
                                     "textureDiff", "textureSpec",
                                     "colourDiff", "colourSpec",
                                     "shininess"]
        
        super.init(vertName, fragName, vertAttribs, uniformNames)
    }
    
    public override func prepareToDraw()
    {
        super.prepareToDraw()
        
        // Set up the projection matrix in the shader
        withUnsafePointer(to: &self.projection, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(self.shader.getUniformLocation("projectionMatrix"), 1, 0, $0)
            })
        })
        
        // Set up the view matrix in the shader
        withUnsafePointer(to: &self.view, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(self.shader.getUniformLocation("viewMatrix"), 1, 0, $0)
            })
        })
        
        // Set up the model matrix in the shader
        withUnsafePointer(to: &self.model, {
            $0.withMemoryRebound(to: Float.self, capacity: 16, {
                glUniformMatrix4fv(self.shader.getUniformLocation("modelMatrix"), 1, 0, $0)
            })
        })
        
        // Set up the normal matrix in the shader
        var didInvTrans: UnsafeMutablePointer<Bool>!
        var normal: GLKMatrix3 = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(self.model, didInvTrans))
        withUnsafePointer(to: &normal, {
            $0.withMemoryRebound(to: Float.self, capacity: 12, {
                glUniformMatrix3fv(self.shader.getUniformLocation("normalMatrix"), 1, 0, $0)
            })
        })
        
        // Set up the view position
        var invView: GLKMatrix4 = GLKMatrix4Invert(self.view, didInvTrans)
        var viewPosition4 = GLKMatrix4GetColumn(invView, 3)
        var viewPosition: GLKVector3 = GLKVector3Make(viewPosition4.x, viewPosition4.y, viewPosition4.z)
        withUnsafePointer(to: &viewPosition, {
            $0.withMemoryRebound(to: Float.self, capacity: 3, {
                glUniform3fv(self.shader.getUniformLocation("viewPosition"), 1, $0)
            })
        })
        
        print("x: \(viewPosition.x), y: \(viewPosition.y), z: \(viewPosition.z)")
        
        // Set up the colour in the shader
        withUnsafePointer(to: &colour, {
            $0.withMemoryRebound(to: Float.self, capacity: 4, {
                glUniform4fv(self.shader.getUniformLocation("colour"), 1, $0)
            })
        })
        
        // Set up the texture in the shader
        glActiveTexture(GLenum(GL_TEXTURE0))
        glUniform1f(self.shader.getUniformLocation("textureDiff"), 0)
        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture0)
        
        glActiveTexture(GLenum(GL_TEXTURE1))
        glUniform1f(self.shader.getUniformLocation("textureSpec"), 0)
        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture1)
        
        // Set up the colours in the shader
        withUnsafePointer(to: &self.colourDiffuse, {
            $0.withMemoryRebound(to: Float.self, capacity: 4, {
                glUniform4fv(self.shader.getUniformLocation("colourDiff"), 1, $0)
            })
        })
        
        withUnsafePointer(to: &self.colourSpecular, {
            $0.withMemoryRebound(to: Float.self, capacity: 4, {
                glUniform4fv(self.shader.getUniformLocation("colourSpec"), 1, $0)
            })
        })
        
        // Set up the shininess
        glUniform1f(self.shader.getUniformLocation("shininess"), self.shininess)
        
        //withUnsafePointer(to: &self.shininess, {
        //    $0.withMemoryRebound(to: GLfloat.self, capacity: 1, {
        //        glUniform1f(self.shader.getUniformLocation("shininess"), $0)
        //    })
        //})
    }
    
    public func setColourDiffuse(_ colourDiff: GLKVector4)
    {
        self.colourDiffuse = colourDiff
    }
    
    public func setColourSpecular(_ colourSpec: GLKVector4)
    {
        self.colourSpecular = colourSpec
    }
    
    public func setShininess(_ shininess: GLfloat)
    {
        self.shininess = shininess
    }
}
