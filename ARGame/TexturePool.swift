//
//  TexturePool.swift
//  ARGame
//
//  Created by James Rogers on 09/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class TexturePool
{
    static var asyncTextureLoader: GLKTextureLoader? = nil
    
    static var textures: [String: GLKTextureInfo] = [String: GLKTextureInfo]()
    
    static var queue: DispatchQueue = DispatchQueue(label: "textureLoaderQueue")
    
    public static func initaliseAsyncTextureLoader(sharegroup: EAGLSharegroup)
    {
        TexturePool.asyncTextureLoader = GLKTextureLoader(sharegroup: sharegroup)
    }
    
    public static func textureCallback(_ texture: GLKTextureInfo?, _ error: Error?)
    {
        
    }
}
