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
    /**
     Loads a static model from file using the Assimp library.
     
     - parameters:
        - resource: Name of the resource to be loaded.
        - type: The type of object to be loaded eg. obj.
     
     - returns:
     The loaded model.
     */
    static public func loadStaticModelFromFile(_ resource: String, _ type: String) -> ModelStatic
    {
        // Find obj path of resource
        let objPath = Bundle.main.path(forResource: resource, ofType: type)
        
        // Convert path to C string
        let cpath = objPath?.cString(using: .utf8)
        
        // Load model using C code
        let loader = UnsafeRawPointer(mlLoadStaticAssimpModel(cpath))
        
        // Extract the meshes from the assimp loader
        let meshes: Array<MeshStatic> = extractStaticMeshesFromLoader(loader!)
        
        // Destroy assimp model
        mlDestroyAssimpModelLoader(loader)
        
        return ModelStatic(meshes);
    }
    
    /**
     Loads a animated model from file using the Assimp library.
     
     - parameters:
     - resource: Name of the resource to be loaded.
     - type: The type of object to be loaded eg. fbx.
     
     - returns:
     The loaded animated model.
     */
    static public func loadAnimatedModelFromFile(_ resource: String, _ type: String) -> ModelAnimated
    {
        // Find obj path of resource
        let objPath = Bundle.main.path(forResource: resource, ofType: type)
        
        // Convert path to C string
        let cpath = objPath?.cString(using: .utf8)
        
        // Load model using C code
        let loader = UnsafeRawPointer(mlLoadAnimatedAssimpModel(cpath))
        
        // Extract the meshes from the assimp loader
        let meshes: Array<MeshAnimated> = extractAnimatedMeshesFromLoader(loader!)
        
        // Extract the animations from the assimp loader
        let animations: Array<AnimationSequence> = extractAnimationsFromLoader(loader!)
        
        // Extract the skeleton from the assimp loader
        let skeleton: Skeleton = extractSkeletonFromLoader(loader!)
        
        // Destroy assimp model
        mlDestroyAssimpModelLoader(loader)
        
        return ModelAnimated(meshes, animations, skeleton)
    }
    
    /**
     Extracts a static mesh array from the assimp loader class.
     
     - parameters:
        - loader: An unsafe pointer to the C++ AssimpModelLoader object.
     
     - returns:
     A MeshStatic array.
     */
    static private func extractStaticMeshesFromLoader(_ loader:UnsafeRawPointer) -> Array<MeshStatic>
    {
        // Get number of meshes loaded
        let numMeshes: UInt32 = mlGetNumMeshes(loader)
        
        // Instantiate meshes array to fill
        var meshes: Array<MeshStatic> = Array()
        
        // Loops over meshes
        for i in 0..<numMeshes
        {
            //
            // Load Vertex data
            //
            
            // Get vertex data from mesh
            var vertices:Array<Vertex> = Array()
            let numVertices: Int = Int(mlGetNumVerticesInMesh(loader, i))
            
            // Get temporary vertex array from loader
            let cvertices = Array(UnsafeBufferPointer(start: mlGetMeshVertices(loader, i), count: numVertices))
            
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
            
            //
            // Load Index data
            //
            
            // Get index data from mesh
            let numIndices: Int = Int(mlGetNumIndicesInMesh(loader, i))
            let indices = Array(UnsafeBufferPointer(start: mlGetMeshIndices(loader, i), count: numIndices))
            
            //
            // Create Mesh
            //
            let mesh:MeshStatic = MeshStatic(vertices, indices)
            
            //
            // Load Material data
            //
            
            // Diffuse texture
            var diffuseTexture: GLKTextureInfo = GLKTextureInfo()
            var diffTexName: String? = nil
            let opt:[String: NSNumber] = [GLKTextureLoaderGenerateMipmaps:false]
            
            let isDiffuseLoaded: Bool = Int(mlGetMeshIsDiffuseMapLoaded(loader, i)) != 0
            
            if(isDiffuseLoaded)
            {
                // Load diffuse texture
                diffTexName = String(cString: mlGetMeshDiffuseMap(loader, i))
                
                // Cut extension off of tex name
                let index = diffTexName?.range(of: ".", options: .backwards)?.lowerBound
                let diffTexName2 = diffTexName?.substring(to: index!)
                let diffTexExt = diffTexName?.substring(from: (diffTexName?.index(after: index!))!)
                
                // Get resource path
                let path = Bundle.main.path(forResource: diffTexName2, ofType: diffTexExt)
                
                do
                {
                    // Load texture
                    diffuseTexture = try GLKTextureLoader.texture(withContentsOfFile: path!, options: opt)
                    
                    // Add texture to the mesh
                    //mesh.setDiffuseTexture(diffuseTexture!)
                }catch
                {
                    
                    print("Could not load diffuse texture for model")
                }
                
            }
            
            // Specular texture
            var specularTexture: GLKTextureInfo = GLKTextureInfo()
            var specTexName: String? = nil
            
            let isSpecularLoaded: Bool = Int(mlGetMeshIsSpecularMapLoaded(loader, i)) != 0
            if(isSpecularLoaded)
            {
                // Load diffuse texture
                specTexName = String(cString: mlGetMeshSpecularMap(loader, i))
                
                // Cut extension off of tex name
                let index = specTexName?.range(of: ".", options: .backwards)?.lowerBound
                let specTexName2 = specTexName?.substring(to: index!)
                let specTexExt = specTexName?.substring(from: (specTexName?.index(after: index!))!)
                
                // Get resource path
                let path = Bundle.main.path(forResource: specTexName2, ofType: specTexExt)
                
                do
                {
                    // Load texture
                    specularTexture = try GLKTextureLoader.texture(withContentsOfFile: path!, options: opt)
                    
                    // Add texture to the mesh
                    //mesh.setSpecularTexture(specularTexture!)
                }catch
                {
                    print("Could not load specular texture for model")
                }
            }
            
            // Diffuse colour
            let diffCol = Array(UnsafeBufferPointer(start: mlGetMeshDiffuseCol(loader, i), count: 4))
            let diffuseColour:GLKVector4 = GLKVector4Make(diffCol[0], diffCol[1], diffCol[2], diffCol[3])
            print("Diffuse Colour R: \(diffCol[0]) G: \(diffCol[1]) B: \(diffCol[2]) A: \(diffCol[3])")
            
            
            // Specular colour
            let specCol = Array(UnsafeBufferPointer(start: mlGetMeshSpecularCol(loader, i), count: 4))
            let specularColour:GLKVector4 = GLKVector4Make(specCol[0], specCol[1], specCol[2], specCol[3])
            print("Specular Colour R: \(specCol[0]) G: \(specCol[1]) B: \(specCol[2]) A: \(specCol[3])")
            
            // Shininess
            let shininess: Float = Float(mlGetMeshShininess(loader, i))
            
            let material: Material = Material(diffuseTexture, specularTexture, diffuseColour, specularColour, shininess)
            mesh.setMaterial(material)
            
            //
            //   Mesh Loading complete
            //
            
            // Add mesh to new mesh array
            meshes.append(mesh)
        }

        return meshes
    }
    
    /**
     Extracts a animated mesh array from the assimp loader class.
     
     - parameters:
        - loader: An unsafe pointer to the C++ AssimpModelLoader object.
     
     - returns:
     A MeshAnimated array.
     */
    static private func extractAnimatedMeshesFromLoader(_ loader:UnsafeRawPointer) -> Array<MeshAnimated>
    {
        // Get number of meshes loaded
        let numMeshes: UInt32 = mlGetNumMeshes(loader)
        
        // Instantiate meshes array to fill
        var meshes: Array<MeshAnimated> = Array()
        
        // Loops over meshes
        for i in 0..<numMeshes
        {
            //
            // Load Vertex data
            //
            
            // Get vertex data from mesh
            var vertices:Array<VertexAnimated> = Array()
            let numVertices: Int = Int(mlGetNumVerticesInMesh(loader, i))
            
            // Get temporary vertex array from loader
            let cvertices = Array(UnsafeBufferPointer(start: mlGetMeshVertices(loader, i), count: numVertices))
            
            // Fill vertices array
            for j in stride(from: 0, to: numVertices, by: 8)
            {
                // Extract vertex data from vertices array
                let position: GLKVector3 = GLKVector3Make(cvertices[j], cvertices[j+1], cvertices[j+2])
                let normal: GLKVector3 = GLKVector3Make(cvertices[j+3], cvertices[j+4], cvertices[j+5])
                let texCoord: GLKVector2 = GLKVector2Make(cvertices[j+6], cvertices[j+7])
                
                // Add data to new vertex array
                vertices.append(VertexAnimated(Vertex(position, normal, texCoord)))
            }
            
            //
            // Load Index data
            //
            
            // Get index data from mesh
            let numIndices: Int = Int(mlGetNumIndicesInMesh(loader, i))
            let indices = Array(UnsafeBufferPointer(start: mlGetMeshIndices(loader, i), count: numIndices))
            
            //
            // Load bone data
            //
            var bones: Array<Bone> = Array()

            // Get number of bones
            let numBones: UInt32 = mlGetNumBonesInMesh(loader, i)
            
            // Iterate over all bones
            for j in 0..<numBones
            {
                // Get bone name
                let name: String = String(cString: mlGetMeshBoneName(loader, i, j))
                
                // Get bone offset
                let offset_t = Array(UnsafeBufferPointer(start: mlGetMeshBoneOffsetMatrix(loader, i, j), count: 16))
                
                // Convert bone offset array to glkmatrix
                var offset: GLKMatrix4 = GLKMatrix4Make(offset_t[0], offset_t[1], offset_t[2], offset_t[3], offset_t[4], offset_t[5], offset_t[6], offset_t[7], offset_t[8], offset_t[9], offset_t[10], offset_t[11], offset_t[12], offset_t[13], offset_t[14], offset_t[15])
                
                // Transpose matrix to move from row major to colum major
                offset = GLKMatrix4Transpose(offset)
                
                // Test matrix is correct in column major order
                //print(offset[0], offset[4], offset[8], offset[12])
                //print(offset[1], offset[5], offset[9], offset[13])
                //print(offset[2], offset[6], offset[10], offset[14])
                //print(offset[3], offset[7], offset[11], offset[15])

                
                // Add bone to bone array
                bones.append(Bone(name, offset))
                
                // Now put bone weights in the vertex data
                
                // Get num weights in bone
                let numWeights: Int = Int(mlGetNumMeshBoneWeights(loader, i, j))
                
                // Get all vertex ids and weights
                let ids = Array(UnsafeBufferPointer(start: mlGetMeshBoneVertexIds(loader, i, j), count: numWeights))
                let weights = Array(UnsafeBufferPointer(start: mlGetMeshBoneWeights(loader, i, j), count: numWeights))
                
                // Iterate over all weights
                for k in 0..<numWeights
                {
                    // Get the vertex id from the bone weights
                    let id: Int = Int(ids[k])
                    
                    // Get the weight from the bone weights
                    let weight: Float = weights[k]
                    
                    // A vertex can be influenced by a maximum of 4 bones.
                    // Find an avaliable position to insert the bone weight data
                    var weightInserted:Bool = false
                    for l in 0..<4
                    {
                        // Find a weight which has no influence to place this weight
                        if(vertices[id].boneWeights[l] == 0.0)
                        {
                            // Set the vertex weight to the weight
                            vertices[id].boneWeights[l] = weight
                            
                            // Set the vertex bone ID to j, which is the bone index
                            vertices[id].boneIds[l] = GLint(j)
                            
                            // Inserted bone weight data. Now break.
                            weightInserted = true;
                            break
                        }
                        else
                        {
                            print("Weight already here")
                        }
                    }
                    
                    if(!weightInserted)
                    {
                        print("Problem, vertex relys on more bones than can handle")
                    }
                }
            }
            
            //
            // Create Mesh
            //
            
            let mesh:MeshAnimated = MeshAnimated(vertices, indices, bones)
            
            //
            // Load Material data
            //
            
            // Diffuse texture
            var diffuseTexture: GLKTextureInfo = GLKTextureInfo()
            var diffTexName: String? = nil
            let opt:[String: NSNumber] = [GLKTextureLoaderGenerateMipmaps:false]
            
            let isDiffuseLoaded: Bool = Int(mlGetMeshIsDiffuseMapLoaded(loader, i)) != 0
            
            if(isDiffuseLoaded)
            {
                // Load diffuse texture
                diffTexName = String(cString: mlGetMeshDiffuseMap(loader, i))
                
                // Cut extension off of tex name
                let index = diffTexName?.range(of: ".", options: .backwards)?.lowerBound
                let diffTexName2 = diffTexName?.substring(to: index!)
                let diffTexExt = diffTexName?.substring(from: (diffTexName?.index(after: index!))!)
                
                // Get resource path
                let path = Bundle.main.path(forResource: diffTexName2, ofType: diffTexExt)
                
                do
                {
                    // Load texture
                    diffuseTexture = try GLKTextureLoader.texture(withContentsOfFile: path!, options: opt)
                    
                    // Add texture to the mesh
                    //mesh.setDiffuseTexture(diffuseTexture!)
                }catch
                {
                    
                    print("Could not load diffuse texture for model")
                }
                
            }
            
            // Specular texture
            var specularTexture: GLKTextureInfo = GLKTextureInfo()
            var specTexName: String? = nil
            
            let isSpecularLoaded: Bool = Int(mlGetMeshIsSpecularMapLoaded(loader, i)) != 0
            if(isSpecularLoaded)
            {
                // Load diffuse texture
                specTexName = String(cString: mlGetMeshSpecularMap(loader, i))
                
                // Cut extension off of tex name
                let index = specTexName?.range(of: ".", options: .backwards)?.lowerBound
                let specTexName2 = specTexName?.substring(to: index!)
                let specTexExt = specTexName?.substring(from: (specTexName?.index(after: index!))!)
                
                // Get resource path
                let path = Bundle.main.path(forResource: specTexName2, ofType: specTexExt)
                
                do
                {
                    // Load texture
                    specularTexture = try GLKTextureLoader.texture(withContentsOfFile: path!, options: opt)
                    
                    // Add texture to the mesh
                    //mesh.setSpecularTexture(specularTexture!)
                }catch
                {
                    print("Could not load specular texture for model")
                }
            }
            
            // Diffuse colour
            let diffCol = Array(UnsafeBufferPointer(start: mlGetMeshDiffuseCol(loader, i), count: 4))
            let diffuseColour:GLKVector4 = GLKVector4Make(diffCol[0], diffCol[1], diffCol[2], diffCol[3])
            print("Diffuse Colour R: \(diffCol[0]) G: \(diffCol[1]) B: \(diffCol[2]) A: \(diffCol[3])")
            
            
            // Specular colour
            let specCol = Array(UnsafeBufferPointer(start: mlGetMeshSpecularCol(loader, i), count: 4))
            let specularColour:GLKVector4 = GLKVector4Make(specCol[0], specCol[1], specCol[2], specCol[3])
            print("Specular Colour R: \(specCol[0]) G: \(specCol[1]) B: \(specCol[2]) A: \(specCol[3])")
            
            // Shininess
            let shininess: Float = Float(mlGetMeshShininess(loader, i))
            
            let material: Material = Material(diffuseTexture, specularTexture, diffuseColour, specularColour, shininess)
            mesh.setMaterial(material)
            
            //
            //   Mesh Loading complete
            //
            
            // Add mesh to new mesh array
            meshes.append(mesh)
        }
        
        return meshes
    }
    
    /**
     Extracts a animation array from the assimp loader class.
     
     - parameters:
        - loader: An unsafe pointer to the C++ AssimpModelLoader object.
     
     - returns:
     A Animation array.
     */
    static private func extractAnimationsFromLoader(_ loader:UnsafeRawPointer) -> Array<AnimationSequence>
    {
        // Instantiate animations array to fill
        var animations: Array<AnimationSequence> = Array()
        
        // Get number of animations loaded
        let numAnimations: UInt32 = mlGetNumAnimations(loader)
        
        // Loop over all animations
        for i in 0..<numAnimations
        {
            //
            // Load animation duration
            //
            let duration: Float = mlGetAnimationDuration(loader, i)
            
            //
            // Load animation ticks per second
            //
            let ticksPerSecond: Float = mlGetAnimationTicksPerSecond(loader, i)
            
            // 
            // Load animation channels
            //
            var channels = [String: AnimationChannel]()
            let numChannels: UInt32 = mlGetNumChannelsInAnimation(loader, i)
            
            for j in 0..<numChannels
            {
                // Load channel name
                let name: String = String(cString: mlGetAnimationChannelName(loader, i, j))
                
                // load channel positions
                var positions:Array<GLKVector3> = Array()
                let numPositions: Int = Int(mlGetNumPositionsInChannel(loader, i, j))
                var cPositions = Array(UnsafeBufferPointer(start: mlGetAnimationChannelPositions(loader, i, j), count: numPositions))
                
                for k in stride(from: 0, to: numPositions, by: 3)
                {
                    positions.append(GLKVector3Make(cPositions[k], cPositions[k+1], cPositions[k+2]))
                }
                
                // load channel positions
                var scales:Array<GLKVector3> = Array()
                let numScales: Int = Int(mlGetNumScalesInChannel(loader, i, j))
                var cScales = Array(UnsafeBufferPointer(start: mlGetAnimationChannelScales(loader, i, j), count: numScales))
                
                for k in stride(from: 0, to: numScales, by: 3)
                {
                    scales.append(GLKVector3Make(cScales[k], cScales[k+1], cScales[k+2]))
                }
                
                // load channel rotations
                var rotations:Array<GLKMatrix3> = Array()
                let numRotations: Int = Int(mlGetNumRotationsInChannel(loader, i, j))
                var cRotations = Array(UnsafeBufferPointer(start: mlGetAnimationChannelRotations(loader, i, j), count: numRotations))
                
                for k in stride(from: 0, to: numRotations, by: 9)
                {
                    var rot: GLKMatrix3 = GLKMatrix3Make(cRotations[k], cRotations[k+3], cRotations[k+6],
                                                         cRotations[k+1], cRotations[k+4], cRotations[k+7],
                                                         cRotations[k+2], cRotations[k+5], cRotations[k+8])
                    
                    // Transpose matrix to change from assimps row major to GLKits column major
                    rot = GLKMatrix3Transpose(rot)
                    
                    // Put rotation matrix in array
                    rotations.append(rot)
                }
                
                // Insert channel into channels
                channels[name] = AnimationChannel(positions, scales, rotations)
                //channels.append(AnimationChannel(name, positions, scales, rotations))
            }
            
            // Insert animation into animations
            animations.append(AnimationSequence(Animation(duration, ticksPerSecond, channels)))
        }
        
        return animations
    }
    
    /**
     Extracts a skeleton heirarchy from the assimp loader class.
     
     - parameters:
        - loader: An unsafe pointer to the C++ AssimpModelLoader object.
     
     - returns:
    A Skeleton object.
     */
    static private func extractSkeletonFromLoader(_ loader:UnsafeRawPointer) -> Skeleton
    {
        
        let rootNode: String = String(cString: mlGetNodeRoot(loader))
        var skeleton: Skeleton = Skeleton(rootNode, Array<Skeleton>())
        
        var nodesToProcess: Array<String> = Array()
        nodesToProcess.append(rootNode)
        
        while(!nodesToProcess.isEmpty)
        {
            // Process next node
            
            // Get name of last node
            let name = nodesToProcess[nodesToProcess.count-1]
            
            // Remove node from nodesToProcess
            nodesToProcess.remove(at: nodesToProcess.count-1)
            
            // Get children (if any) of node
            let childrenStr: String = String(cString: mlGetNodeChildren(loader, name))
            
            if !childrenStr.isEmpty
            {
                var childrenStrArr: Array<String> = Array()
                
                // Seperate children and store in array
                childrenStrArr = childrenStr.components(separatedBy: "~")
                
                // Add children to nodestoProcess array
                nodesToProcess.append(contentsOf: childrenStrArr)
                
                // Convert children string array to array of skeletons
                var children:Array<Skeleton> = Array()
                for i in 0..<childrenStrArr.count
                {
                    children.append(Skeleton(childrenStrArr[i]))
                }
                
                // Insert 'children' at node 'name' in skeleton
                if !skeleton.insertChildrenAt(name, children)
                {
                    print("Error: couldn't find child")
                }
            }
        }
        
        return skeleton
    }
}
