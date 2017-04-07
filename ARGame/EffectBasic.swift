//
//  EffectBasic.swift
//  ARGame
//
//  Created by James Rogers on 10/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class EffectBasic : Effect
{
    
    public init()
    {
        // Set shader parameters
        let vertName: String = "ShaderBasic"
        let fragName: String = "ShaderBasic"
        
        let vertAttribs: [(GLint, String)] = [(ShaderVertexAttrib.position.rawValue, "position"),
                                              (ShaderVertexAttrib.normal.rawValue,   "normal"),
                                              (ShaderVertexAttrib.texCoord.rawValue, "texCoord")];
        
        let uniformNames:[String] = ["modelViewProjectionMatrix",
                                     "colour",
                                     "texture0", "texture1"]
        
        super.init(vertName, fragName, vertAttribs, uniformNames)
    }
    
    public override func prepareToDraw()
    {
        super.prepareToDraw()
        
        // Compute model view matrix
        let modelViewMatrix = GLKMatrix4Multiply(self.view, self.model)
        var modelViewProjectionMatrix = GLKMatrix4Multiply(self.projection, modelViewMatrix)
        
        // Set up the modelViewProjection matrix in the shader
        if let loc = self.shader.getUniformLocation("modelViewProjectionMatrix")
        {
            withUnsafePointer(to: &modelViewProjectionMatrix, {
                $0.withMemoryRebound(to: Float.self, capacity: 16, {
                    glUniformMatrix4fv(loc, 1, 0, $0)
                })
            })
        }
        
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
        if let loc = self.shader.getUniformLocation("texture0")
        {
            glActiveTexture(GLenum(GL_TEXTURE0))
            glUniform1f(loc, 0)
            glBindTexture(GLenum(GL_TEXTURE_2D), self.texture0)
        }
        
        if let loc = self.shader.getUniformLocation("texture1")
        {
            glActiveTexture(GLenum(GL_TEXTURE1))
            glUniform1f(loc, 0)
            glBindTexture(GLenum(GL_TEXTURE_2D), self.texture1)
        }
    }
}
