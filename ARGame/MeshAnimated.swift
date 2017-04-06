//
//  MeshAnimated.swift
//  ARGame
//
//  Created by James Rogers on 21/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

struct Bone
{
    var name: String = ""
    var offset: GLKMatrix4 = GLKMatrix4Identity
    var transform: GLKMatrix4 = GLKMatrix4Identity
    
    init(_ _name: String, _ _offset: GLKMatrix4)
    {
        self.name = _name
        self.offset = _offset
    }
}

/**
 Maintains OpenGL geometry and textures
 */
@objc class MeshAnimated : NSObject
{
    /**
     An array of animated vertex data.
     */
    private var vertices: Array<VertexAnimated>
    
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
     The Bones
    */
    internal var bones: Array<Bone> = Array()
    
    /**
     The Bone access data structure
    */
    private var boneIndex: [String: Int] = [String: Int]()
    
    /**
     The material.
     */
    private var material: Material = Material()
    
    /**
     Initalse a Mesh with an aray of vertices and indices.
     
     - parameters:
        - vertices: The vertices array of type Vertex.
        - indices: The indices array of type GLuint
     */
    init(_ _vertices: Array<VertexAnimated>, _ _indices: Array<GLuint>, _ _bones: Array<Bone>)
    {
        self.vertices = _vertices
        self.indices = _indices
        self.numIndices = GLsizei(indices.count)
        self.bones = _bones
        
        super.init()
        
        self.setupBoneAccess()
        self.setupMesh()
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
        effect.setTexture0(self.material.diffuseTexture.name)
        effect.setTexture1(self.material.specularTexture.name)
        effect.setColourDiffuse(self.material.diffuseColour)
        effect.setColourSpecular(self.material.specularColour)
        effect.setShininess(self.material.shininess)
        
        var boneTransforms: Array<GLKMatrix4> = Array()
        for i in 0..<self.bones.count
        {
            // Test matrix is correct in column major order
            /*print(self.bones[i].transform[0], self.bones[i].transform[4], self.bones[i].transform[8], self.bones[i].transform[12])
            print(self.bones[i].transform[1], self.bones[i].transform[5], self.bones[i].transform[9], self.bones[i].transform[13])
            print(self.bones[i].transform[2], self.bones[i].transform[6], self.bones[i].transform[10], self.bones[i].transform[14])
            print(self.bones[i].transform[3], self.bones[i].transform[7], self.bones[i].transform[11], self.bones[i].transform[15])*/
            boneTransforms.append(self.bones[i].transform)
        }
        
        // DEBUG //
        //boneTransforms[0] = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, 500.0)
        // END DEBUG //
        
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
        
        // Create buffers/arrays
        glGenVertexArraysOES(1, &self.VAO)
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
        
        glBindVertexArrayOES(0);
    }
    
    private func setupBoneAccess()
    {
        for i in 0..<self.bones.count
        {
            self.boneIndex[self.bones[i].name] = i
        }
    }
    
    public func animate(_ animation: AnimationSequence, _ skeleton: Skeleton)
    {
        self.processSkeletonHierarchy(animation, skeleton, GLKMatrix4Identity)
    }
    
    private func processSkeletonHierarchy(_ animation:AnimationSequence, _ skeleton: Skeleton, _ parentTransformation: GLKMatrix4)
    {
        
        var nodeTransformation: GLKMatrix4 = GLKMatrix4Identity
        
        // Get animation channel from dictonary O(1) access complexity
        let channel = animation.getChannel(skeleton.name)
        
        if channel != nil
        {
            // Do transformation stuff
            
            // Get the position, scale and rotation data from the channel
            let position: GLKVector3
            if (channel?.positions.count)! > animation.getFrame()
            {
                position = (channel?.positions[animation.getFrame()])!
            }
            else
            {
                position = GLKVector3Make(0.0, 0.0, 0.0)
            }
            
            let scale: GLKVector3
            if (channel?.scalings.count)! > animation.getFrame()
            {
                scale = (channel?.scalings[animation.getFrame()])!
            }
            else
            {
                scale = GLKVector3Make(0.0, 0.0, 0.0)
            }
            
            let rotation: GLKMatrix3
            if (channel?.rotations.count)! > animation.getFrame()
            {
                rotation = (channel?.rotations[animation.getFrame()])!
            }
            else
            {
                rotation = GLKMatrix3Identity
            }
            
            // Put into matricies
            let tranMat: GLKMatrix4 = GLKMatrix4TranslateWithVector3(GLKMatrix4Identity, position)
            let scalMat: GLKMatrix4 = GLKMatrix4ScaleWithVector3(GLKMatrix4Identity, scale)
            let rotMat: GLKMatrix4 = GLKMatrix4Make(
                rotation[0], rotation[3], rotation[6], 0.0,
                rotation[1], rotation[4], rotation[7], 0.0,
                rotation[2], rotation[5], rotation[8], 0.0,
                0.0,         0.0,         0.0,         1.0)
            
            // Transform bone
            nodeTransformation = GLKMatrix4Multiply(GLKMatrix4Multiply(tranMat, rotMat), scalMat)

        }
        
        // Find global transformation
        let globalTransformation: GLKMatrix4 = GLKMatrix4Multiply(parentTransformation, nodeTransformation)
        
        // Get bone index from dictonary O(1) access complexity
        if let index = self.boneIndex[skeleton.name]
        {
            // Apply transformation if bone exists
            self.bones[index].transform = GLKMatrix4Multiply(globalTransformation, self.bones[index].offset)
            //self.bones[index].transform =  globalTransformation
        }
        
        // Recursively process the remaining child nodes
        for i in 0..<skeleton.children.count
        {
            self.processSkeletonHierarchy(animation, skeleton.children[i], globalTransformation)
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
        var id: GLuint = 0
        
        if(self.material.diffuseTexture.name != 0)
        {
            id = self.material.diffuseTexture.name
            glDeleteTextures(1, &id)
        }
        
        if(self.material.specularTexture.name != 0)
        {
            id = self.material.specularTexture.name
            glDeleteTextures(1, &id)
        }
    }
}
