//
//  AssimpModelLoaderBridge2.h
//  ARGame
//
//  Created by James Rogers on 20/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#ifndef AssimpModelLoaderBridgeC_h
#define AssimpModelLoaderBridgeC_h

#ifdef __cplusplus
extern "C" {
#endif
    
    // Constructor and destructor for AssimpModelLoader
    const void* initAssimpModelLoader(const char *path);
    void deinitAssimpModelLoader(const void* loader);
    
    const unsigned int getNumMeshes(const void *loader);
    const unsigned int getNumVerticesInMesh(const void *loader, const unsigned int index);
    const unsigned int getNumIndicesInMesh(const void *loader, const unsigned int index);
    const float* getMeshVertices(const void *loader, const unsigned int index);
    const unsigned int* getMeshIndices(const void *loader, const unsigned int index);
    const int getMeshIsTexturesLoaded(const void *loader, const unsigned int index);
    const char* getMeshDiffuseMap(const void *loader, const unsigned int index);
    const char* getMeshSpecularMap(const void *loader, const unsigned int index);
    
    
#ifdef __cplusplus
}
#endif

#endif /* AssimpModelLoaderBridge2_h */
