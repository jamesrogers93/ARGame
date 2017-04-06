//
//  Entity.swift
//  ARGame
//
//  Created by James Rogers on 06/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class Entity
{
 
    /**
     The OpenGL geometry
    */
    private let glModel: Model
    
    /**
     The transformation model matrix.
     */
    private var model:GLKMatrix4 = GLKMatrix4Identity
    
    /**
     The translation matrix.
     */
    private var translation:GLKMatrix4 = GLKMatrix4Identity
    
    /**
     The scale matrix.
     */
    private var scale:GLKMatrix4 = GLKMatrix4Identity
    
    /**
     The rotation matrix.
     */
    private var rotation:GLKMatrix4 = GLKMatrix4Identity
    
    init(_ _glModel: Model)
    {
        self.glModel = _glModel
    }
    
}
