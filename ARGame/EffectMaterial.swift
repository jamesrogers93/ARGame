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
    internal var colourDiffuse: GLKVector4 = GLKVector4Make(0.0, 0.0, 0.0, 0.0)
    internal var colourSpecular: GLKVector4 = GLKVector4Make(0.0, 0.0, 0.0, 0.0)
    internal var shininess: GLfloat = 0.0
    
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
                                     "isTextureDiff", "isTextureSpec",
                                     "colourDiff", "colourSpec",
                                     "shininess"]
        
        super.init(vertName, fragName, vertAttribs, uniformNames)
    }
    
    internal override init(_ _vertName: String, _ _fragName: String, _ _vertAttribs: [(GLint, String)], _ _uniformNames: [String])
    {
        super.init(_vertName, _fragName, _vertAttribs, _uniformNames)
    }
    
    public override func prepareToDraw()
    {
        super.prepareToDraw()
        
        // Set up the projection matrix in the shader
        if let loc = self.shader.getUniformLocation("projectionMatrix")
        {
            withUnsafePointer(to: &self.projection, {
                $0.withMemoryRebound(to: Float.self, capacity: 16, {
                    glUniformMatrix4fv(loc, 1, 0, $0)
                })
            })
        }
        // Set up the view matrix in the shader
        if let loc = self.shader.getUniformLocation("viewMatrix")
        {
            withUnsafePointer(to: &self.view, {
                $0.withMemoryRebound(to: Float.self, capacity: 16, {
                    glUniformMatrix4fv(loc, 1, 0, $0)
                })
            })
        }
        
        // Set up the model matrix in the shader
        if let loc = self.shader.getUniformLocation("modelMatrix")
        {
            withUnsafePointer(to: &self.model, {
                $0.withMemoryRebound(to: Float.self, capacity: 16, {
                    glUniformMatrix4fv(loc, 1, 0, $0)
                })
            })
        }
            
        // Set up the normal matrix in the shader
        if let loc = self.shader.getUniformLocation("normalMatrix")
        {
            var didInvTrans: UnsafeMutablePointer<Bool>!
            var normal: GLKMatrix3 = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(self.model, didInvTrans))
            withUnsafePointer(to: &normal, {
                $0.withMemoryRebound(to: Float.self, capacity: 12, {
                    glUniformMatrix3fv(loc, 1, 0, $0)
                })
            })
        }
        
        // Set up the view position
        if let loc = self.shader.getUniformLocation("viewPosition")
        {
            var didInvTrans: UnsafeMutablePointer<Bool>!
            var invView: GLKMatrix4 = GLKMatrix4Invert(self.view, didInvTrans)
            var viewPosition4 = GLKMatrix4GetColumn(invView, 3)
            var viewPosition: GLKVector3 = GLKVector3Make(viewPosition4.x, viewPosition4.y, viewPosition4.z)
            withUnsafePointer(to: &viewPosition, {
                $0.withMemoryRebound(to: Float.self, capacity: 3, {
                    glUniform3fv(loc, 1, $0)
                })
            })
        }
        
        //print("x: \(viewPosition.x), y: \(viewPosition.y), z: \(viewPosition.z)")
        
        // Set up the colour in the shader
        if let loc = self.shader.getUniformLocation("colour")
        {
            withUnsafePointer(to: &colour, {
                $0.withMemoryRebound(to: Float.self, capacity: 4, {
                    glUniform4fv(loc, 1, $0)
                })
            })
        }
        
        // Set up the texture in the shader
        if let loc = self.shader.getUniformLocation("textureDiff")
        {
            glActiveTexture(GLenum(GL_TEXTURE0))
            glUniform1f(loc, 0)
            glBindTexture(GLenum(GL_TEXTURE_2D), self.texture0)
        }
        
        if let loc = self.shader.getUniformLocation("textureSpec")
        {
            glActiveTexture(GLenum(GL_TEXTURE1))
            glUniform1f(loc, 0)
            glBindTexture(GLenum(GL_TEXTURE_2D), self.texture1)
        }
        
        if let loc = self.shader.getUniformLocation("isTextureDiff")
        {
            glUniform1i(loc, self.isTexture0Loaded ? 1 : 0)
        }
        
        if let loc = self.shader.getUniformLocation("isTextureSpec")
        {
            glUniform1i(loc, self.isTexture1Loaded ? 1 : 0)
        }
        
        // Set up the colours in the shader
        if let loc = self.shader.getUniformLocation("colourDiff")
        {
            withUnsafePointer(to: &self.colourDiffuse, {
                $0.withMemoryRebound(to: Float.self, capacity: 4, {
                    glUniform4fv(loc, 1, $0)
                })
            })
        }
        
        if let loc = self.shader.getUniformLocation("colourSpec")
        {
            withUnsafePointer(to: &self.colourSpecular, {
                $0.withMemoryRebound(to: Float.self, capacity: 4, {
                    glUniform4fv(loc, 1, $0)
                })
            })
        }
        
        // Set up the shininess
        if let loc = self.shader.getUniformLocation("shininess")
        {
            glUniform1f(loc, self.shininess)
        }
        
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
