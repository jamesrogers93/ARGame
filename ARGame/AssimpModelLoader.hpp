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

struct CAnimationChannel
{
    std::string name;
    std::vector<float> positions;
    std::vector<float> scales;
    std::vector<float> rotations;
    
    CAnimationChannel(){}
    
    CAnimationChannel(std::string name, std::vector<float> positions, std::vector<float> scales, std::vector<float> rotations)
    {
        this->name = name;
        this->positions = positions;
        this->scales = scales;
        this->rotations = rotations;
    }
};

struct CAnimation
{
    double duration;
    double ticksPerSecond;
    std::vector<CAnimationChannel> channels;
    
    CAnimation() {}
    
    CAnimation(double duration, double ticksPerSecond, std::vector<CAnimationChannel> channels)
    {
        this->duration = duration;
        this->ticksPerSecond = ticksPerSecond;
        this->channels = channels;
    }
};

struct CBone
{
    std::string name;
    
    std::vector<unsigned int> vertexIds;
    std::vector<float> weights;
    float offsetMatrix[16];
    
    CBone(std::string name, std::vector<unsigned int> vertexIds, std::vector<float> weights, float *offsetMatrix)
        : name(name), vertexIds(vertexIds), weights(weights)
    {
        memcpy(this->offsetMatrix, offsetMatrix, sizeof(this->offsetMatrix));
    }
};

struct CMaterial
{
    std::string diffuseTex = "", specularTex = "";
    float diffuseCol[4] = {0.0f}, specularCol[4] = {0.0f};
    float shininess;
    
    CMaterial(){}
    CMaterial(std::string diffuseTex, std::string specularTex, float *diffuseCol, float *specularCol, float shininess)
    : diffuseTex(diffuseTex), specularTex(specularTex), shininess(shininess)
    {
        memcpy(this->diffuseCol, diffuseCol, sizeof(this->diffuseCol));
        memcpy(this->specularCol, specularCol, sizeof(this->specularCol));
    }
};

struct CMesh
{
    std::vector<float> vertices;
    std::vector<unsigned int> indices;
    std::vector<CBone> bones;
    
    CMaterial material;
    
    CMesh(std::vector<float> vertices, std::vector<unsigned int> indices, CMaterial material = CMaterial(), std::vector<CBone> bones = std::vector<CBone>())
        : vertices(vertices), indices(indices), material(material), bones(bones)
    {
    }
};

class AssimpModelLoader
{
public:
    
    AssimpModelLoader(){}
    
    /**  Loads a static model using the Assimp library.
     *
     *  @param path File path to the model to be loaded.
     */
    void loadStaticAssimpModel(std::string path);
    
    /**  Loads an animated model using the Assimp library.
     *
     *  @param path File path to the model to be loaded.
     */
    void loadAnimatedAssimpModel(std::string path);
    
    /**  Returns the number of meshes.
     *
     *  @return Number of meshes.
     */
    const unsigned int getNumMeshes();
    
    /**  Returns the number of animations.
     *
     *  @return Number of animations.
     */
    const unsigned int getNumAnimations();
    
    /**  Returns the number of vertices in a specified mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of vertices in the mesh. Note: Since each element is stored seperatly, the number this method returns should be divided by 9 to retrive the number of vertex vectors.
     */
    const unsigned int getNumVerticesInMesh(const unsigned int &index);
    
    /**  Returns the number of indices in a specified mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of indices in the mesh.
     */
    const unsigned int getNumIndicesInMesh(const unsigned int &index);
    
    /**  Returns the number of bones in a specified mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return Number of bones in the mesh.
     */
    const unsigned int getNumBonesInMesh(const unsigned int &index);
    
    /**  Returns the number of channels in a specified animation.
     *
     *  @param index Index of the animation in the animations array.
     *  @return The number of channels in the animation.
     */
    const unsigned int getNumChannelsInAnimation(const unsigned int &index);
    
    /**  Returns the number of positions in a channel in a specified animation.
     *
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The number of positions in a channel. Note: Since each element is stored seperatly, the number this method returns should be divided by 3 to retrive the number of position vectors.
     */
    const unsigned int getNumPositionsInChannel(const unsigned int &index, const unsigned int &channelIndex);
    
    /**  Returns the number of scales in a channel in a specified animation.
     *
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The number of scales in the animation. Note: Since each element is stored seperatly, the number this method returns should be divided by 3 to retrive the number of scale vectors.
     */
    const unsigned int getNumScalesInChannel(const unsigned int &index, const unsigned int &channelIndex);
    
    /**  Returns the number of rotations in a specified animation.
     *
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The number of rotations in the animation. Note: Since each element is stored seperatly, the number this method returns should be divided by 9 to retrive the number of rotation matrices.
     */
    const unsigned int getNumRotationsInChannel(const unsigned int &index, const unsigned int &channelIndex);
    
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
    
    /**  Returns a char array of a specified bone name in a mesh.
     *
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return A char array of the bone name.
     */
    const char* getMeshBoneName(const unsigned int &meshIndex, const unsigned int &boneIndex);
    
    /**  Returns the number of vertex ids in specified bone name in a mesh.
     *
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return The number of vertex ids in the bone.
     */
    const unsigned int getNumMeshBoneVertexIds(const unsigned int &meshIndex, const unsigned int &boneIndex);
    
    /**  Returns the vertex ids of a specified bone in a mesh.
     *
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return An unsigned int array of vertex ids.
     */
    const unsigned int* getMeshBoneVertexIds(const unsigned int &meshIndex, const unsigned int &boneIndex);
    
    /**  Returns the number of weights in specified bone name in a mesh.
     *
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return The number of weights in the bone.
     */
    const unsigned int getNumMeshBoneWeights(const unsigned int &meshIndex, const unsigned int &boneIndex);
    
    /**  Returns the weights of a specified bone in a mesh.
     *
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return A float array of the weights.
     */
    const float* getMeshBoneWeights(const unsigned int &meshIndex, const unsigned int &boneIndex);
    
    /**  Returns the offset matrix4x4 of a specified bone in a mesh.
     *
     *  @param meshIndex Index of the mesh in the meshes array.
     *  @param boneIndex Index of the bone in the mesh.
     *  @return A 16 element float array of the offset matrix.
     */
    const float* getMeshBoneOffsetMatrix(const unsigned int &meshIndex, const unsigned int &boneIndex);
    
    /**  Returns a bool indicating if a diffuse map has been loaded for a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return Indication if a diffuse map has been loaded.
     */
    const bool getMeshIsDiffuseMapLoaded(const unsigned int &index);
    
    /**  Gets the path of a diffuse map in a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return The path to a diffuse map.
     */
    const char* getMeshDiffuseMap(const unsigned int &index);
    
    /**  Returns a bool indicating if a specular map has been loaded for a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return Indication if a specular map has been loaded.
     */
    const bool getMeshIsSpecularMapLoaded(const unsigned int &index);
    
    /**  Gets the path of a specular map in a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return The path to a specular map.
     */
    const char* getMeshSpecularMap(const unsigned int &index);
    
    /**  Gets the vector4 of a diffuse colour in a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return The vector4 of a diffuse colour.
     */
    const float* getMeshDiffuseCol(const unsigned int &index);
    
    /**  Gets the vector4 of a specular colour in a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return The vector4 of a specular colour.
     */
    const float* getMeshSpecularCol(const unsigned int &index);
    
    /**  Gets the shininess of a mesh.
     *
     *  @param index Index of the mesh in the meshes array.
     *  @return The shininess value of the mesh.
     */
    const float getMeshShininess(const unsigned int &index);
    
    /**  Gets the duration of an animation.
     *
     *  @param index Index of the animation in the animations array.
     *  @return The duration of the animation.
     */
    const double getAnimationDuration(const unsigned int &index);
    
    /**  Gets the ticks per second of an animation.
     *
     *  @param index Index of the animation in the animations array.
     *  @return The ticks per second of the animation.
     */
    const double getAnimationTicksPerSecond(const unsigned int &index);
    
    /**  Gets the name of a animation channel.
     *
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The name of the animation channel.
     */
    const char* getAnimationChannelName(const unsigned int &index, unsigned int &channelIndex);
    
    /**  Gets the positions in an animation channel.
     *
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The positions of the animation channel. Note: Every three contiguos elements are an xyz position vector.
     */
    const float* getAnimationChannelPositions(const unsigned int &index, unsigned int &channelIndex);
    
    /**  Gets the scales in an animation channel.
     *
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The scales of the animation channel. Note: Every three contiguos elements are an xyz scale vector.
     */
    const float* getAnimationChannelScales(const unsigned int &index, unsigned int &channelIndex);
    
    /**  Gets the quaternion rotations in an animation channel.
     *
     *  @param index Index of the animation in the animations array.
     *  @param channelIndex Index of the channel in the animation.
     *  @return The rotations of the animation channel. Note: Every 9 contiguos elements are a 3x3 rotation matrix.
     */
    const float* getAnimationChannelRotations(const unsigned int &index, unsigned int &channelIndex);
    
private:
    
    std::vector<CMesh> meshes;
    std::vector<CAnimation> animations;
    std::string directory;
    
    /**  Processes all of the nodes in the Assimp hierarchy.
     *
     *  @param node A pointer to the node to be processed.
     *  @param scene A pointer to the assimp scene.
     */
    void processNode(aiNode* node, const aiScene* scene, const bool &loadBones);
    
    /**  Loads the mesh from an Assimp node.
     *
     *  @param mesh A pointer to the Assimp mesh in a node.
     *  @param scene A pointer to the assimp scene.
     *  @return The loaded mesh.
     */
    CMesh processMesh(aiMesh* mesh, const aiScene* scene, const bool &loadBones);
    
    /**  Loads a specified material from an Assimp mesh.
     *
     *  @param mat A pointer to a material in an Assimp mesh.
     *  @param type The type of material to be loaded.
     *  @return File path to the texture map.
     */
    std::string loadMaterialTexture(aiMaterial* mat, aiTextureType type);
    
    /**  Loads an animation in Assimp.
     *
     *  @param animation A pointer to the animation to be processed.
     *  @param scene A pointer to the assimp scene.
     */
    void processAnimation(aiAnimation* animation, const aiScene* scene);
    
};

#endif /* AssimpModelLoader_hpp */






