//
//  FBXLoader.cpp
//  ARGame
//
//  Created by James Rogers on 09/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#include "FBXLoader.hpp"

void FBXLoader::loadFBXAnimation(std::string path)
{
    //
    //  Initializing the Importer.
    //
    
    // Create the FBX SDK manager
    FbxManager *lSdkManager = FbxManager::Create();
    
    // Create an IOSettings object. IOSROOT is defined in Fbxiosettingspath.h.
    FbxIOSettings * ios = FbxIOSettings::Create(lSdkManager, IOSROOT );
    lSdkManager->SetIOSettings(ios);
    
    // ... Configure the FbxIOSettings object ...
    // Import options determine what kind of data is to be imported.
    (*(lSdkManager->GetIOSettings())).SetBoolProp(IMP_FBX_MATERIAL,        false);
    (*(lSdkManager->GetIOSettings())).SetBoolProp(IMP_FBX_TEXTURE,         false);
    (*(lSdkManager->GetIOSettings())).SetBoolProp(IMP_FBX_LINK,            false);
    (*(lSdkManager->GetIOSettings())).SetBoolProp(IMP_FBX_SHAPE,           false);
    (*(lSdkManager->GetIOSettings())).SetBoolProp(IMP_FBX_GOBO,            false);
    (*(lSdkManager->GetIOSettings())).SetBoolProp(IMP_FBX_ANIMATION,       true);   // Only load in animation.
    (*(lSdkManager->GetIOSettings())).SetBoolProp(IMP_FBX_GLOBAL_SETTINGS, false);
    
    // Create an importer.
    FbxImporter* lImporter = FbxImporter::Create(lSdkManager, "");
    
    // Initialize the importer.
    bool lImportStatus = lImporter->Initialize(path.data(), -1, lSdkManager->GetIOSettings());
    if(!lImportStatus) {
        printf("Call to FbxImporter::Initialize() failed.\n");
        printf("Error returned: %s\n\n", lImporter->GetStatus().GetErrorString());
        return;
    }
    
    //
    //  Import the scene.
    //
    
    // Create a new scene so it can be populated by the imported file.
    FbxScene* lScene = FbxScene::Create(lSdkManager,"myScene");
    
    // Import the contents of the file into the scene.
    lImporter->Import(lScene);
    
    // Get the root node of the scene.
    FbxNode* lRootNode = lScene->GetRootNode();
    
    // Process the animation
    //processAnimation(lScene->GetRootNode());
    //FbxAnimStack *test = lScene->GetCurrentAnimationStack();
    
    DisplayAnimation(lScene);
    //this->searchNode(lRootNode, lScene);

    
    
    
    // Get animation stack
    /*FbxAnimStack* currAnimStack = lScene->GetSrcObject<FbxAnimStack>(0);
    
    // Get name of animation stack
    FbxString animStackName = currAnimStack->GetName();
    
    // Get animation information
    FbxTakeInfo* takeInfo = lScene->GetTakeInfo(animStackName);
    FbxTime start = takeInfo->mLocalTimeSpan.GetStart();
    FbxTime end = takeInfo->mLocalTimeSpan.GetStop();
    float duration = end.GetFrameCount(FbxTime::eFrames30) - start.GetFrameCount(FbxTime::eFrames30) + 1;
    
    
    for (FbxLongLong i = start.GetFrameCount(FbxTime::eFrames30); i <= end.GetFrameCount(FbxTime::eFrames30); i++)
    {
        FbxTime currTime;
        currTime.SetFrame(i, FbxTime::eFrames30);
        
        //FbxAMatrix currentTransformOffset = inNode->EvaluateGlobalTransform(currTime) * geometryTransform;
    }*/
    
    
    
    
    
    
    
    
    
    // The file has been imported; we can get rid of the importer.
    lImporter->Destroy();
}

void FBXLoader::searchNode(FbxNode *node, FbxScene *scene)
{
    int numAttributes = node->GetNodeAttributeCount();
    for (int i = 0; i < numAttributes; i++)
    {
        FbxNodeAttribute *nodeAttributeFbx = node->GetNodeAttributeByIndex(i);
        FbxNodeAttribute::EType attributeType = nodeAttributeFbx->GetAttributeType();
        
        //switch (attributeType)
        //{
        //    case FbxNodeAttribute::eSkeleton:
        //   {
                // Load keyframe transformations
                this->processAnimation(node, scene);
        //        break;
        //    }
        //}
    }
    
    // Load the child nodes
    int numChildren = node->GetChildCount();
    for(int i = 0; i < numChildren; i++)
    {
        this->searchNode(node->GetChild(i), scene);
    }
}

void FBXLoader::processAnimation(FbxNode *node, FbxScene *scene)
{
    //int numAnimations = scene->GetSrcObjectCount(FBX_TYPE(FbxAnimStack));
    int numAnimations = scene->GetSrcObjectCount<FbxAnimStack>();
    for(int animationIndex = 0; animationIndex < numAnimations; animationIndex++)
    {
       // FbxAnimStack *animStack = scene->GetSrcObject(FBX_TYPE(FbxAnimStack), animationIndex);
        FbxAnimStack *animStack = scene->GetSrcObject<FbxAnimStack>(animationIndex);
        
        FbxAnimEvaluator *animEvaluator = scene->GetAnimationEvaluator();
        FbxString name = animStack->GetName(); // Get the name of the animation if needed
        
        //FbxTakeInfo* takeInfo = scene->GetTakeInfo(name);
        //FbxTime start = takeInfo->mLocalTimeSpan.GetStart();
        //FbxTime end = takeInfo->mLocalTimeSpan.GetStop();
        //float duration = end.GetFrameCount(FbxTime::eFrames30) - start.GetFrameCount(FbxTime::eFrames30) + 1;
        
        // Iterate all the transformation layers of the animation. You can have several layers, for example one for translation, one for rotation, one for scaling and each can have keys at different frame numbers.
        //int numLayers = animStack->GetMemberCount();
        int numLayers = animStack->GetMemberCount<FbxAnimLayer>();
        for (int layerIndex = 0; layerIndex < numLayers; layerIndex++)
        {
            //FbxAnimLayer *animLayer = animStack->GetMember(FBX_TYPE(FbxAnimLayer), layerIndex);
            FbxAnimLayer *animLayer = animStack->GetMember<FbxAnimLayer>(layerIndex);
            //std::string name2 = animLayer->GetName(); // Get the layer's name if needed
            
            FbxAnimCurve *translationCurve = node->LclTranslation.GetCurve(animLayer, FBXSDK_CURVENODE_COMPONENT_X);
            FbxAnimCurve *rotationCurve = node->LclRotation.GetCurve(animLayer);
            FbxAnimCurve *scalingCurve = node->LclScaling.GetCurve(animLayer);
            
            if(translationCurve)
            {
                std::cout << "found :)" << std::endl;
            }
            
            /*if (scalingCurve != 0)
            {
                int numKeys = scalingCurve->KeyGetCount();
                for (int keyIndex = 0; keyIndex < numKeys; keyIndex++)
                {
                    FbxTime frameTime = scalingCurve->KeyGetTime(keyIndex);
                    FbxDouble3 scalingVector = node->EvaluateLocalScaling(frameTime);
                    float x = (float)scalingVector[0];
                    float y = (float)scalingVector[1];
                    float z = (float)scalingVector[2];
                    
                    float frameSeconds = (float)frameTime.GetSecondDouble(); // If needed, get the time of the scaling keyframe, in seconds
                }
            }
            else
            {
                // If this animation layer has no scaling curve, then use the default one, if needed
                FbxDouble3 scalingVector = node->LclScaling.Get();
                float x = (float)scalingVector[0];
                float y = (float)scalingVector[1];
                float z = (float)scalingVector[2];
            }*/
        }
    }
}


void FBXLoader::DisplayAnimation(FbxScene* pScene)
{
    int i;
    for (i = 0; i < pScene->GetSrcObjectCount<FbxAnimStack>(); i++)
    {
        FbxAnimStack* lAnimStack = pScene->GetSrcObject<FbxAnimStack>(i);
        
        FbxString lOutputString = "Animation Stack Name: ";
        lOutputString += lAnimStack->GetName();
        lOutputString += "\n\n";
        FBXSDK_printf(lOutputString);
        
        DisplayAnimation(lAnimStack, pScene->GetRootNode(), true);
        DisplayAnimation(lAnimStack, pScene->GetRootNode());
    }
}


void FBXLoader::DisplayAnimation(FbxAnimStack* pAnimStack, FbxNode* pNode, bool isSwitcher)
{
    int l;
    int nbAnimLayers = pAnimStack->GetMemberCount<FbxAnimLayer>();
    FbxString lOutputString;
    
    lOutputString = "Animation stack contains ";
    lOutputString += nbAnimLayers;
    lOutputString += " Animation Layer(s)\n";
    FBXSDK_printf(lOutputString);
    
    for (l = 0; l < nbAnimLayers; l++)
    {
        FbxAnimLayer* lAnimLayer = pAnimStack->GetMember<FbxAnimLayer>(l);
        
        lOutputString = "AnimLayer ";
        lOutputString += l;
        lOutputString += "\n";
        FBXSDK_printf(lOutputString);
        
        DisplayAnimation(lAnimLayer, pNode, isSwitcher);
    }
}


void FBXLoader::DisplayAnimation(FbxAnimLayer* pAnimLayer, FbxNode* pNode, bool isSwitcher)
{
    int lModelCount;
    FbxString lOutputString;
    
    lOutputString = "     Node Name: ";
    lOutputString += pNode->GetName();
    lOutputString += "\n\n";
    FBXSDK_printf(lOutputString);
    
    DisplayChannels(pNode, pAnimLayer);
    FBXSDK_printf ("\n");
    
    for(lModelCount = 0; lModelCount < pNode->GetChildCount(); lModelCount++)
    {
        DisplayAnimation(pAnimLayer, pNode->GetChild(lModelCount), isSwitcher);
    }
}


void FBXLoader::DisplayChannels(FbxNode* pNode, FbxAnimLayer* pAnimLayer)
{
    FbxAnimCurve* lAnimCurve = NULL;
    
    // Display general curves.
    lAnimCurve = pNode->LclTranslation.GetCurve(pAnimLayer, FBXSDK_CURVENODE_COMPONENT_X);
    if (lAnimCurve)
    {
        FBXSDK_printf("        TX\n");
    }
    lAnimCurve = pNode->LclTranslation.GetCurve(pAnimLayer, FBXSDK_CURVENODE_COMPONENT_Y);
    if (lAnimCurve)
    {
        FBXSDK_printf("        TY\n");
    }
    lAnimCurve = pNode->LclTranslation.GetCurve(pAnimLayer, FBXSDK_CURVENODE_COMPONENT_Z);
    if (lAnimCurve)
    {
        FBXSDK_printf("        TZ\n");
    }
}

