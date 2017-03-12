//
//  Model.swift
//  ARGame
//
//  Created by James Rogers on 19/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation
import GLKit

/**
 Maintains an array of Meshes that are associated with each other.
 */
class Model
{
    private var meshes: Array<Mesh> = Array()
    
    /**
     Initalise a Model with an array of Meshes.
     */
    init(_ meshes: Array<Mesh>)
    {
        self.meshes = meshes
    }
    
    /**
     Draws the meshes in the Model.
     
     - parameters:
        - effect: The effect to draw the meshes.
     */
    public func draw(_ effect: Effect)
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].draw(effect);
        }
    }
    
    /**
     Destroys the meshes.
     */
    public func destroy()
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].destroy();
        }
    }
}
