//
//  AssimpModelLoaderBridge2.h
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
    
    /**  Constructs an instance of AssimpModelLoader and loads a model.
     *
     *  @param path  A path which points to the model to be loaded.
     *  @return A void pointer to the instance of the AssimpModelLoader.
     */
    const void* initAssimpModelLoader(const char *path);
    
    /**  Destructs an instance of AssimpModelLoader.
     *
     *  @param loader  A void pointer to the AssimpModelLoader instance.
     */
    void deinitAssimpModelLoader(const void* loader);
    
    /**  Returns the number of meshes in an AssimpModelLoader.
      *  
      *  @param loader A void pointer to the AssimpModelLoader instance.
      *  @return Number of meshes in the instance passed, loader.
      */
    const unsigned int getNumMeshes(const void *loader);
    
    /**  Returns the number of vertices in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of vertices in the mesh.
     */
    const unsigned int getNumVerticesInMesh(const void *loader, const unsigned int index);
    
    /**  Returns the number of indices in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of indices in the mesh.
     */
    const unsigned int getNumIndicesInMesh(const void *loader, const unsigned int index);
    
    /**  Returns an array of vertices in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return An array of vertices in the mesh. Note, the array size will be 8x the size of the number of vertices as all of the data inside a vertex is placed next to each other in the returned array. So elements 0-7 will be one vertex. Specifically, 0-2 are position, 3-5 are normals and 6-7 are texture coordinates.
     */
    const float* getMeshVertices(const void *loader, const unsigned int index);
    
    /**  Returns an array of indices in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return An array of indices in the mesh.
     */
    const unsigned int* getMeshIndices(const void *loader, const unsigned int index);
    
    /**  Returns 0 or 1 indicating if textures have been loaded for a mesh
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return Indication if texture maps have been loaded.
     */
    const int getMeshIsTexturesLoaded(const void *loader, const unsigned int index);
    
    /**  Gets the path of a diffuse map in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return The path to a diffuse map.
     */
    const char* getMeshDiffuseMap(const void *loader, const unsigned int index);
    
    /**  Gets the path of a specular map in a mesh contained in an AssimpModelLoader instance.
     *
     *  @param loader A void pointer to the AssimpModelLoader instance.
     *  @param index Index of the mesh in the meshes array.
     *  @return The path to a specular map.
     */
    const char* getMeshSpecularMap(const void *loader, const unsigned int index);
    
    
#ifdef __cplusplus
}
#endif

#endif /* AssimpModelLoaderBridge2_h */



// ARHandler Bridge

//#ifndef ARHandler_h
//#define ARHandler_h

//#import <Foundation/Foundation.h>
//#import <QuartzCore/QuartzCore.h>
//#import <AR/ar.h>
//#import <AR/video.h>
//#import <AR/gsub_es.h>
//#import <AR/sys/CameraVideo.h>
/* ARMarkerTracker_h */
