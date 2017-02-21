//
//  AssimpModelLoader.hpp
//  ARGame
//
//  Created by James Rogers on 19/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#ifndef AssimpModelLoader_hpp
#define AssimpModelLoader_hpp

// STL
#include <string>
#include <iostream>
#include <vector>

// Assimp
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>

struct CMesh
{
    std::vector<float> vertices;
    std::vector<unsigned int> indices;
    
    std::string diffuseMap, specularMap;
    bool isTextureLoaded = false;
    
    CMesh(std::vector<float> vertices, std::vector<unsigned int> indices)
    {
        this->vertices = vertices;
        this->indices = indices;
    }
    
    CMesh(std::vector<float> vertices, std::vector<unsigned int> indices, std::string diffuseMap, std::string specularMap) : CMesh(vertices, indices)
    {
        this->diffuseMap = diffuseMap;
        this->specularMap = specularMap;
        this->isTextureLoaded = true;
    }
};

class AssimpModelLoader
{
public:
    
    AssimpModelLoader(){}
    
    std::vector<CMesh> loadAssimpModel(std::string path);
    
    const unsigned int getNumMeshes();
    const unsigned int getNumVerticesInMesh(const unsigned int &index);
    const unsigned int getNumIndicesInMesh(const unsigned int &index);
    const float* getMeshVertices(const unsigned int &index);
    const unsigned int* getMeshIndices(const unsigned int &index);
    const bool getMeshIsTexturesLoaded(const unsigned int &index);
    const char* getMeshDiffuseMap(const unsigned int &index);
    const char* getMeshSpecularMap(const unsigned int &index);
    
private:
    
    std::vector<CMesh> meshes;
    std::string directory;
    
    void processNode(aiNode* node, const aiScene* scene);
    
    CMesh processMesh(aiMesh* mesh, const aiScene* scene);
    
    std::string loadMaterialTextures(aiMaterial* mat, aiTextureType type);
};

#endif /* AssimpModelLoader_hpp */






