//
//  AssimpModelLoader.cpp
//  ARGame
//
//  Created by James Rogers on 19/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#include "AssimpModelLoader.hpp"

void AssimpModelLoader::loadStaticAssimpModel(std::string path)
{
    // Read file via ASSIMP
    Assimp::Importer importer = Assimp::Importer();
    const aiScene* scene = importer.ReadFile(path, aiProcess_Triangulate | aiProcess_FlipUVs);
    
    // Check for errors
    if(!scene || scene->mFlags == AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode) // if is Not Zero
    {
        std::cout << "ERROR::ASSIMP:: " << importer.GetErrorString() << std::endl;
        return;
    }
    
    // Retrieve the directory path of the filepath
    this->directory = path.substr(0, path.find_last_of('/'));
    
    // Process ASSIMP's root node recursively
    this->processNode(scene->mRootNode, scene, false);
}

void AssimpModelLoader::loadAnimatedAssimpModel(std::string path)
{
    // Read file via ASSIMP
    Assimp::Importer importer = Assimp::Importer();
    const aiScene* scene = importer.ReadFile(path, aiProcess_Triangulate | aiProcess_FlipUVs);
    
    // Check for errors
    if(!scene || scene->mFlags == AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode) // if is Not Zero
    {
        std::cout << "ERROR::ASSIMP:: " << importer.GetErrorString() << std::endl;
        return;
    }
    
    // Retrieve the directory path of the filepath
    this->directory = path.substr(0, path.find_last_of('/'));
    
    // Process ASSIMP's root node recursively
    this->processNode(scene->mRootNode, scene, true);
    
    // Process ASSIMP's animations
    for(int i = 0; i < scene->mNumAnimations; i++)
    {
        this->processAnimation(scene->mAnimations[i], scene);
    }
}

void AssimpModelLoader::processNode(aiNode *node, const aiScene *scene, const bool &loadBones)
{
    // Process each mesh located at the current node
    for(size_t i = 0; i < node->mNumMeshes; i++)
    {
        // The node object only contains indices to index the actual objects in the scene.
        // The scene contains all the data, node is just to keep stuff organized (like relations between nodes).
        aiMesh* mesh = scene->mMeshes[node->mMeshes[i]];
        this->meshes.push_back(this->processMesh(mesh, scene, loadBones));
    }
    
    // After we've processed all of the meshes (if any) we then recursively process each of the children nodes
    for(size_t i = 0; i < node->mNumChildren; i++)
    {
        this->processNode(node->mChildren[i], scene, loadBones);
    }
}

CMesh AssimpModelLoader::processMesh(aiMesh *mesh, const aiScene *scene, const bool &loadBones)
{
    // Load vertices
    std::vector<float> vertices;
    for(size_t i = 0; i < mesh->mNumVertices; i++)
    {
        // Positions
        vertices.push_back(mesh->mVertices[i].x);
        vertices.push_back(mesh->mVertices[i].y);
        vertices.push_back(mesh->mVertices[i].z);
        
        // Normals
        vertices.push_back(mesh->mNormals[i].x);
        vertices.push_back(mesh->mNormals[i].y);
        vertices.push_back(mesh->mNormals[i].z);
        
        // Texture Coordinates
        float u,v;
        if(mesh->mTextureCoords[0]) // Does the mesh contain texture coordinates?
        {
            // A vertex can contain up to 8 different texture coordinates. We thus make the assumption that we won't
            // use models where a vertex can have multiple texture coordinates so we always take the first set (0).
            u = mesh->mTextureCoords[0][i].x;
            v = mesh->mTextureCoords[0][i].y;
        }
        else
        {
            u = v = 0.0f;
        }
        vertices.push_back(u);
        vertices.push_back(v);
    }
    
    // Load indices
    std::vector<unsigned int> indices;
    for(size_t i = 0; i < mesh->mNumFaces; i++)
    {
        aiFace face = mesh->mFaces[i];
        // Retrieve all indices of the face and store them in the indices vector
        for(size_t j = 0; j < face.mNumIndices; j++)
            indices.push_back(face.mIndices[j]);
    }
    
    // Load material
    CMaterial material;
    if(mesh->mMaterialIndex >= 0)
    {
        aiMaterial *assimp_material = scene->mMaterials[mesh->mMaterialIndex];
        
        // Diffuse Colour
        aiColor4D diffuseColTemp;
        assimp_material->Get(AI_MATKEY_COLOR_DIFFUSE, diffuseColTemp);
        float diffuseCol[4] = {diffuseColTemp[0], diffuseColTemp[1], diffuseColTemp[2], diffuseColTemp[3]};
        
        // Specular Colour
        aiColor4D specularColTemp;
        assimp_material->Get(AI_MATKEY_COLOR_SPECULAR, specularColTemp);
        float specularCol[4] = {specularColTemp[0], specularColTemp[1], specularColTemp[2], specularColTemp[3]};

        // Diffuse texture
        std::string diffuseTex = this->loadMaterialTexture(assimp_material, aiTextureType_DIFFUSE);
        
        // Specular texture
        std::string specularTex = this->loadMaterialTexture(assimp_material, aiTextureType_SPECULAR);
        
        // Shinnines
        float shininess;
        assimp_material->Get(AI_MATKEY_SHININESS, shininess);
        
        // Initalise material with assimp material data
        material = CMaterial(diffuseTex, specularTex, diffuseCol, specularCol, shininess);
        
        // Return mesh with texture maps if they exist
        //if(!diffuseMap.empty() && !specularMap.empty())
        //    return CMesh(vertices, indices, diffuseMap, specularMap);
    }
    else
    {
        material = CMaterial();
    }
    
    // Load bones
    std::vector<CBone> bones;
    if(loadBones)
    {
        if(mesh->HasBones())
        {
            for(size_t i = 0; i < mesh->mNumBones; i++)
            {
                // Get bone name
                std::string name = mesh->mBones[i]->mName.data;
            
                // Get bone offset matrix
                float offsetMatrix[16];
                offsetMatrix[0]  = mesh->mBones[i]->mOffsetMatrix.a1; offsetMatrix[1]  = mesh->mBones[i]->mOffsetMatrix.a2;
                offsetMatrix[2]  = mesh->mBones[i]->mOffsetMatrix.a3; offsetMatrix[3]  = mesh->mBones[i]->mOffsetMatrix.a4;
            
                offsetMatrix[4]  = mesh->mBones[i]->mOffsetMatrix.b1; offsetMatrix[5]  = mesh->mBones[i]->mOffsetMatrix.b2;
                offsetMatrix[6]  = mesh->mBones[i]->mOffsetMatrix.b3; offsetMatrix[7]  = mesh->mBones[i]->mOffsetMatrix.b4;
            
                offsetMatrix[8]  = mesh->mBones[i]->mOffsetMatrix.c1;  offsetMatrix[9] = mesh->mBones[i]->mOffsetMatrix.c2;
                offsetMatrix[10] = mesh->mBones[i]->mOffsetMatrix.c3; offsetMatrix[11] = mesh->mBones[i]->mOffsetMatrix.c4;
            
                offsetMatrix[12] = mesh->mBones[i]->mOffsetMatrix.d1; offsetMatrix[13] = mesh->mBones[i]->mOffsetMatrix.d2;
                offsetMatrix[14] = mesh->mBones[i]->mOffsetMatrix.d3; offsetMatrix[15] = mesh->mBones[i]->mOffsetMatrix.d4;
            
            
                // Get vertex ids and weights associated with bone
                std::vector<unsigned int> vertexIds;
                std::vector<float> weights;
                for(size_t j = 0; j < mesh->mBones[i]->mNumWeights; j++)
                {
                    vertexIds.push_back(mesh->mBones[i]->mWeights[j].mVertexId);
                    weights.push_back(mesh->mBones[i]->mWeights[j].mWeight);
                }
            
                bones.push_back(CBone(name, vertexIds, weights, offsetMatrix));
            }
        }
    }
    
    // Return a mesh object created from the extracted mesh data
    return CMesh(vertices, indices, material, bones);
}

// Checks all material textures of a given type and loads the textures if they're not loaded yet.
// The required info is returned as a Texture struct.
std::string AssimpModelLoader::loadMaterialTexture(aiMaterial* mat, aiTextureType type)
{
    
    // Check if texture type exists
    if(mat->GetTextureCount(type) > 0)
    {
        // Get texture path
        aiString str;
        mat->GetTexture(type, 0, &str);
        
        // Return path to texture
        return str.C_Str();
    }
    
    // Return empty string
    return std::string();
}

void AssimpModelLoader::processAnimation(aiAnimation* animation, const aiScene* scene)
{
    // Load animation duration
    double duration = animation->mDuration;
    
    // Load animation ticks per seocnd
    double ticksPerSecond = animation->mTicksPerSecond;
    
    // Load channels from animation
    std::vector<CAnimationChannel> channels;
    for(int i = 0; i < animation->mNumChannels; i++)
    {
        // Get channel name
        std::string name = animation->mChannels[i]->mNodeName.data;
        
        // Get channel positions
        std::vector<float> positions;
        for(int j = 0; j < animation->mChannels[i]->mNumPositionKeys; j++)
        {
            aiVector3D v = animation->mChannels[i]->mPositionKeys[j].mValue;
            positions.push_back(v[0]);
            positions.push_back(v[1]);
            positions.push_back(v[2]);
        }
        
        // Get channel scales
        std::vector<float> scales;
        for(int j = 0; j < animation->mChannels[i]->mNumScalingKeys; j++)
        {
            aiVector3D v = animation->mChannels[i]->mScalingKeys[j].mValue;
            scales.push_back(v[0]);
            scales.push_back(v[1]);
            scales.push_back(v[2]);
        }
        
        // Get channel rotations
        std::vector<float> rotations;
        for(int j = 0; j < animation->mChannels[i]->mNumRotationKeys; j++)
        {
            aiMatrix3x3 v = animation->mChannels[i]->mRotationKeys[j].mValue.GetMatrix();
            rotations.push_back(v.a1); rotations.push_back(v.a2); rotations.push_back(v.a3);
            rotations.push_back(v.b1); rotations.push_back(v.b2); rotations.push_back(v.b3);
            rotations.push_back(v.c1); rotations.push_back(v.c2); rotations.push_back(v.c3);
        }
        
        // Insert channel into vector
        channels.push_back(CAnimationChannel(name, positions, scales, rotations));
    }
    
    // Insert animation into vector
    this->animations.push_back(CAnimation(duration, ticksPerSecond, channels));
}

const unsigned int AssimpModelLoader::getNumMeshes()
{
    return (unsigned int)this->meshes.size();
}

const unsigned int AssimpModelLoader::getNumAnimations()
{
    return (unsigned int)this->animations.size();
}

const unsigned int AssimpModelLoader::getNumVerticesInMesh(const unsigned int &index)
{
    if(index >= getNumMeshes())
        return 0;
    
    return (unsigned int)meshes[index].vertices.size();
}

const unsigned int AssimpModelLoader::getNumIndicesInMesh(const unsigned int &index)
{
    if(index >= getNumMeshes())
        return 0;
    
    return (unsigned int)meshes[index].indices.size();
}

const unsigned int AssimpModelLoader::getNumBonesInMesh(const unsigned int &index)
{
    if(index >= getNumMeshes())
        return 0;
    
    return (unsigned int)meshes[index].bones.size();
}

const unsigned int AssimpModelLoader::getNumChannelsInAnimation(const unsigned int &index)
{
    if(index >= getNumAnimations())
        return 0;
    
    return (unsigned int)animations[index].channels.size();
}

const unsigned int AssimpModelLoader::getNumPositionsInChannel(const unsigned int &index, const unsigned int &channelIndex)
{
    if(index >= getNumAnimations())
        return 0;
    
    if(channelIndex >= getNumChannelsInAnimation(index))
        return 0;
    
    return (unsigned int)animations[index].channels[channelIndex].positions.size();
}

const unsigned int AssimpModelLoader::getNumScalesInChannel(const unsigned int &index, const unsigned int &channelIndex)
{
    if(index >= getNumAnimations())
        return 0;
    
    if(channelIndex >= getNumChannelsInAnimation(index))
        return 0;
    
    return (unsigned int)animations[index].channels[channelIndex].scales.size();
}

const unsigned int AssimpModelLoader::getNumRotationsInChannel(const unsigned int &index, const unsigned int &channelIndex)
{
    if(index >= getNumAnimations())
        return 0;
    
    if(channelIndex >= getNumChannelsInAnimation(index))
        return 0;
    
    return (unsigned int)animations[index].channels[channelIndex].rotations.size();
}

const float* AssimpModelLoader::getMeshVertices(const unsigned int &index)
{
    if(index >= getNumMeshes())
        return 0;
    
    return meshes[index].vertices.data();
}

const unsigned int* AssimpModelLoader::getMeshIndices(const unsigned int &index)
{
    if(index >= getNumMeshes())
        return 0;
    return meshes[index].indices.data();
}

const char* AssimpModelLoader::getMeshBoneName(const unsigned int &meshIndex, const unsigned int &boneIndex)
{
    if(meshIndex >= getNumMeshes())
        return 0;
    
    if(boneIndex >= getNumBonesInMesh(meshIndex))
        return 0;
    
    return meshes[meshIndex].bones[boneIndex].name.c_str();
}

const unsigned int AssimpModelLoader::getNumMeshBoneVertexIds(const unsigned int &meshIndex, const unsigned int &boneIndex)
{
    if(meshIndex >= getNumMeshes())
        return 0;
    
    if(boneIndex >= getNumBonesInMesh(meshIndex))
        return 0;
    
    return (unsigned int)meshes[meshIndex].bones[boneIndex].vertexIds.size();
}

const unsigned int* AssimpModelLoader::getMeshBoneVertexIds(const unsigned int &meshIndex, const unsigned int &boneIndex)
{
    if(meshIndex >= getNumMeshes())
        return 0;
    
    if(boneIndex >= getNumBonesInMesh(meshIndex))
        return 0;
    
    return meshes[meshIndex].bones[boneIndex].vertexIds.data();
}

const unsigned int AssimpModelLoader::getNumMeshBoneWeights(const unsigned int &meshIndex, const unsigned int &boneIndex)
{
    if(meshIndex >= getNumMeshes())
        return 0;
    
    if(boneIndex >= getNumBonesInMesh(meshIndex))
        return 0;
    
    return (unsigned int)meshes[meshIndex].bones[boneIndex].weights.size();
}

const float* AssimpModelLoader::getMeshBoneWeights(const unsigned int &meshIndex, const unsigned int &boneIndex)
{
    if(meshIndex >= getNumMeshes())
        return 0;
    
    if(boneIndex >= getNumBonesInMesh(meshIndex))
        return 0;
    
    return meshes[meshIndex].bones[boneIndex].weights.data();
}

const float* AssimpModelLoader::getMeshBoneOffsetMatrix(const unsigned int &meshIndex, const unsigned int &boneIndex)
{
    if(meshIndex >= getNumMeshes())
        return 0;
    
    if(boneIndex >= getNumBonesInMesh(meshIndex))
        return 0;
    
    return meshes[meshIndex].bones[boneIndex].offsetMatrix;
}

const bool AssimpModelLoader::getMeshIsDiffuseMapLoaded(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return false;
    return !meshes[index].material.diffuseTex.empty();
}

const char* AssimpModelLoader::getMeshDiffuseMap(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return 0;
    return meshes[index].material.diffuseTex.c_str();
}

const bool AssimpModelLoader::getMeshIsSpecularMapLoaded(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return false;
    return !meshes[index].material.specularTex.empty();
}

const char* AssimpModelLoader::getMeshSpecularMap(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return 0;
    return meshes[index].material.specularTex.c_str();
}

const float* AssimpModelLoader::getMeshDiffuseCol(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return 0;
    return meshes[index].material.diffuseCol;
}

const float* AssimpModelLoader::getMeshSpecularCol(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return 0;
    
    return meshes[index].material.specularCol;
}

const float AssimpModelLoader::getMeshShininess(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return 0;
    
    return meshes[index].material.shininess;
}

const double AssimpModelLoader::getAnimationDuration(const unsigned int &index)
{
    if(index >= getNumAnimations())
        return 0;
    
    return animations[index].duration;
}

const double AssimpModelLoader::getAnimationTicksPerSecond(const unsigned int &index)
{
    if(index >= getNumAnimations())
        return 0;
    
    return animations[index].ticksPerSecond;
}

const char* AssimpModelLoader::getAnimationChannelName(const unsigned int &index, unsigned int &channelIndex)
{
    if(index >= getNumAnimations())
        return 0;
    
    if(channelIndex >= getNumChannelsInAnimation(index))
        return 0;
    
    return animations[index].channels[channelIndex].name.c_str();
}

const float* AssimpModelLoader::getAnimationChannelPositions(const unsigned int &index, unsigned int &channelIndex)
{
    if(index >= getNumAnimations())
        return 0;
    
    if(channelIndex >= getNumChannelsInAnimation(index))
        return 0;
    
    return animations[index].channels[channelIndex].positions.data();
}

const float* AssimpModelLoader::getAnimationChannelScales(const unsigned int &index, unsigned int &channelIndex)
{
    if(index >= getNumAnimations())
        return 0;
    
    if(channelIndex >= getNumChannelsInAnimation(index))
        return 0;
    
    return animations[index].channels[channelIndex].scales.data();
}

const float* AssimpModelLoader::getAnimationChannelRotations(const unsigned int &index, unsigned int &channelIndex)
{
    if(index >= getNumAnimations())
        return 0;
    
    if(channelIndex >= getNumChannelsInAnimation(index))
        return 0;
    
    return animations[index].channels[channelIndex].rotations.data();
}






