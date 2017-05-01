//
//  FBXLoaderCInterface.cpp
//  ARGame
//
//  Created by James Rogers on 09/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#include "FBXLoaderCInterface.h"
#include "FBXLoader.hpp"

const void* flLoadFBXAnimation(const char *path)
{
    // Create instance of FBXLoader
    FBXLoader *loader = new FBXLoader();
    
    // Load the model
    loader->loadFBXAnimation(path);
    
    // Return a void pointer to loader
    return (void *)loader;
}

