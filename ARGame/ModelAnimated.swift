//
//  ModelAnimated.swift
//  ARGame
//
//  Created by James Rogers on 21/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class ModelAnimated: Model {
    
    private var animations: Array<Animation>
    
    /**
     Initalise a Animated Model with an array of Meshes and animations.
     */
    init(_ _meshes: Array<Mesh>, _ _animations: Array<Animation>)
    {
        self.animations = _animations
        
        super.init(_meshes)
        
    }
}
