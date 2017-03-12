//
//  AssimpModelLoader.cpp
//  ARGame
//
//  Created by James Rogers on 19/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#include "AssimpModelLoader.hpp"

void AssimpModelLoader::loadAssimpModel(std::string path)
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
    this->processNode(scene->mRootNode, scene);
}

void AssimpModelLoader::processNode(aiNode *node, const aiScene *scene)
{
    // Process each mesh located at the current node
    for(size_t i = 0; i < node->mNumMeshes; i++)
    {
        // The node object only contains indices to index the actual objects in the scene.
        // The scene contains all the data, node is just to keep stuff organized (like relations between nodes).
        aiMesh* mesh = scene->mMeshes[node->mMeshes[i]];
        this->meshes.push_back(this->processMesh(mesh, scene));
    }
    
    // After we've processed all of the meshes (if any) we then recursively process each of the children nodes
    for(size_t i = 0; i < node->mNumChildren; i++)
    {
        this->processNode(node->mChildren[i], scene);
    }
}

CMesh AssimpModelLoader::processMesh(aiMesh *mesh, const aiScene *scene)
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
    
    // Load materials
    if(mesh->mMaterialIndex > 0)
    {
        aiMaterial* material = scene->mMaterials[mesh->mMaterialIndex];

        // Diffuse map
        std::string diffuseMap = this->loadMaterialTexture(material, aiTextureType_DIFFUSE);
        
        // Specular map
        std::string specularMap = this->loadMaterialTexture(material, aiTextureType_SPECULAR);
        
        // Return mesh with texture maps if they exist
        if(!diffuseMap.empty() && !specularMap.empty())
            return CMesh(vertices, indices, diffuseMap, specularMap);
    }
    
    // Load bones
    std::vector<CBone> bones;
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
            
            
            // Get weights associated with bone
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
    
    // Return a mesh object created from the extracted mesh data
    return CMesh(vertices, indices, bones);
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


const unsigned int AssimpModelLoader::getNumMeshes()
{
    return (unsigned int)this->meshes.size();
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
    return !meshes[index].diffuseMap.empty();
}

const char* AssimpModelLoader::getMeshDiffuseMap(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return 0;
    return meshes[index].diffuseMap.c_str();
}

const bool AssimpModelLoader::getMeshIsSpecularMapLoaded(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return false;
    return !meshes[index].specularMap.empty();
}

const char* AssimpModelLoader::getMeshSpecularMap(const unsigned int &index)
{
    if (index >= getNumMeshes())
        return 0;
    return meshes[index].specularMap.c_str();
}
