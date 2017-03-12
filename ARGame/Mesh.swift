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

/**
Maintains OpenGL geometry and textures
 */
@objc class Mesh : NSObject
{
    
    /**
     An array of vertex data.
     */
    private var vertices: Array<Vertex>
    
    /**
     An array of vertex index data.
     */
    private var indices: Array<GLuint>
    
    /**
     The number of indices in the vertex index array.
     */
    private var numIndices: GLsizei = 0
    
    /**
     The Vertex Array Object.
     */
    private var VAO: GLuint = 0
    
    /**
     The Vertex Buffer Object.
     */
    private var VBO: GLuint = 0
    
    /**
     The Element Buffer Object.
     */
    private var EBO: GLuint = 0
    
    /**
     The diffuse texture.
     */
    private var diffuseTexture: GLKTextureInfo = GLKTextureInfo()
    
    /**
     The specular texture.
     */
    private var specularTexture: GLKTextureInfo = GLKTextureInfo()
    
    /**
     Initalse a Mesh with an aray of vertices and indices.
     
     - parameters:
        - vertices: The vertices array of type Vertex.
        - indices: The indices array of type GLuint
     */
    init(_ vertices: Array<Vertex>, _ indices: Array<GLuint>)
    {
        self.vertices = vertices
        self.indices = indices
        self.numIndices = GLsizei(indices.count)
        
        super.init()
        
        self.setupMesh()
    }
    
    /**
     Draws the geometry using the passed Effect.
     
     - parameters:
        - effect: The effect to draw the geometry.
     
     This function puts the contents of the mesh in the Effect.
     */
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
    
    /**
     Sets the diffuse texture.
     
     - parameters:
        - diffuse: The diffuse texture of type GLKTextureInfo.
     */
    public func setDiffuseTexture(_ diffuse: GLKTextureInfo)
    {
        self.diffuseTexture = diffuse;
    }
    
    /**
     Sets the specular texture.
     
     - parameters:
        - specular: The specular texture of type GLKTextureInfo.
     */
    public func setSpecularTexture(_ specular: GLKTextureInfo)
    {
        self.specularTexture = specular;
    }
    
    /**
     Loads the VAO, VBO and EBO with the contents of the vertex and indices array
     */
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
    
    /**
     Destroys the VAO, VBO and EBO in OpenGL.
     */
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
