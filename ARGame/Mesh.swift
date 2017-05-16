//
//  Mesh.swift
//  ARGame
//
//  Created by James Rogers on 07/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class Mesh
{
    /**
     An array of vertex index data.
     */
    fileprivate var indices: Array<GLuint>
    
    /**
     The number of indices in the vertex index array.
     */
    fileprivate var numIndices: GLsizei = 0
    
    /**
     The Vertex Array Object.
     */
    fileprivate var VAO: GLuint = 0
    
    /**
     The Vertex Buffer Object.
     */
    fileprivate var VBO: GLuint = 0
    
    /**
     The Element Buffer Object.
     */
    fileprivate var EBO: GLuint = 0
    
    /**
     The material.
     */
    fileprivate var material: Material = Material()
    
    fileprivate init(_ _indices: Array<GLuint>)
    {
        self.indices = _indices
        self.numIndices = GLsizei(_indices.count)
    }
}

/**
 Maintains static OpenGL geometry and textures
 */
class MeshStatic : Mesh
{
    
    /**
     An array of vertex data.
     */
    private var vertices: Array<Vertex>
    
    /**
     Initalse a Mesh with an aray of vertices and indices.
     
     - parameters:
        - vertices: The vertices array of type Vertex.
        - indices: The indices array of type GLuint
     */
    init(_ vertices: Array<Vertex>, _ _indices: Array<GLuint>)
    {
        self.vertices = vertices
        
        super.init(_indices)
        
        self.setupMesh()
    }
    
    /**
     Draws the geometry using the passed Effect.
     
     - parameters:
        - effect: The effect to draw the geometry.
     
     This function puts the contents of the mesh in the Effect.
     */
    public func draw(_ effect: EffectMaterial)
    {
        // Prepare Effect
        // Prepare Effect
        if self.material.diffuseTexture.0
        {
            if TexturePool.textures[self.material.diffuseTexture.1] != nil
            {
                effect.setTexture0((TexturePool.textures[self.material.diffuseTexture.1]?.name)!)
                effect.setIsTexture0Loaded(true)
            }
            else
            {
                effect.setIsTexture0Loaded(false)
            }
        }
        else
        {
            effect.setIsTexture0Loaded(false)
        }
        //effect.setIsTexture0Loaded(self.material.diffuseTexture.0)
        
        if self.material.specularTexture.0
        {
            if TexturePool.textures[self.material.specularTexture.1] != nil
            {
                effect.setTexture1((TexturePool.textures[self.material.specularTexture.1]?.name)!)
                effect.setIsTexture1Loaded(true)
            }
            else
            {
                effect.setIsTexture1Loaded(false)
            }
        }
        else
        {
            effect.setIsTexture1Loaded(false)
        }
        //effect.setIsTexture1Loaded(self.material.specularTexture.0)
        
        effect.setColourDiffuse(self.material.diffuseColour)
        effect.setColourSpecular(self.material.specularColour)
        effect.setShininess(self.material.shininess)
        effect.prepareToDraw()
        
        // Bind vertex array for drawing
        glBindVertexArrayOES(VAO)
        
        // Draw the mesh
        glDrawElements(GLenum(GL_TRIANGLES), self.numIndices, GLenum(GL_UNSIGNED_INT), BUFFER_OFFSET(0))
        
        // Unbind vertex array
        glBindVertexArrayOES(0)
    }
    
    /**
     Sets the material.
     
     - parameters:
        - material: The material of type Material.
     */
    public func setMaterial(_ material: Material)
    {
        self.material = material;
    }
    
    /**
     Loads the VAO, VBO and EBO with the contents of the vertex and indices array
     */
    private func setupMesh()
    {
        setupVBOs()
        setupVAO()
        
        // Create buffers/arrays
        /*glGenVertexArraysOES(1, &self.VAO)
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
        
        glBindVertexArrayOES(0);*/
    }
    
    private func setupVBOs()
    {
        // Create buffers
        glGenBuffers(1, &self.VBO)
        glGenBuffers(1, &self.EBO)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<Vertex>.size * self.vertices.count), &self.vertices, GLenum(GL_STATIC_DRAW))
        
        // Element Buffer
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.EBO)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<GLuint>.size * self.indices.count), &self.indices, GLenum(GL_STATIC_DRAW))
    }
    
    public func setupVAO()
    {
        // Create vertex array object
        glGenVertexArraysOES(1, &self.VAO)
        
        // Bind VAO and VBOs
        glBindVertexArrayOES(self.VAO);
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.VBO)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.EBO)
        
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
     Destroys the VAO, VBO, EBO and material textures in OpenGL.
     */
    public func destroy()
    {
        // Delete buffers
        glDeleteBuffers(1, &self.VBO)
        glDeleteBuffers(1, &self.EBO)
        glDeleteVertexArraysOES(1, &self.VAO)
        
        //Delete textures
        //var id: GLuint = 0
        
        /*if(self.material.diffuseTexture.1.name != 0)
        {
            id = self.material.diffuseTexture.1.name
            glDeleteTextures(1, &id)
        }
        
        if(self.material.specularTexture.1.name != 0)
        {
            id = self.material.specularTexture.1.name
            glDeleteTextures(1, &id)
        }*/
    }
}

/**
 Maintains OpenGL geometry and textures
 */
class MeshAnimated : Mesh
{
    /**
     An array of animated vertex data.
     */
    private var vertices: Array<VertexAnimated>
    
    /**
     The Bones
     */
    internal var _bones: Array<Bone> = Array()
    
    /**
     The Bone access data structure
     */
    private var _boneIndex: [String: Int] = [String: Int]()
    
    /**
     Initalse a Mesh with an aray of vertices and indices.
     
     - parameters:
        - vertices: The vertices array of type Vertex.
        - indices: The indices array of type GLuint
     */
    init(_ _vertices: Array<VertexAnimated>, _ indices: Array<GLuint>, _ _bones: Array<Bone>)
    {
        self.vertices = _vertices
        self._bones = _bones
        
        super.init(indices)
        
        self.setupBoneAccess()
        self.setupMesh()
    }
    
    var bones: Array<Bone>
    {
        get
        {
            return self._bones
        }
    }
    
    var boneIndex: [String: Int]
    {
        get
        {
            return self._boneIndex
        }
    }
    
    
    /**
     Draws the geometry using the passed Effect.
     
     - parameters:
        - effect: The effect to draw the geometry.
     
     This function puts the contents of the mesh in the Effect.
     */
    public func draw(_ effect: EffectMatAnim)
    {
        // Prepare Effect
        if self.material.diffuseTexture.0
        {
            if TexturePool.textures[self.material.diffuseTexture.1] != nil
            {
                effect.setTexture0((TexturePool.textures[self.material.diffuseTexture.1]?.name)!)
                effect.setIsTexture0Loaded(true)
            }
            else
            {
                effect.setIsTexture0Loaded(false)
            }
        }
        else
        {
            effect.setIsTexture0Loaded(false)
        }
        
        if self.material.specularTexture.0
        {
            if TexturePool.textures[self.material.specularTexture.1] != nil
            {
                effect.setTexture1((TexturePool.textures[self.material.specularTexture.1]?.name)!)
                effect.setIsTexture1Loaded(true)
            }
            else
            {
                effect.setIsTexture1Loaded(false)
            }
        }
        else
        {
            effect.setIsTexture1Loaded(false)
        }
        
        effect.setColourDiffuse(self.material.diffuseColour)
        effect.setColourSpecular(self.material.specularColour)
        effect.setShininess(self.material.shininess)
        
        var boneTransforms: Array<GLKMatrix4> = Array()
        for i in 0..<self._bones.count
        {
            boneTransforms.append(self._bones[i].transform)
        }
        
        effect.setBones(boneTransforms)
        
        effect.prepareToDraw()
        
        // Bind vertex array for drawing
        glBindVertexArrayOES(VAO)
        
        // Draw the mesh
        glDrawElements(GLenum(GL_TRIANGLES), self.numIndices, GLenum(GL_UNSIGNED_INT), BUFFER_OFFSET(0))
        
        // Unbind vertex array
        glBindVertexArrayOES(0)
    }
    
    /**
     Sets the material.
     
     - parameters:
        - material: The material of type Material.
     */
    public func setMaterial(_ material: Material)
    {
        self.material = material;
    }
    
    /**
     Loads the VAO, VBO and EBO with the contents of the vertex and indices array
     */
    private func setupMesh()
    {
        setupVBOs()
        setupVAO()
        
        // Create buffers/arrays
        /*glGenVertexArraysOES(1, &self.VAO)
        glGenBuffers(1, &self.VBO)
        glGenBuffers(1, &self.EBO)
        
        // Bind vertex array
        glBindVertexArrayOES(self.VAO);
        
        // Load data into buffers
        
        // Vertex Buffer
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<VertexAnimated>.size * self.vertices.count), &self.vertices, GLenum(GL_STATIC_DRAW))
        
        // Element Buffer
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.EBO)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<GLuint>.size * self.indices.count), &self.indices, GLenum(GL_STATIC_DRAW))
        
        // Set the vertex attribute pointers
        
        // Vertex Positions
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.position.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(0))
        
        // Vertex Normals
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.normal.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size))
        
        // Texture Coordinates
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.texCoord.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.texCoord.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size * 2))
        
        // Bone IDs
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.boneIds.rawValue))
        glVertexAttribIPointer(GLuint(ShaderVertexAttrib.boneIds.rawValue), 4, GLenum(GL_INT), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size * 2 + MemoryLayout<GLKVector2>.size))
        
        // Bone Weights
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.boneWeight.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.boneWeight.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size * 2 + MemoryLayout<GLKVector2>.size + MemoryLayout<Vector4i>.size))
        
        glBindVertexArrayOES(0);*/
    }
    
    private func setupVBOs()
    {
        // Create buffers
        glGenBuffers(1, &self.VBO)
        glGenBuffers(1, &self.EBO)
        
        // Vertex Buffer
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<VertexAnimated>.size * self.vertices.count), &self.vertices, GLenum(GL_STATIC_DRAW))
        //glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        
        // Element Buffer
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.EBO)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<GLuint>.size * self.indices.count), &self.indices, GLenum(GL_STATIC_DRAW))
        //glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
    }
    
    public func setupVAO()
    {
        // Create vertex array object
        glGenVertexArraysOES(1, &self.VAO)
        
        // Bind VAO and VBOs
        glBindVertexArrayOES(self.VAO);
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.VBO)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.EBO)
        
        // Set the vertex attribute pointers
        
        // Vertex Positions
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.position.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(0))
        
        // Vertex Normals
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.normal.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size))
        
        // Texture Coordinates
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.texCoord.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.texCoord.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size * 2))
        
        // Bone IDs
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.boneIds.rawValue))
        glVertexAttribIPointer(GLuint(ShaderVertexAttrib.boneIds.rawValue), 4, GLenum(GL_INT), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size * 2 + MemoryLayout<GLKVector2>.size))
        
        // Bone Weights
        glEnableVertexAttribArray(GLuint(ShaderVertexAttrib.boneWeight.rawValue))
        glVertexAttribPointer(GLuint(ShaderVertexAttrib.boneWeight.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexAnimated>.size), BUFFER_OFFSET(MemoryLayout<GLKVector3>.size * 2 + MemoryLayout<GLKVector2>.size + MemoryLayout<Vector4i>.size))
        
        glBindVertexArrayOES(0);
    }
    
    private func setupBoneAccess()
    {
        for i in 0..<self._bones.count
        {
            self._boneIndex[self._bones[i].name] = i
        }
    }
    
    /**
     Destroys the VAO, VBO, EBO and material textures in OpenGL.
     */
    public func destroy()
    {
        // Delete buffers
        glDeleteBuffers(1, &self.VBO)
        glDeleteBuffers(1, &self.EBO)
        glDeleteVertexArraysOES(1, &self.VAO)
        
        //Delete textures
        /*var id: GLuint = 0
        
        if(self.material.diffuseTexture.1.name != 0)
        {
            id = self.material.diffuseTexture.1.name
            glDeleteTextures(1, &id)
        }
        
        if(self.material.specularTexture.1.name != 0)
        {
            id = self.material.specularTexture.1.name
            glDeleteTextures(1, &id)
        }*/
    }
}
