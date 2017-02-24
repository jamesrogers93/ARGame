//
//  ARCameraFeed.swift
//  ARGame
//
//  Created by James Rogers on 23/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation
import GLKit

class ARCameraFeed
{
    // The OpenGL mesh which covers the display
    private var display: Mesh? = nil
    
    // The shader progam for the display
    private var effect: GLKBaseEffect? = nil
    
    public var texture: GLuint = 0;
    
    init(_ projection: GLKMatrix4)
    {
        initEffect(projection)
        initDisplay()
    }
    
    deinit
    {
        display = nil
        effect = nil
    }
    
    public func draw()
    {
        if(texture != 0)
        {
            effect?.texture2d0.enabled = GLboolean(GL_TRUE)
            effect?.texture2d0.name = texture
        }
        display?.draw(effect)
    }
    
    public func setCameraBuffer(_ buffer: GLKTextureInfo)
    {
       // buffer.name =
        self.display?.setTexture(buffer)
    }
    
    private func initDisplay()
    {
        // Mesh geometry
        var vertices: Array<Vertex> = Array();
        vertices.append(Vertex(GLKVector3Make(-1.0, -1.0, 0.0), GLKVector3Make(0.0, 0.0, 1.0), GLKVector2Make(0.0, 1.0)))
        vertices.append(Vertex(GLKVector3Make(-1.0,  1.0, 0.0), GLKVector3Make(0.0, 0.0, 1.0), GLKVector2Make(0.0, 0.0)))
        vertices.append(Vertex(GLKVector3Make( 1.0,  1.0, 0.0), GLKVector3Make(0.0, 0.0, 1.0), GLKVector2Make(1.0, 0.0)))
        vertices.append(Vertex(GLKVector3Make( 1.0, -1.0, 0.0), GLKVector3Make(0.0, 0.0, 1.0), GLKVector2Make(1.0, 1.0)))
        
        var indices: Array<GLuint> = Array();
        indices.append(0); indices.append(1); indices.append(2)
        indices.append(2); indices.append(3); indices.append(0)
        
        display = Mesh(vertices, indices)
    }
    
    private func initEffect(_ projection: GLKMatrix4)
    {
        self.effect = GLKBaseEffect()
        //self.effect?.transform.projectionMatrix = projection
        //self.effect?.transform.modelviewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, -5.5)
        self.effect?.transform.projectionMatrix = GLKMatrix4Identity
        self.effect?.transform.modelviewMatrix = GLKMatrix4Identity
        
        self.effect!.light0.enabled = GLboolean(GL_TRUE)    // Add light
        self.effect!.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0)   // Set light colour
    }
}
