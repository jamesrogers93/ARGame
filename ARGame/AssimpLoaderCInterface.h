//
//  AssimpModelLoaderCInterface.h
//  ARGame
//
//  Created by James Rogers on 20/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#ifndef AssimpModelLoaderCInterface_h
#define AssimpModelLoaderCInterface_h

#ifdef __cplusplus
extern "C" {
#endif
    
    //
    //  C - C++ Interface methods
    //
    
    /**  Constructs an instance of AssimpModelLoader and loads a static model.
     *
     *  @param path  A path which points to the model to be loaded.
     *  @return A void pointer to the instance of the AssimpModelLoader.
     */
    const void* mlLoadStaticAssimpModel(const char *path);
    
    /**  Constructs an instance of AssimpModelLoader and loads an animated model.
     *
     *  @param path  A path which points to the model to be loaded.
     *  @return A void pointer to the instance of the AssimpModelLoader.
     */
    const void* mlLoadAnimatedAssimpModel(const char *path);
    
    /**  Constructs an instance of AssimpModelLoader and loads an animation.
     *
     *  @param path File path to the animation to be loaded.
     */
    const void* mlLoadAssimpAnimation(const char *path);
    
    /**  Destructs an instance of AssimpModelLoader.
     *
     *  @param loader  A void pointer to the AssimpModelLoader instance.
     */
    void mlDestroyAssimpLoader(const void* loader);
    
    /**  Returns the number of meshes in an AssimpModelLoader.
      *  
      *  @param loader A void pointer to the AssimpModelLoader instance.
      *  @return Number of meshes in the instance passed, loader.
      */
    const unsigned int mlGetNumMeshes(const void *loader);
    
    /**  Returns the number of animations in an AssimpModelLoader.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @return Number of animations in the instance passed, loader.
     */
    const unsigned int mlGetNumAnimations(const void *loader);
    
    /**  Returns the number of vertices in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of vertices in the mesh.
     */
    const unsigned int mlGetNumVerticesInMesh(const void *loader, const unsigned int index);
    
    /**  Returns the number of indices in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of indices in the mesh.
     */
    const unsigned int mlGetNumIndicesInMesh(const void *loader, const unsigned int index);
    
    /**  Returns the number of bones in a specified mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of bones in the mesh.
     */
    const unsigned int mlGetNumBonesInMesh(const void *loader, const unsigned int index);
    
    /**  Returns the number of channels in a specified animation contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the animation in the animations array.
     *  @return The number of channels in the animation.
     */
    const unsigned int mlGetNumChannelsInAnimation(const void *loader, const unsigned int index);
    
    /**  Returns the number of positions in a channel in a specified animation contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The number of positions in a channel. Note: Since each element is stored seperatly, the number this method returns should be divided by 3 to retrive the number of position vectors.
     */
    const unsigned int mlGetNumPositionsInChannel(const void *loader, const unsigned int index, const unsigned int channelIndex);
    
    /**  Returns the number of scales in a channel in a specified animation contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance 
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The number of scales in the animation. Note: Since each element is stored seperatly, the number this method returns should be divided by 3 to retrive the number of scale vectors.
     */
    const unsigned int mlGetNumScalesInChannel(const void *loader, const unsigned int index, const unsigned int channelIndex);
    
    /**  Returns the number of rotations in a specified animation contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The number of rotations in the animation. Note: Since each element is stored seperatly, the number this method returns should be divided by 9 to retrive the number of rotation matrices.
     */
    const unsigned int mlGetNumRotationsInChannel(const void *loader, const unsigned int index, const unsigned int channelIndex);
    
    /**  Returns an array of vertices in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return An array of vertices in the mesh. Note, the array size will be 8x the size of the number of vertices as all of the data inside a vertex is placed next to each other in the returned array. So elements 0-7 will be one vertex. Specifically, 0-2 are position, 3-5 are normals and 6-7 are texture coordinates.
     */
    const float* mlGetMeshVertices(const void *loader, const unsigned int index);
    
    /**  Returns an array of indices in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return An array of indices in the mesh.
     */
    const unsigned int* mlGetMeshIndices(const void *loader, const unsigned int index);
    
    /**  Returns a char array of a specified bone name in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return A char array of the bone name.
     */
    const char* mlGetMeshBoneName(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex);
    
    /**  Returns the number of vertex ids in specified bone name in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return The number of vertex ids in the bone.
     */
    const unsigned int mlGetNumMeshBoneVertexIds(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex);
    
    /**  Returns the vertex ids of a specified bone in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return An unsigned int array of vertex ids.
     */
    const unsigned int* mlGetMeshBoneVertexIds(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex);
    
    /**  Returns the number of weights in specified bone name in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return The number of weights in the bone.
     */
    const unsigned int mlGetNumMeshBoneWeights(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex);
    
    /**  Returns the weights of a specified bone in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return A float array of the weights.
     */
    const float* mlGetMeshBoneWeights(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex);
    
    /**  Returns the offset matrix4x4 of a specified bone in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return A 16 element float array of the offset matrix.
     */
    const float* mlGetMeshBoneOffsetMatrix(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex);
    
    /**  Returns 0 or 1 indicating if a diffuse has been loaded for a mesh
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return Indication if texture map has been loaded.
     */
    const int mlGetMeshIsDiffuseMapLoaded(const void *loader, const unsigned int index);
    
    /**  Gets the path of a diffuse map in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return The path to a diffuse map.
     */
    const char* mlGetMeshDiffuseMap(const void *loader, const unsigned int index);
    
    /**  Returns 0 or 1 indicating if a specular has been loaded for a mesh
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return Indication if texture map has been loaded.
     */
    const int mlGetMeshIsSpecularMapLoaded(const void *loader, const unsigned int index);
    
    /**  Gets the path of a specular map in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return The path to a specular map.
     */
    const char* mlGetMeshSpecularMap(const void *loader, const unsigned int index);
    
    /**  Gets the vector4 of a diffuse colour in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return The vector4 of a diffuse colour.
     */
    const float* mlGetMeshDiffuseCol(const void *loader, const unsigned int index);
    
    /**  Gets the vector4 of a specular colour in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return The vector4 of a specular colour.
     */
    const float* mlGetMeshSpecularCol(const void *loader, const unsigned int index);
    
    /**  Gets the shininess of a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return The shininess value of the mesh.
     */
    const float mlGetMeshShininess(const void *loader, const unsigned int index);
    
    /**  Gets the duration of an animation contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the animation in the animations array.
     *  @return The duration of the animation.
     */
    const float mlGetAnimationDuration(const void *loader, const unsigned int index);
    
    /**  Gets the ticks per second of an animation contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the animation in the animations array.
     *  @return The ticks per second of the animation.
     */
    const float mlGetAnimationTicksPerSecond(const void *loader, const unsigned int index);
    
    /**  Gets the name of a animation channel in an AssimpLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The name of the animation channel.
     */
    const char* mlGetAnimationChannelName(const void *loader, const unsigned int index, unsigned int channelIndex);
    
    /**  Gets the positions in an animation channel contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The positions of the animation channel. Note: Every three contiguos elements are an xyz position vector.
     */
    const float* mlGetAnimationChannelPositions(const void *loader, const unsigned int index, unsigned int channelIndex);
    
    /**  Gets the scales in an animation channel contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The scales of the animation channel. Note: Every three contiguos elements are an xyz scale vector.
     */
    const float* mlGetAnimationChannelScales(const void *loader, const unsigned int index, unsigned int channelIndex);
    
    /**  Gets the quaternion rotations in an animation channel contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The rotations of the animation channel. Note: Every 9 contiguos elements are a row major 3x3 rotation matrix.
     */
    const float* mlGetAnimationChannelRotations(const void *loader, const unsigned int index, unsigned int channelIndex);
    
    /**  Gets the name of the root skeleton node contained in an AssimpLoaderInstance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @return The char array of the name.
     */
    const char* mlGetNodeRoot(const void *loader);
    
    /**  Gets the children names of the parent node contained in an AssimpLoaderInstance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param name The name of the node we want to retrieve the children from.
     *  @return The char array of the children names. Eahc child name will be seperated with a tilda. 0 will be returned if the node has no children.
     */
    const char* mlGetNodeChildren(const void *loader, const char *name);
    
    
#ifdef __cplusplus
}
#endif

#endif /* AssimpModelLoaderCInterface_h */
