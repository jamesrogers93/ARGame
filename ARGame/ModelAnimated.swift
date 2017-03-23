//
//  ModelAnimated.swift
//  ARGame
//
//  Created by James Rogers on 21/03/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class ModelAnimated
{
    
    private var meshes: Array<MeshAnimated> = Array()
    private var animations: Array<Animation> = Array()
    
    /**
     Initalise a Animated Model with an array of Meshes and animations.
     */
    init(_ _meshes: Array<MeshAnimated>, _ _animations: Array<Animation>)
    {
        self.animations = _animations
        self.meshes = _meshes
        
    }
    
    /**
     Draws the animated meshes in the Model.
     
     - parameters:
     - effect: The effect to draw the meshes.
     */
    public func draw(_ effect: EffectMaterial)
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].draw(effect);
        }
    }
    
    /**
     Destroys the animated meshes.
     */
    public func destroy()
    {
        for i in 0..<self.meshes.count
        {
            self.meshes[i].destroy();
        }
    }
}
