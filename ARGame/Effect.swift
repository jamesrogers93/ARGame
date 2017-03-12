//
//  Effect.swift
//  ARGame
//
//  Created by James Rogers on 10/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class Effect
{
    internal var shader:Shader!
    
    internal var projection:GLKMatrix4 = GLKMatrix4Identity
    internal var view:GLKMatrix4 = GLKMatrix4Identity
    internal var model:GLKMatrix4 = GLKMatrix4Identity
    internal var colour: GLKVector4 = GLKVector4Make(0.0, 0.0, 0.0, 0.0)
    internal var texture0: GLuint = 0
    internal var texture1: GLuint = 0
    
    internal init(_ vertex: String, _ fragment: String, _ vertexAttribs: [(GLint, String)], _ uniformNames:[String])
    {
       
        self.shader = Shader.loadShader(vertex, fragment, vertexAttribs, uniformNames)
        if(shader == nil)
        {
            print("Failed to create shader")
        }
        
    }
    
    public func setProjection(_ projection: GLKMatrix4)
    {
        self.projection = projection
    }
    
    public func setView(_ view:GLKMatrix4)
    {
        self.view = view
    }
    
    public func setModel(_ model: GLKMatrix4)
    {
        self.model = model
    }
    
    public func setColour(_ colour: GLKVector4)
    {
        self.colour = colour
    }
    
    public func setTexture0(_ texture: GLuint)
    {
        self.texture0 = texture
    }
    
    public func setTexture1(_ texture: GLuint)
    {
        self.texture1 = texture
    }
    
    internal func prepareToDraw()
    {
        self.shader.useProgram()
    }
    
    public func destroy()
    {
        if(self.shader != nil)
        {
            self.shader.destroy()
        }
    }
}











