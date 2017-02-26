//
//  Mesh.swift
//  ARGame
//
//  Created by James Rogers on 17/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation
import GLKit

struct Vertex
{
    var position: GLKVector3 = GLKVector3Make(0.0, 0.0, 0.0)
    var normal: GLKVector3 = GLKVector3Make(0.0, 0.0, 0.0)
    var texCoord: GLKVector2 = GLKVector2Make(0.0, 0.0)
    
    init()
    {
        
    }
    
    init(_ position: GLKVector3, _ normal: GLKVector3, _ texCoord: GLKVector2)
    {
        self.position = position
        self.normal = normal
        self.texCoord = texCoord
    }
};

@objc class Mesh : NSObject
{
    
    private var vertices: Array<Vertex>
    private var indices: Array<GLuint>
    
    private var VAO: GLuint = 0
    private var VBO: GLuint = 0
    private var EBO: GLuint = 0
    
    private var texture: GLKTextureInfo? = nil
    private var textureLoaded:Bool = false;
    
    init(_ vertices: Array<Vertex>, _ indices: Array<GLuint>)
    {
        self.vertices = vertices
        self.indices = indices
        
        super.init()
        
        self.setupMesh()
    }
    
    deinit
    {
        glDeleteBuffers(1, &self.VBO)
        glDeleteBuffers(1, &self.EBO)
        glDeleteVertexArraysOES(1, &self.VAO)
    }
    
    public func draw(_ effect: GLKBaseEffect?)
    {
        // Bind vertex array for drawing
        glBindVertexArrayOES(VAO)
        
        // Bind texture
        if (self.textureLoaded)
        {
            if((self.texture?.name)! != 0)
            {
                //glBindTexture(GLenum((self.texture?.target)!), (self.texture?.name)!)
                effect?.texture2d0.enabled = GLboolean(GL_TRUE)
                effect?.texture2d0.name = (self.texture?.name)!
                //effect?.texture2d0.target = GLenum((self.texture?.target)!)
            }
        }
        
        // Render the object with GLKit
        effect?.prepareToDraw()
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), BUFFER_OFFSET(0))
        
        // Unbind vertex array
        glBindVertexArrayOES(0)
    }
    
    public func setTexture(_ texture: GLKTextureInfo)
    {
        self.texture = texture;
        self.textureLoaded = true;
    }
    
    private func setupMesh()
    {

        // Create buffers/arrays
        glGenVertexArraysOES(1, &self.VAO)
        glGenBuffers(1, &self.VBO)
        glGenBuffers(1, &self.EBO)
        
        // Bind vertex array
        glBindVertexArrayOES(self.VAO);
        
        // Load data into buffers
        
        // Vertex Buffer
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<Vertex>.size * self.vertices.count), &self.vertices, GLenum(GL_STATIC_DRAW))
        
        // Element Buffer
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.EBO)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<GLuint>.size * self.indices.count), &self.indices, GLenum(GL_STATIC_DRAW))
        
        // Set the vertex attribute pointers
        
        // Vertex Positions
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(0))

        // Vertex Normals
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.normal.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size))
        
        // Texture Coordinates
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.texCoord0.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size * 2))
        
        glBindVertexArrayOES(0);
    }
}
