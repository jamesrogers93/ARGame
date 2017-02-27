//
//  AssimpModelLoaderCInterface.c
//  ARGame
//
//  Created by James Rogers on 27/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#include "AssimpModelLoaderCInterface.h"
#include "AssimpModelLoader.hpp"

const void* initAssimpModelLoader(const char *path)
{
    // Create instance of AssimpModelLoader
    AssimpModelLoader *loader = new AssimpModelLoader();
    
    // Load the model
    loader->loadAssimpModel(path);
    
    // Return a void pointer to loader
    return (void *)loader;
}

void deinitAssimpModelLoader(const void *loader)
{
    // Cast void pointer, loader to AssimpModelLoader type
    AssimpModelLoader *ptrLoader = (AssimpModelLoader *)loader;
    
    if(ptrLoader)
        delete ptrLoader;
}

const unsigned int getNumMeshes(const void *loader)
{
    // Cast void pointer, loader to AssimpModelLoader type
    AssimpModelLoader *ptrLoader = (AssimpModelLoader *)loader;
    
    // Return the float array retrieved from AssimpModelLoader
    return ptrLoader->getNumMeshes();
}

const unsigned int getNumVerticesInMesh(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpModelLoader type
    AssimpModelLoader *ptrLoader = (AssimpModelLoader *)loader;
    
    // Return the float array retrieved from AssimpModelLoader
    return ptrLoader->getNumVerticesInMesh(index);
}


const unsigned int getNumIndicesInMesh(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpModelLoader type
    AssimpModelLoader *ptrLoader = (AssimpModelLoader *)loader;
    
    // Return the float array retrieved from AssimpModelLoader
    return ptrLoader->getNumIndicesInMesh(index);
}

const float* getMeshVertices(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpModelLoader type
    AssimpModelLoader *ptrLoader = (AssimpModelLoader *)loader;
    
    // Return the float array retrieved from AssimpModelLoader
    return ptrLoader->getMeshVertices(index);
}

const unsigned int* getMeshIndices(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpModelLoader type
    AssimpModelLoader *ptrLoader = (AssimpModelLoader *)loader;
    
    // Return the unsigned int array retrieved from AssimpModelLoader
    return ptrLoader->getMeshIndices(index);
}

const int getMeshIsTexturesLoaded(const void *loader, const unsigned int &index)
{
    // Cast void pointer, loader to AssimpModelLoader type
    AssimpModelLoader *ptrLoader = (AssimpModelLoader *)loader;
    
    // Return the bool retrieved from AssimpModelLoader
    return ptrLoader->getMeshIsTexturesLoaded(index);
}

const char* getMeshDiffuseMap(const void *loader, const unsigned int &index)
{
    // Cast void pointer, loader to AssimpModelLoader type
    AssimpModelLoader *ptrLoader = (AssimpModelLoader *)loader;
    
    // Return the char array retrieved from AssimpModelLoader
    return ptrLoader->getMeshDiffuseMap(index);
}

const char* getMeshSpecularMap(const void *loader, const unsigned int &index)
{
    // Cast void pointer, loader to AssimpModelLoader type
    AssimpModelLoader *ptrLoader = (AssimpModelLoader *)loader;
    
    // Return the char array retrieved from AssimpModelLoader
    return ptrLoader->getMeshSpecularMap(index);
}
