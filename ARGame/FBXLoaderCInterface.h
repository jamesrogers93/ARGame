//
//  FBXLoaderCInterface.hpp
//  ARGame
//
//  Created by James Rogers on 09/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#ifndef FBXLoaderCInterface_h
#define FBXLoaderCInterface_h

#ifdef __cplusplus
extern "C" {
#endif
    
    //
    //  C - C++ Interface methods
    //
    
    /**  Constructs an instance of FBXLoader and loads an animation.
     *
     *  @param path  A path which points to the animation to be loaded.
     *  @return A void pointer to the instance of the FBXLoader.
     */
    const void* flLoadFBXAnimation(const char *path);
    
#ifdef __cplusplus
}
#endif

#endif /* FBXLoaderCInterface_hpp */
