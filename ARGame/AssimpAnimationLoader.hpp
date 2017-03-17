//
//  AssimpAnimationLoader.hpp
//  ARGame
//
//  Created by James Rogers on 16/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#ifndef AssimpAnimationLoader_hpp
#define AssimpAnimationLoader_hpp

// STL
#include <string>
#include <iostream>
#include <vector>

// Assimp
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>


class AssimpAnimationLoader
{
public:
    
    AssimpAnimationLoader(){}
    
    /**  Loads a animation set using the Assimp library.
     *
     *  @param path File path to the animation set to be loaded.
     */
    void loadAssimpAnimation(std::string path);
    
private:
    

};

#endif /* AssimpAnimationLoader_hpp */
