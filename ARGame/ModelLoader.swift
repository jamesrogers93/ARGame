//
//  objLoader.swift
//  ARGame
//
//  Created by James Rogers on 16/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation
import SceneKit

class ModelLoader
{
    
    static public func loadModelFromFile(_ path: String?) -> Model
    {
        // Convert Swift string to C string
        let path2 = Bundle.main.path(forResource: path, ofType: "obj")
        
        let cpath = path2?.cString(using: .utf8)
        
        // Load model using C code
        let loader = UnsafeRawPointer(initAssimpModelLoader(cpath))
        
        // Get number of meshes loaded
        let numMeshes: UInt32 = getNumMeshes(loader)
        
        // Instantiate meshes array to fill
        var meshes: Array<Mesh> = Array()
        
        // Loops over meshes
        for i in 0..<numMeshes
        {
            // Get index data from mesh
            let numIndices: Int = Int(getNumIndicesInMesh(loader, i))
            let indices = Array(UnsafeBufferPointer(start: getMeshIndices(loader, i), count: Int(numIndices)))
            
            // Get vertex data from mesh
            var vertices:Array<Vertex> = Array()
            let numVertices: Int = Int(getNumVerticesInMesh(loader, i))
            
            // Get temporary vertex array from loader
            let cvertices = Array(UnsafeBufferPointer(start: getMeshVertices(loader, i), count: Int(numVertices)))
            
            // Fill vertices array
            for j in stride(from: 0, to: numVertices, by: 8)
            {
                // Extract vertex data from vertices array
                let position: GLKVector3 = GLKVector3Make(cvertices[j], cvertices[j+1], cvertices[j+2])
                let normal: GLKVector3 = GLKVector3Make(cvertices[j+3], cvertices[j+4], cvertices[j+5])
                let texCoord: GLKVector2 = GLKVector2Make(cvertices[j+6], cvertices[j+7])
                
                // Add data to new vertex array
                vertices.append(Vertex(position, normal, texCoord))
            }
            
            // Add mesh to new mesh array
            meshes.append(Mesh(vertices, indices))
        }
        
        return Model(meshes);
    }
}
