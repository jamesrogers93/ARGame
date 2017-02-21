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
    
    /**  Loads a model using the Assimp library.
     *
     *  @param path File path to the model to be loaded.
     *  @return A vector of meshes loaded.
     */
    std::vector<CMesh> loadAssimpModel(std::string path);
    
    /**  Returns the number of meshes.
     *
     *  @return Number of meshes.
     */
    const unsigned int getNumMeshes();
    
    /**  Returns the number of vertices in a specified mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of vertices in the mesh.
     */
    const unsigned int getNumVerticesInMesh(const unsigned int &index);
    
    /**  Returns the number of indices in a specified mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of indices in the mesh.
     */
    const unsigned int getNumIndicesInMesh(const unsigned int &index);
    
    /**  Returns an array of vertices in a specificed mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return An array of vertices in the mesh. Note, the array size will be 8x the size of the number of vertices as all of the data inside a vertex is placed next to each other in the returned array. So elements 0-7 will be one vertex. Specifically, 0-2 are position, 3-5 are normals and 6-7 are texture coordinates.
     */
    const float* getMeshVertices(const unsigned int &index);
    
    /**  Returns an array of indices in a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return An array of indices in the mesh.
     */
    const unsigned int* getMeshIndices(const unsigned int &index);
    
    /**  Returns a bool indicating if textures have been loaded for a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return Indication if texture maps have been loaded.
     */
    const bool getMeshIsTexturesLoaded(const unsigned int &index);
    
    /**  Gets the path of a diffuse map in a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return The path to a diffuse map.
     */
    const char* getMeshDiffuseMap(const unsigned int &index);
    
    /**  Gets the path of a specular map in a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return The path to a specular map.
     */
    const char* getMeshSpecularMap(const unsigned int &index);
    
private:
    
    std::vector<CMesh> meshes;
    std::string directory;
    
    /**  Processes all of the nodes in the Assimp hierarchy.
     *
     *  @param node A pointer to the node to be processed.
     *  @param scene A pointer to the assimp scene.
     */
    void processNode(aiNode* node, const aiScene* scene);
    
    /**  Loads the mesh from an Assimp node.
     *
     *  @param mesh A pointer to the Assimp mesh in a node.
     *  @param scene A pointer to the assimp scene.
     *  @return The loaded mesh.
     */
    CMesh processMesh(aiMesh* mesh, const aiScene* scene);
    
    /**  Loads a specified material from an Assimp mesh.
     *
     *  @param mat A pointer to a material in an Assimp mesh.
     *  @param type The type of material to be loaded.
     *  @return File path to the texture map.
     */
    std::string loadMaterialTexture(aiMaterial* mat, aiTextureType type);
};

#endif /* AssimpModelLoader_hpp */






