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
    private var numIndices: GLsizei = 0
    
    private var VAO: GLuint = 0
    private var VBO: GLuint = 0
    private var EBO: GLuint = 0
    
    private var diffuseTexture: GLKTextureInfo = GLKTextureInfo()
    private var specularTexture: GLKTextureInfo = GLKTextureInfo()
    
    init(_ vertices: Array<Vertex>, _ indices: Array<GLuint>)
    {
        self.vertices = vertices
        self.indices = indices
        self.numIndices = GLsizei(indices.count)
        
        super.init()
        
        self.setupMesh()
    }
    
    public func draw(_ effect: Effect)
    {
        // Prepare Effect
        effect.setTexture0(diffuseTexture.name)
        effect.setTexture1(specularTexture.name)
        effect.prepareToDraw()
        
        // Bind vertex array for drawing
        glBindVertexArrayOES(VAO)
        
        // Draw the mesh
        glDrawElements(GLenum(GL_TRIANGLES), self.numIndices, GLenum(GL_UNSIGNED_INT), BUFFER_OFFSET(0))
        
        // Unbind vertex array
        glBindVertexArrayOES(0)
    }
    
    public func setDiffuseTexture(_ diffuse: GLKTextureInfo)
    {
        self.diffuseTexture = diffuse;
    }
    
    public func setSpecularTexture(_ specular: GLKTextureInfo)
    {
        self.specularTexture = specular;
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
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.position.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(0))

        // Vertex Normals
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.normal.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size))
        
        // Texture Coordinates
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.texCoord.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.texCoord.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size * 2))
        
        glBindVertexArrayOES(0);
    }
    
    public func destroy()
    {
        // Delete buffers
        glDeleteBuffers(1, &self.VBO)
        glDeleteBuffers(1, &self.EBO)
        glDeleteVertexArraysOES(1, &self.VAO)
        
        //Delete textures
        var id: GLuint = 0
        
        if(self.diffuseTexture.name != 0)
        {
            id = self.diffuseTexture.name
            glDeleteTextures(1, &id)
        }
        
        if(self.specularTexture.name != 0)
        {
            id = self.specularTexture.name
            glDeleteTextures(1, &id)
        }
    }
}
