//
//  AssimpLoaderCInterface.c
//  ARGame
//
//  Created by James Rogers on 27/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#include "AssimpLoaderCInterface.h"
#include "AssimpLoader.hpp"

const void* mlLoadStaticAssimpModel(const char *path)
{
    // Create instance of AssimpLoader
    AssimpLoader *loader = new AssimpLoader();
    
    // Load the model
    loader->loadStaticAssimpModel(path);
    
    // Return a void pointer to loader
    return (void *)loader;
}

const void* mlLoadAnimatedAssimpModel(const char *path)
{
    // Create instance of AssimpLoader
    AssimpLoader *loader = new AssimpLoader();
    
    // Load the model
    loader->loadAnimatedAssimpModel(path);
    
    // Return a void pointer to loader
    return (void *)loader;
}

const void* mlLoadAssimpAnimation(const char *path)
{
    // Create instance of AssimpLoader
    AssimpLoader *loader = new AssimpLoader();
    
    // Load the model
    loader->loadAssimpAnimation(path);
    
    // Return a void pointer to loader
    return (void *)loader;
}

void mlDestroyAssimpLoader(const void *loader)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    if(ptrLoader)
        delete ptrLoader;
}

const unsigned int mlGetNumMeshes(const void *loader)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the number of meshes in the AssimpLoader
    return ptrLoader->getNumMeshes();
}

const unsigned int mlGetNumAnimations(const void *loader)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the number of animations in the AssimpLoader
    return ptrLoader->getNumAnimations();
}

const unsigned int mlGetNumVerticesInMesh(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the float array retrieved from AssimpLoader
    return ptrLoader->getNumVerticesInMesh(index);
}

const unsigned int mlGetNumIndicesInMesh(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNumIndicesInMesh(index);
}

const unsigned int mlGetNumBonesInMesh(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNumBonesInMesh(index);
}

const unsigned int mlGetNumChannelsInAnimation(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNumChannelsInAnimation(index);
}

const unsigned int mlGetNumPositionsInChannel(const void *loader, const unsigned int index, const unsigned int channelIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNumPositionsInChannel(index, channelIndex);
}

const unsigned int mlGetNumScalesInChannel(const void *loader, const unsigned int index, const unsigned int channelIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNumScalesInChannel(index, channelIndex);
}

const unsigned int mlGetNumRotationsInChannel(const void *loader, const unsigned int index, const unsigned int channelIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNumRotationsInChannel(index, channelIndex);
}

const float* mlGetMeshVertices(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the float array retrieved from AssimpLoader
    return ptrLoader->getMeshVertices(index);
}

const unsigned int* mlGetMeshIndices(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the unsigned int array retrieved from AssimpLoader
    return ptrLoader->getMeshIndices(index);
}

const char* mlGetMeshBoneName(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the char array retrieved from AssimpLoader
    return ptrLoader->getMeshBoneName(meshIndex, boneIndex);
}

const unsigned int mlGetNumMeshBoneVertexIds(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNumMeshBoneVertexIds(meshIndex, boneIndex);
}

const unsigned int* mlGetMeshBoneVertexIds(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getMeshBoneVertexIds(meshIndex, boneIndex);
}

const unsigned int mlGetNumMeshBoneWeights(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNumMeshBoneWeights(meshIndex, boneIndex);
}

const float* mlGetMeshBoneWeights(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getMeshBoneWeights(meshIndex, boneIndex);
}

const float* mlGetMeshBoneOffsetMatrix(const void *loader, const unsigned int meshIndex, const unsigned int boneIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getMeshBoneOffsetMatrix(meshIndex, boneIndex);
}

const int mlGetMeshIsDiffuseMapLoaded(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the bool retrieved from AssimpLoader
    return ptrLoader->getMeshIsDiffuseMapLoaded(index);
}

const char* mlGetMeshDiffuseMap(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the char array retrieved from AssimpLoader
    return ptrLoader->getMeshDiffuseMap(index);
}

const int mlGetMeshIsSpecularMapLoaded(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the bool retrieved from AssimpLoader
    return ptrLoader->getMeshIsSpecularMapLoaded(index);
}

const char* mlGetMeshSpecularMap(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the char array retrieved from AssimpLoader
    return ptrLoader->getMeshSpecularMap(index);
}

const float* mlGetMeshDiffuseCol(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the char array retrieved from AssimpLoader
    return ptrLoader->getMeshDiffuseCol(index);
}

const float* mlGetMeshSpecularCol(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the char array retrieved from AssimpLoader
    return ptrLoader->getMeshSpecularCol(index);
}

const float mlGetMeshShininess(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the char array retrieved from AssimpLoader
    return ptrLoader->getMeshShininess(index);
}

const float mlGetAnimationDuration(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getAnimationDuration(index);
}

const float mlGetAnimationTicksPerSecond(const void *loader, const unsigned int index)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getAnimationTicksPerSecond(index);
}

const char* mlGetAnimationChannelName(const void *loader, const unsigned int index, unsigned int channelIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getAnimationChannelName(index, channelIndex);
}

const float* mlGetAnimationChannelPositions(const void *loader, const unsigned int index, unsigned int channelIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getAnimationChannelPositions(index, channelIndex);
}

const float* mlGetAnimationChannelScales(const void *loader, const unsigned int index, unsigned int channelIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getAnimationChannelScales(index, channelIndex);
}

const float* mlGetAnimationChannelRotations(const void *loader, const unsigned int index, unsigned int channelIndex)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getAnimationChannelRotations(index, channelIndex);
}

const char* mlGetNodeRoot(const void *loader)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNodeRoot();
}

const char* mlGetNodeChildren(const void *loader, const char *name)
{
    // Cast void pointer, loader to AssimpLoader type
    AssimpLoader *ptrLoader = (AssimpLoader *)loader;
    
    // Return the value retrieved from AssimpLoader
    return ptrLoader->getNodeChildren(name);
}




