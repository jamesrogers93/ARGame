//
//  FBXLoader.h
//  ARGame
//
//  Created by James Rogers on 09/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#ifndef FBXLoader_hpp
#define FBXLoader_hpp

// STL
#include <iostream>
#include <string>
#include <vector>

// FBX
#include <fbxsdk.h>
#include <fbxsdk/fileio/fbxiosettings.h>

struct CAnimationChannel1
{
    std::string name;
    std::vector<float> positions;
    std::vector<float> scales;
    std::vector<float> rotations;
    
    CAnimationChannel1(){}
    
    CAnimationChannel1(std::string name, std::vector<float> positions, std::vector<float> scales, std::vector<float> rotations)
    {
        this->name = name;
        this->positions = positions;
        this->scales = scales;
        this->rotations = rotations;
    }
};

struct CAnimation1
{
    float duration;
    float ticksPerSecond;
    std::vector<CAnimationChannel1> channels;
    
    CAnimation1() {}
    
    CAnimation1(float duration, float ticksPerSecond, std::vector<CAnimationChannel1> channels)
    {
        this->duration = duration;
        this->ticksPerSecond = ticksPerSecond;
        this->channels = channels;
    }
};

class FBXLoader
{
public:
    FBXLoader(){}
    
    /**  Loads an animation using the FBX sdk.
     *
     *  @param path File path to the animation to be loaded.
     */
    void loadFBXAnimation(std::string path);
    
private:
    
    std::vector<CAnimation1> animations;
    
    void searchNode(FbxNode *node, FbxScene *scene);
    
    /**  Loads an animation in FBX.
     *
     *  @param node A pointer to the node to be processed.
     *  @param scene A pointer to the FBX scene.
     */
    void processAnimation(FbxNode *node, FbxScene *scene);
    
    
    
    void DisplayAnimation(FbxScene* pScene);
    void DisplayAnimation(FbxAnimStack* pAnimStack, FbxNode* pNode, bool isSwitcher = false);
    void DisplayAnimation(FbxAnimLayer* pAnimLayer, FbxNode* pNode, bool isSwitcher = false);
    void DisplayChannels(FbxNode* pNode, FbxAnimLayer* pAnimLayer);
};

#endif /* FBXLoader_hpp */
