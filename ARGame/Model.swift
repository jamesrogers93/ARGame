//
//  Model.swift
//  ARGame
//
//  Created by James Rogers on 19/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation
import GLKit

class Model
{
    private var meshes: Array<Mesh> = Array()
    
    init(_ meshes: Array<Mesh>)
    {
        self.meshes = meshes
    }
    
    // Draws the model, and thus all its meshes
    public func draw(_ effect: Effect)
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].draw(effect);
        }
    }
    
    public func destroy()
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].destroy();
        }
    }
}
